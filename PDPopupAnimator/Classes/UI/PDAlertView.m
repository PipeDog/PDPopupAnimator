//
//  PDAlertView.m
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/2/25.
//  Copyright © 2021 liang. All rights reserved.
//

#import "PDAlertView.h"
#import "PDPopupBackgroundView.h"
#import "PDAlertAnimator.h"
#import "PDActionSheetAnimator.h"
#import "PDPopupUtil.h"

@interface PDAlertView () <PDPopupAnimatorDelegate>

@property (nonatomic, strong) id<PDPopupAnimator> animator;
@property (nonatomic, strong) PDPopupBackgroundView *backgroundView;

@end

@implementation PDAlertView

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
    Class animatorClass = (self.preferredStyle == PDAlertViewStyleActionSheet ?
                           [PDActionSheetAnimator class] : [PDAlertAnimator class]);
    self.animator = [[animatorClass alloc] initWithPopupView:self
                                                 contentView:[self contentView]
                                              backgroundView:self.backgroundView];
    self.animator.animatorDelegate = self;
    
    inView = inView ?: PDGetTopViewController().view;
    inView = inView ?: PDGetKeyWindow();
    [self.animator showInView:inView animated:animated];
}

- (void)dismissWithAnimated:(BOOL)animated {
    [self.animator dismissWithAnimated:animated];
}

#pragma mark - PDPopupAnimatorDelegate
- (CGRect)contentViewFrameInAnimator:(id<PDPopupAnimator>)animator {
    return [self contentViewRect];
}

- (NSTimeInterval)showAnimationDurationInAnimator:(id<PDPopupAnimator>)animator {
    return 0.25f;
}

- (NSTimeInterval)dismissAnimationDurationInAnimator:(id<PDPopupAnimator>)animator {
    return 0.25f;
}

#pragma mark - Override Methods
- (UIView *)contentView {
    NSAssert(NO, @"Method `- [PDAlertController contentView] must be override!`");
    return nil;
}

- (CGRect)contentViewRect {
    NSAssert(NO, @"Method `- [PDAlertController contentViewRect] must be override!`");
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
