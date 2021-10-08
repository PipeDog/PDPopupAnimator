//
//  PDAbstractAlertController.m
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/2/25.
//  Copyright © 2021 liang. All rights reserved.
//

#import "PDAbstractAlertController.h"
#import "PDAlertAnimator.h"
#import "PDActionSheetAnimator.h"
#import "PDPopupBackgroundView.h"
#import "PDAlertAction+Internal.h"

@interface PDAlertAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak, readonly) PDPopupAnimator *animator;

- (instancetype)initWithAnimator:(PDPopupAnimator *)animator;

@end

@interface PDAbstractAlertController () <UIViewControllerTransitioningDelegate, PDPopupAnimatorDelegate>

@property (nonatomic, strong) PDPopupBackgroundView *backgroundView;
@property (nonatomic, strong) PDPopupAnimator *animator;

@end

@implementation PDAbstractAlertController

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[PDAlertAnimationController alloc] initWithAnimator:self.animator];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[PDAlertAnimationController alloc] initWithAnimator:self.animator];
}

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(PDAlertControllerStyle)style {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.transitioningDelegate = self;
        
        _preferredStyle = style;
        _dismissWhenHitBackground = (_preferredStyle == PDAlertControllerStyleActionSheet);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupInitializeConfiguration];
}

- (void)setupInitializeConfiguration {
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark - Public Methods
- (void)showInController:(UIViewController *)inController animated:(BOOL)animated {
    [self showInController:inController animated:animated completion:nil];
}

- (void)showInController:(UIViewController *)inController animated:(BOOL)animated completion:(void (^)(void))completion {
    [inController presentViewController:self animated:animated completion:completion];
}

- (void)dismissWithAnimated:(BOOL)animated {
    [self dismissWithAnimated:animated completion:nil];
}

- (void)dismissWithAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self dismissViewControllerAnimated:animated completion:completion];
}

#pragma mark - PDPopupAnimatorDelegate
- (CGRect)contentViewFrameInAnimator:(__kindof PDPopupAnimator *)animator {
    return [self contentViewRect];
}

- (NSTimeInterval)showAnimationDurationInAnimator:(__kindof PDPopupAnimator *)animator {
    return 0.25f;
}

- (NSTimeInterval)dismissAnimationDurationInAnimator:(__kindof PDPopupAnimator *)animator {
    return 0.25f;
}

- (UIColor *)backgroundColorInAnimator:(__kindof PDPopupAnimator *)animator {
    return [UIColor colorWithWhite:0.f alpha:0.5f];
}

#pragma mark - Override Methods
- (UIView *)contentView {
    NSAssert(NO, @"Method `- [PDAbstractAlertController contentView] must be override!`");
    return nil;
}

- (CGRect)contentViewRect {
    NSAssert(NO, @"Method `- [PDAbstractAlertController contentViewRect] must be override!`");
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

- (PDPopupAnimator *)animator {
    if (!_animator) {
        Class animatorClass = (self.preferredStyle == PDAlertControllerStyleActionSheet ?
                               [PDActionSheetAnimator class] : [PDAlertAnimator class]);
        _animator = [[animatorClass alloc] initWithPopupView:self.view
                                                 contentView:[self contentView]
                                              backgroundView:self.backgroundView];
        _animator.animatorDelegate = self;
    }
    return _animator;
}

@end

@implementation PDAlertAnimationController

- (instancetype)initWithAnimator:(PDPopupAnimator *)animator {
    self = [super init];
    if (self) {
        _animator = animator;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromPage = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toPage = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromPage || !toPage) { return 0.f; }
    
    if (toPage.isBeingPresented && [toPage isKindOfClass:[PDAbstractAlertController class]]) {
        return [self.animator.animatorDelegate showAnimationDurationInAnimator:self.animator];
    }
    if (fromPage.isBeingDismissed && [fromPage isKindOfClass:[PDAbstractAlertController class]]) {
        return [self.animator.animatorDelegate dismissAnimationDurationInAnimator:self.animator];
    }
    
    NSAssert(NO, @"Invalid page class!");
    return 0.f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromPage = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toPage = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromPage || !toPage) { return; }
    
    UIView *containerView = [transitionContext containerView];
    if (toPage.isBeingPresented && [toPage isKindOfClass:[PDAbstractAlertController class]]) {
        [self.animator showInView:containerView animated:YES completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        return;
    }
    
    if (fromPage.isBeingDismissed && [fromPage isKindOfClass:[PDAbstractAlertController class]]) {
        [self.animator dismissWithAnimated:YES completion:^(BOOL finished) {
            [fromPage.view removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        return;
    }
    
    NSAssert(NO, @"Invalid page class!");
}

@end
