//
//  PDAlertAnimator.m
//  PDPopupAnimator
//
//  Created by liang on 2021/2/24.
//

#import "PDAlertAnimator.h"
#import "PDPopupUtil.h"

@implementation PDAlertAnimator

@synthesize animatorDelegate = _animatorDelegate;
@synthesize popupView = _popupView;
@synthesize contentView = _contentView;
@synthesize backgroundView = _backgroundView;

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
    if (![self.animatorDelegate respondsToSelector:@selector(contentViewFrameInAnimator:)]) {
        NSAssert(NO, @"Invalid property `animatorDelegate`!");
        return;
    }
    
    inView = inView ?: PDGetTopViewController().view;
    inView = inView ?: PDGetKeyWindow();

    // setup popupView
    self.popupView.hidden = NO;
    self.popupView.frame = CGRectMake(0.f,
                                      0.f,
                                      CGRectGetWidth(inView.bounds),
                                      CGRectGetHeight(inView.bounds));
    [inView addSubview:self.popupView];

    // setup backgroundView
    self.backgroundView.frame = CGRectMake(0.f,
                                           0.f,
                                           CGRectGetWidth(self.popupView.bounds),
                                           CGRectGetHeight(self.popupView.bounds));
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
    [self.popupView addSubview:self.backgroundView];
    
    // setup contentView
    CGRect toRect = [self.animatorDelegate contentViewFrameInAnimator:self];
    self.contentView.frame = toRect;
    self.contentView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    self.contentView.alpha = 0.7f;
    [self.popupView addSubview:self.contentView];

    // begin animation
    NSTimeInterval duration = animated ? 0.25f : 0.f;
    if (animated && [self.animatorDelegate respondsToSelector:@selector(showAnimationDurationInAnimator:)]) {
        duration = [self.animatorDelegate showAnimationDurationInAnimator:self];
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        self.contentView.alpha = 1.f;
    }];
}

- (void)dismissWithAnimated:(BOOL)animated {
    NSTimeInterval duration = animated ? 0.25f : 0.f;
    if (animated && [self.animatorDelegate respondsToSelector:@selector(dismissAnimationDurationInAnimator:)]) {
        duration = [self.animatorDelegate dismissAnimationDurationInAnimator:self];
    }

    [UIView animateWithDuration:duration animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.contentView.alpha = 0.7f;
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
    } completion:^(BOOL finished) {
        self.contentView.transform = CGAffineTransformIdentity;
        self.popupView.hidden = YES;
        [self.popupView removeFromSuperview];
    }];
}

@end
