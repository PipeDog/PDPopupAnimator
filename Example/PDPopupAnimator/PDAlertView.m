//
//  PDAlertView.m
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/2/24.
//  Copyright © 2021 liang. All rights reserved.
//

#import "PDAlertView.h"
#import <PDPopupAnimatorHeader.h>

@interface PDAlertView () <PDPopupAnimatorDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PDPopupBackgroundView *backgroundView;
@property (nonatomic, strong) id<PDPopupAnimator> animator;

@end

@implementation PDAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Public Methods
- (void)showInView:(UIView *)inView animated:(BOOL)animated {
    [self.animator showInView:inView animated:animated];
}

- (void)dismissWithAnimated:(BOOL)animated {
    [self.animator dismissWithAnimated:animated];
}

#pragma mark - PDPopupAnimatorDelegate
- (CGRect)contentViewFrameInAnimator:(id<PDPopupAnimator>)animator {
    CGFloat height = 200.f;
    return CGRectMake(10.f,
                      260.f,
                      CGRectGetWidth([UIScreen mainScreen].bounds) - 20.f,
                      height);
}

#pragma mark - Event Methods
- (void)didCancelAction:(id)sender {
    [self dismissWithAnimated:YES];
}

#pragma mark - Getter Methods
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor orangeColor];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.backgroundColor = [UIColor systemBlueColor];
        cancelButton.frame = CGRectMake(10.f, 10.f, 100.f, 40.f);
        [cancelButton addTarget:self action:@selector(didCancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_contentView addSubview:cancelButton];
    }
    return _contentView;
}

- (PDPopupBackgroundView *)backgroundView {
    if (!_backgroundView) {
        __weak typeof(self) weakSelf = self;
        _backgroundView = [[PDPopupBackgroundView alloc] initWithHitBlock:^{
            [weakSelf dismissWithAnimated:YES];
        }];
    }
    return _backgroundView;
}

- (id<PDPopupAnimator>)animator {
    if (!_animator) {
        _animator = [[PDAlertAnimator alloc] initWithPopupView:self
                                                   contentView:self.contentView
                                                backgroundView:self.backgroundView];
        _animator.animatorDelegate = self;
    }
    return _animator;
}

@end
