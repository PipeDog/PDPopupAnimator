//
//  PDPopupManager.m
//  PDPopupAnimator
//
//  Created by liang on 2021/2/26.
//
//  https://nshipster.cn/type-encodings/
//

#import "PDPopupManager.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/getsect.h>
#import "PDPopupWidget.h"
#import "PDWidgetDataManager.h"
#import "PDPopupWidgetQueue.h"
#import "PDPopupUtil.h"

static void showViewWidget(id, SEL, UIView *, BOOL, void (^)(void));
static void dismissViewWidget(id, SEL, BOOL, void (^)(void));
static void showControllerWidget(id, SEL, UIViewController *, BOOL, void (^)(void));
static void dismissControllerWidget(id, SEL, BOOL, void (^)(void));

typedef NS_ENUM(NSInteger, PDPopupWidgetType) {
    PDPopupWidgetTypeUnknown    = 0,
    PDPopupWidgetTypeView       = 1,
    PDPopupWidgetTypeController = 2,
};

static PDPopupWidgetType NEGetPopupWidgetType(Class widgetClass) {
    if ([widgetClass isSubclassOfClass:[UIView class]] &&
        [widgetClass conformsToProtocol:@protocol(PDPopupViewWidget)] &&
        [widgetClass instancesRespondToSelector:@selector(showInView:animated:completion:)] &&
        [widgetClass instancesRespondToSelector:@selector(dismissWithAnimated:completion:)]) {
        return PDPopupWidgetTypeView;
    }
    
    if ([widgetClass isSubclassOfClass:[UIViewController class]] &&
        [widgetClass conformsToProtocol:@protocol(PDPopupControllerWidget)] &&
        [widgetClass instancesRespondToSelector:@selector(showInController:animated:completion:)] &&
        [widgetClass instancesRespondToSelector:@selector(dismissWithAnimated:completion:)]) {
        return PDPopupWidgetTypeController;
    }
    
    return PDPopupWidgetTypeUnknown;
}

@interface PDPopupManager ()

@property (nonatomic, strong) NSMutableArray<Class> *widgetClasses;
@property (nonatomic, strong) PDPopupWidgetQueue *queue;
@property (nonatomic, strong) id<PDPopupWidget> currentPopupWidget;

@end

@implementation PDPopupManager

static PDPopupManager *__defaultManager;

+ (PDPopupManager *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__defaultManager == nil) {
            __defaultManager = [[self alloc] init];
        }
    });
    return __defaultManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (__defaultManager == nil) {
            __defaultManager = [super allocWithZone:zone];
        }
    }
    return __defaultManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _widgetClasses = [NSMutableArray array];
        _queue = [[PDPopupWidgetQueue alloc] initWithName:@"com.popup-order.queue"];
    }
    return self;
}

- (void)registerWidgetClass:(Class)widgetClass {
    PDPopupWidgetType widgetType = NEGetPopupWidgetType(widgetClass);
    switch (widgetType) {
        case PDPopupWidgetTypeView:
        case PDPopupWidgetTypeController: {
            [_widgetClasses addObject:widgetClass];
        } break;
        default: {
            NSAssert(NO, @"Invalid argument `widgetClass`!");
        } break;
    }
}

- (void)installWidgets {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _installWidgets];
    });
}

#pragma mark - Private Methods
- (void)_installWidgets {
    Dl_info info; dladdr(&__defaultManager, &info);
    NSMutableDictionary *widgetMap = [NSMutableDictionary dictionary];
    
#ifdef __LP64__
    uint64_t addr = 0; const uint64_t mach_header = (uint64_t)info.dli_fbase;
    const struct section_64 *section = getsectbynamefromheader_64((void *)mach_header, "__DATA", "_pd_popupwidgets");
#else
    uint32_t addr = 0; const uint32_t mach_header = (uint32_t)info.dli_fbase;
    const struct section *section = getsectbynamefromheader((void *)mach_header, "__DATA", "_pd_popupwidgets");
#endif
    
    if (section == NULL) { return; }
    
    for (addr = section->offset; addr < section->offset + section->size; addr += sizeof(PDPopupWidgetName)) {
        PDPopupWidgetName *module = (PDPopupWidgetName *)(mach_header + addr);
        if (!module) { continue; }
                
        NSString *widgetname = [NSString stringWithUTF8String:module->widgetname];
        NSString *classname = [NSString stringWithUTF8String:module->classname];
        
        if (widgetMap[widgetname]) {
            continue;
        }
        
        Class widgetClass = NSClassFromString(classname);
        [self _installWidget:widgetClass];
        widgetMap[widgetname] = widgetClass;
    }
    
    _widgetMap = [widgetMap copy];
}

- (void)_installWidget:(Class)widgetClass {
    PDPopupWidgetType widgetType = NEGetPopupWidgetType(widgetClass);
    switch (widgetType) {
        case PDPopupWidgetTypeView: {
            [self _installViewWidget:widgetClass];
        } break;
        case PDPopupWidgetTypeController: {
            [self _installControllerWidget:widgetClass];
        } break;
        default: {
            NSAssert(NO, @"Invalid argument `widgetClass`!");
        } break;
    }
}

