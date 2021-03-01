//
//  PDWidgetDataManager.m
//  PDPopupAnimator
//
//  Created by liang on 2021/3/1.
//

#import "PDWidgetDataManager.h"
#import <objc/runtime.h>

#define NEFormatWidgetKey(obj) [NSString stringWithFormat:@"%lu", [anObject hash]]

@interface NEIMPProxy : NSObject

@property (nonatomic, assign, readonly) IMP imp;

@end

@implementation NEIMPProxy

- (instancetype)initWithIMP:(IMP)imp {
    self = [super init];
    if (self) {
        _imp = imp;
    }
    return self;
}

@end

@interface PDWidgetDataManager ()

/*
    {
        object1: {
            sel1: [arguments...],
            sel2: [arguments...],
            ...
        },
        object1: {
            sel1: [arguments...],
            sel2: [arguments...],
            ...
        },
        ...
    }
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary *> *objectMap;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation PDWidgetDataManager

static PDWidgetDataManager *__defaultManager;

+ (PDWidgetDataManager *)defaultManager {
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
        _objectMap = [NSMutableDictionary dictionary];
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)bindIMP:(IMP)imp forSelector:(SEL)sel inClass:(Class)aClass {
    NEIMPProxy *impProxy = [[NEIMPProxy alloc] initWithIMP:imp];
    objc_setAssociatedObject(aClass, sel, impProxy, OBJC_ASSOCIATION_RETAIN);
}

- (IMP)impForSelector:(SEL)sel inClass:(Class)aClass {
    NEIMPProxy *impProxy = objc_getAssociatedObject(aClass, sel);
    return impProxy.imp;
}

- (void)bindArguments:(NSArray *)arguments forSelector:(SEL)sel inObject:(id)anObject {
    [self.lock lock];
    NSMutableDictionary *dataMap = [self dataMapForObject:anObject];
    dataMap[NSStringFromSelector(sel)] = arguments;
    [self.lock unlock];
}

- (NSArray *)argumentsForSelector:(SEL)sel inObject:(id)anObject {
    [self.lock lock];
    NSMutableDictionary *dataMap = [self dataMapForObject:anObject];
    NSArray *arguments = dataMap[NSStringFromSelector(sel)];
    [self.lock unlock];
    return arguments;
}

- (void)invalidArgumentsForObject:(id)anObject {
    [self.lock lock];
    NSString *key = NEFormatWidgetKey(anObject);
    [self.objectMap removeObjectForKey:key];
    [self.lock unlock];
}

#pragma mark - Private Methods
- (NSMutableDictionary *)dataMapForObject:(id)anObject {
    [self.lock lock];
    NSString *key = NEFormatWidgetKey(anObject);
    NSMutableDictionary *dataMap = self.objectMap[key];
    if (!dataMap) {
        dataMap = [NSMutableDictionary dictionary];
        self.objectMap[key] = dataMap;
    }
    [self.lock unlock];
    return dataMap;
}

@end
