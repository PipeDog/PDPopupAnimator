//
//  PDPopupUtil.m
//  PDPopupAnimator
//
//  Created by liang on 2021/2/24.
//

#import "PDPopupUtil.h"

static UIViewController *_PDGetTopViewController(UIViewController *controller);

#pragma mark - External Functions
UIWindow *PDGetKeyWindow(void) {
    UIWindow *keyWindow = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        keyWindow = [[UIApplication sharedApplication].delegate window];
    }
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    return keyWindow;
}

UIViewController *PDGetTopViewController(void) {
    UIViewController *rootViewController, *topViewController;
    rootViewController = PDGetKeyWindow().rootViewController;
    topViewController = _PDGetTopViewController(rootViewController);
    
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}

#pragma mark - Internal Functions
static UIViewController *_PDGetTopViewController(UIViewController *controller) {
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return _PDGetTopViewController([(UINavigationController *)controller topViewController]);
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        return _PDGetTopViewController([(UITabBarController *)controller selectedViewController]);
    } else {
        return controller;
    }
    return nil;
}
