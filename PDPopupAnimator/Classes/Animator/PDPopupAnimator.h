//
//  PDPopupAnimator.h
//  PDPopupAnimator
//
//  Created by liang on 2021/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PDPopupAnimator;

@protocol PDPopupAnimatorDelegate <NSObject>

- (CGRect)contentViewFrameInAnimator:(id<PDPopupAnimator>)animator;

@optional
- (NSTimeInterval)showAnimationDurationInAnimator:(id<PDPopupAnimator>)animator;
- (NSTimeInterval)dismissAnimationDurationInAnimator:(id<PDPopupAnimator>)animator;
- (UIColor *)backgroundColorInAnimator:(id<PDPopupAnimator>)animator;

@end

@protocol PDPopupAnimator <NSObject>

@property (nonatomic, weak) id<PDPopupAnimatorDelegate> animatorDelegate;
@property (nonatomic, weak, readonly) UIView *popupView;
@property (nonatomic, weak, readonly) UIView *contentView;
@property (nonatomic, weak, readonly) UIView *backgroundView;

- (instancetype)initWithPopupView:(UIView *)popupView
                      contentView:(UIView *)contentView
                   backgroundView:(UIView *)backgroundView;

- (void)showInView:(UIView *)inView animated:(BOOL)animated completion:(void (^ _Nullable)(BOOL finished))completion;
- (void)showInView:(UIView *)inView animated:(BOOL)animated;

- (void)dismissWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(BOOL finished))completion;
- (void)dismissWithAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
