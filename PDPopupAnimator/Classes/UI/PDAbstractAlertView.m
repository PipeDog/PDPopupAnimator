//
//  PDAbstractAlertView.m
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/2/25.
//  Copyright © 2021 liang. All rights reserved.
//

#import "PDAbstractAlertView.h"
#import "PDPopupBackgroundView.h"
#import "PDAlertAnimator.h"
#import "PDActionSheetAnimator.h"
#import "PDPopupUtil.h"

@interface PDAbstractAlertView () <PDPopupAnimatorDelegate> {
    CGRect _containerBounds;
}

@property (nonatomic, strong) PDPopupAnimator *animator;
@property (nonatomic, strong) PDPopupBackgroundView *backgroundView;

@end

@implementation PDAbstractAlertView

- (instancetype)initWithStyle:(PDAlertViewStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _preferredStyle = style;
        _dismissWhenHitBackground = (_preferredStyle == PDAlertViewStyleActionSheet);
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Public Methods
- (void)showInView:(UIView *)inView animated:(BOOL)animated {
    [self showInView:inView animated:animated completion:nil];
}

- (void)showInView:(UIView *)inView animated:(BOOL)animated completion:(void (^)(void))completion {
    inView = inView ?: PDGetTopViewController().view;
    inView = inView ?: PDGetKeyWindow();
    _containerBounds = inView.bounds;
    
    [self.animator showInView:inView animated:animated completion:^(BOOL finished) {
        !completion ?: completion();
    }];
}

- (void)dismissWithAnimated:(BOOL)animated {
    [self dismissWithAnimated:animated completion:nil];
}

- (void)dismissWithAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self.animator dismissWithAnimated:animated completion:^(BOOL finished) {
        !completion ?: completion();
    }];
}

#pragma mark - PDPopupAnimatorDelegate
- (CGRect)contentViewFrameInAnimator:(__kindof PDPopupAnimator *)animator {
    return [self contentViewRectForBounds:_containerBounds];
}

- (NSTimeInterval)showAnimationDurationInAnimator:(__kindof PDPopupAnimator *)animator {
    return 0.25f;
}

- (NSTimeInterval)dismissAnimationDurationInAnimator:(__kindof PDPopupAnimator *)animator {
    return 0.25f;
}

#pragma mark - Override Methods
- (UIView *)contentView {
    NSAssert(NO, @"Method `- [PDAbstractAlertView contentView] must be override!`");
    return nil;
}

- (CGRect)contentViewRectForBounds:(CGRect)bounds {
    NSAssert(NO, @"Method `- [PDAbstractAlertView contentViewRectForBounds:] must be override!`");
    return CGRectZero;
}

#pragma mark - Getter Methods
- (PDPopupAnimator *)animator {
    if (!_animator) {
        Class animatorClass = (self.preferredStyle == PDAlertViewStyleActionSheet ?
                               [PDActionSheetAnimator class] : [PDAlertAnimator class]);
        _animator = [[animatorClass alloc] initWithPopupView:self
                                                 contentView:[self contentView]
                                              backgroundView:self.backgroundView];
        _animator.animatorDelegate = self;
    }
    return _animator;
}

- (PDPopupBackgroundView *)backgroundView {
    if (!_backgroundView) {
        __weak typeof(self) weakSelf = self;
        _backgroundView = [[PDPopupBackgroundView alloc] initWithHitBlock:^{
            if (weakSelf.dismissWhenHitBackground) {
                [weakSelf dismissWithAnimated:YES];
            }
        }];
    }
    return _backgroundView;
}

@end
