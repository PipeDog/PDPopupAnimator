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

@property (nonatomic, strong) id<PDPopupAnimator> animator;
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
    Class animatorClass = (self.preferredStyle == PDAlertViewStyleActionSheet ?
                           [PDActionSheetAnimator class] : [PDAlertAnimator class]);
    self.animator = [[animatorClass alloc] initWithPopupView:self
                                                 contentView:[self contentView]
                                              backgroundView:self.backgroundView];
    self.animator.animatorDelegate = self;
    
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
- (CGRect)contentViewFrameInAnimator:(id<PDPopupAnimator>)animator {
    return [self contentViewRectForBounds:_containerBounds];
}

- (NSTimeInterval)showAnimationDurationInAnimator:(id<PDPopupAnimator>)animator {
    return 0.25f;
}

- (NSTimeInterval)dismissAnimationDurationInAnimator:(id<PDPopupAnimator>)animator {
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
