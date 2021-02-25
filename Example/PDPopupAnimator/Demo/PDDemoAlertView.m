//
//  PDDemoAlertView.m
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/2/24.
//  Copyright © 2021 liang. All rights reserved.
//

#import "PDDemoAlertView.h"

@interface PDDemoAlertView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation PDDemoAlertView

#pragma mark - Event Methods
- (void)didCancelAction:(id)sender {
    [self dismissWithAnimated:YES];
}

#pragma mark - Override Methods
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

- (CGRect)contentViewRect {
    CGFloat height = 200.f;
    CGFloat top = (self.preferredStyle == PDAlertViewStyleActionSheet ?
                   CGRectGetHeight([UIScreen mainScreen].bounds) - height - 40.f : 260.f);
    return CGRectMake(10.f,
                      top,
                      CGRectGetWidth([UIScreen mainScreen].bounds) - 20.f,
                      height);
}

@end
