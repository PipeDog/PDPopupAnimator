//
//  PDPopupWidget.h
//  PDPopupAnimator
//
//  Created by liang on 2021/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    const char *widgetname;
    const char *classname;
} PDPopupWidgetName;

#define __PD_REGISTER_POPUP_WIDGET_EX(widgetname, classname)    \
__attribute__((used, section("__DATA , _pd_popupwidgets")))     \
static const PDPopupWidgetName __NE_exp_widget_##widgetname##__ = {#widgetname, #classname};

#define PD_REGISTER_POPUP_WIDGET(widgetname, classname) __PD_REGISTER_POPUP_WIDGET_EX(widgetname, classname)

@protocol PDPopupWidget <NSObject>

@end

@protocol PDPopupViewWidget <PDPopupWidget>

- (void)showInView:(UIView * _Nullable)inView animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
- (void)dismissWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

@optional
- (void)showInView:(UIView * _Nullable)inView animated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated;

@end

@protocol PDPopupControllerWidget <PDPopupWidget>

- (void)showInController:(UIViewController * _Nullable)inController animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
- (void)dismissWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

@optional
- (void)showInController:(UIViewController * _Nullable)inController animated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
