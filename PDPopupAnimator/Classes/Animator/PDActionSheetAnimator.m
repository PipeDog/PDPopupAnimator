//
//  PDActionSheetAnimator.m
//  PDPopupAnimator
//
//  Created by liang on 2021/2/24.
//

#import "PDActionSheetAnimator.h"

@implementation PDActionSheetAnimator

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
    [self showInView:inView animated:animated completion:nil];
}

- (void)showInView:(UIView *)inView animated:(BOOL)animated completion:(void (^ _Nullable)(BOOL))completion {
    NSAssert(inView, @"The argument `inView` can not be nil!");

    if (![self.animatorDelegate respondsToSelector:@selector(contentViewFrameInAnimator:)]) {
        NSAssert(NO, @"Invalid property `animatorDelegate`!");
        return;
    }
        
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
    CGRect fromRect = CGRectMake(CGRectGetMinX(toRect),
                                 CGRectGetHeight(inView.frame),
                                 CGRectGetWidth(toRect),
                                 CGRectGetHeight(toRect));
    self.contentView.frame = fromRect;
    [self.popupView addSubview:self.contentView];
    
    // begin animation
    NSTimeInterval duration = animated ? 0.25f : 0.f;
    if (animated && [self.animatorDelegate respondsToSelector:@selector(showAnimationDurationInAnimator:)]) {
        duration = [self.animatorDelegate showAnimationDurationInAnimator:self];
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.contentView.frame = toRect;
    } completion:completion];
}

- (void)dismissWithAnimated:(BOOL)animated {
    [self dismissWithAnimated:animated completion:nil];
}

- (void)dismissWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(BOOL))completion {
    NSTimeInterval duration = animated ? 0.25f : 0.f;
    if (animated && [self.animatorDelegate respondsToSelector:@selector(dismissAnimationDurationInAnimator:)]) {
        duration = [self.animatorDelegate dismissAnimationDurationInAnimator:self];
    }
    
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = self.contentView.frame;
        rect.origin.y = CGRectGetHeight(self.popupView.frame);
        self.contentView.frame = rect;
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
    } completion:^(BOOL finished) {
        self.popupView.hidden = YES;
        [self.popupView removeFromSuperview];
        
        !completion ?: completion(finished);
    }];
}

@end
