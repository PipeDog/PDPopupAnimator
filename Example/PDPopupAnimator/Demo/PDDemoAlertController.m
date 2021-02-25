//
//  PDDemoAlertController.m
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/2/25.
//  Copyright © 2021 liang. All rights reserved.
//

#import "PDDemoAlertController.h"

@interface PDDemoAlertController ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation PDDemoAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Event Methods
- (void)didCancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    CGFloat top = (self.preferredStyle == PDAlertControllerStyleActionSheet ?
                   CGRectGetHeight([UIScreen mainScreen].bounds) - height - 40.f : 260.f);
    return CGRectMake(10.f,
                      top,
                      CGRectGetWidth([UIScreen mainScreen].bounds) - 20.f,
                      height);
}

@end