- (void)_installViewWidget:(Class)widgetClass {
    SEL showSel = @selector(showInView:animated:completion:);
    SEL dismissSel = @selector(dismissWithAnimated:completion:);
    
    IMP originShowIMP = class_getMethodImplementation(widgetClass, showSel);
    IMP originDismissIMP = class_getMethodImplementation(widgetClass, dismissSel);
            
    class_replaceMethod(widgetClass, showSel, (IMP)showViewWidget, "v@:@c@?");
    class_replaceMethod(widgetClass, dismissSel, (IMP)dismissViewWidget, "v@:c@?");
    
    PDWidgetDataManager *dataManager = [PDWidgetDataManager defaultManager];
    [dataManager bindIMP:originShowIMP forSelector:showSel inClass:widgetClass];
    [dataManager bindIMP:originDismissIMP forSelector:dismissSel inClass:widgetClass];
}

- (void)_installControllerWidget:(Class)widgetClass {
    SEL showSel = @selector(showInController:animated:completion:);
    SEL dismissSel = @selector(dismissWithAnimated:completion:);
    
    IMP originShowIMP = class_getMethodImplementation(widgetClass, showSel);
    IMP originDismissIMP = class_getMethodImplementation(widgetClass, dismissSel);
    
    class_replaceMethod(widgetClass, showSel, (IMP)showControllerWidget, "v@:@c@?");
    class_replaceMethod(widgetClass, dismissSel, (IMP)dismissControllerWidget, "v@:c@?");
        
    PDWidgetDataManager *dataManager = [PDWidgetDataManager defaultManager];
    [dataManager bindIMP:originShowIMP forSelector:showSel inClass:widgetClass];
    [dataManager bindIMP:originDismissIMP forSelector:dismissSel inClass:widgetClass];
}

@end

void NERegisterPopupWidgetClass(Class widgetClass) {
    [[PDPopupManager defaultManager] registerWidgetClass:widgetClass];
}

static void showViewWidget(id self, SEL _cmd, UIView *inView, BOOL animated, void (^completion)(void)) {
    inView = inView ?: PDGetTopViewController().view;
    inView = inView ?: PDGetKeyWindow();
    completion = completion ?: ^{};
    
    PDPopupManager *popupManager = [PDPopupManager defaultManager];
    PDWidgetDataManager *dataManager = [PDWidgetDataManager defaultManager];
    
    if (!popupManager.currentPopupWidget) {
        IMP imp = [dataManager impForSelector:_cmd inClass:[self class]];
        (((void (*)(id, SEL, id, BOOL, void (^)(void)))(void *) imp)(self, _cmd, inView, animated, completion));
        
        popupManager.currentPopupWidget = self;
        return;
    }
    
    [dataManager bindArguments:@[inView, @(animated), completion] forSelector:_cmd inObject:self];
    [popupManager.queue addWidget:self];
}

static void dismissViewWidget(id self, SEL _cmd, BOOL animated, void (^completion)(void)) {
    PDPopupManager *popupManager = [PDPopupManager defaultManager];
    PDWidgetDataManager *dataManager = [PDWidgetDataManager defaultManager];

    BOOL widgetInQueue = [popupManager.queue containsWidget:self];
    if (widgetInQueue) {
        [popupManager.queue removeWidget:self];
        [dataManager invalidArgumentsForObject:self];
        return;
    }
    
    void (^showNextBlock)(void) = ^{
        id<PDPopupWidget> nextWidget = [popupManager.queue popHeadWidget];
        if (!nextWidget) { return; }
        
        PDPopupWidgetType widgetType = NEGetPopupWidgetType([nextWidget class]);
        switch (widgetType) {
            case PDPopupWidgetTypeView: {
                NSArray *arguments = [dataManager argumentsForSelector:@selector(showInView:animated:completion:) inObject:nextWidget];
                [(id<PDPopupViewWidget>)nextWidget showInView:arguments[0] animated:[arguments[1] boolValue] completion:arguments[2]];
            } break;
            case PDPopupWidgetTypeController: {
                NSArray *arguments = [dataManager argumentsForSelector:@selector(showInController:animated:completion:) inObject:nextWidget];
                [(id<PDPopupControllerWidget>)nextWidget showInController:arguments[0] animated:[arguments[1] boolValue] completion:arguments[2]];
            } break;
            default: {
                NSAssert(NO, @"Invalid argument `widgetClass`!");
            } break;
        }
    };
    
    IMP imp = [dataManager impForSelector:_cmd inClass:[self class]];
    (((void (*)(id, SEL, BOOL, void (^)(void)))(void *) imp)(self, _cmd, animated, ^{
        popupManager.currentPopupWidget = nil;
        !completion ?: completion();
        showNextBlock();
    }));
}

static void showControllerWidget(id self, SEL _cmd, UIViewController *inController, BOOL animated, void (^completion)(void)) {
    inController = inController ?: PDGetTopViewController();
    completion = completion ?: ^{};
    
    PDPopupManager *popupManager = [PDPopupManager defaultManager];
    PDWidgetDataManager *dataManager = [PDWidgetDataManager defaultManager];
    
    if (!popupManager.currentPopupWidget) {
        // real invoke show action
        IMP imp = [dataManager impForSelector:_cmd inClass:[self class]];
        (((void (*)(id, SEL, id, BOOL, void (^)(void)))(void *) imp)(self, _cmd, inController, animated, completion));
        
        popupManager.currentPopupWidget = self;
        return;
    }
    
    [dataManager bindArguments:@[inController, @(animated), completion] forSelector:_cmd inObject:self];
    [popupManager.queue addWidget:self];
}

static void dismissControllerWidget(id self, SEL _cmd, BOOL animated, void (^completion)(void)) {
    dismissViewWidget(self, _cmd, animated, completion);
}
