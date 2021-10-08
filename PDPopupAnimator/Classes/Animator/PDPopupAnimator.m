//
//  PDPopupAnimator.m
//  PDPopupAnimator
//
//  Created by liang on 2021/10/8.
//

#import "PDPopupAnimator.h"

@implementation PDPopupAnimator

- (instancetype)initWithPopupView:(UIView *)popupView
                      contentView:(UIView *)contentView
                   backgroundView:(UIView *)backgroundView {
    self = [super init];
    if (self) {
        _popupView = popupView;
        _contentView = contentView;
        _backgroundView = backgroundView;
    }
    return self;
}

- (void)showInView:(UIView *)inView animated:(BOOL)animated {
    [self showInView:inView animated:animated completion:nil];
}

- (void)showInView:(UIView *)inView animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    NSAssert(NO, @"You must override this method!");
}

- (void)dismissWithAnimated:(BOOL)animated {
    [self dismissWithAnimated:animated completion:nil];
}

- (void)dismissWithAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    NSAssert(NO, @"You must override this method!");
}

@end
