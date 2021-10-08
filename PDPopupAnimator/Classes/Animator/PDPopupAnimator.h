//
//  PDPopupAnimator.h
//  PDPopupAnimator
//
//  Created by liang on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PDPopupAnimator;

@protocol PDPopupAnimatorDelegate <NSObject>

- (CGRect)contentViewFrameInAnimator:(__kindof PDPopupAnimator *)animator;

@optional
- (NSTimeInterval)showAnimationDurationInAnimator:(__kindof PDPopupAnimator *)animator;
- (NSTimeInterval)dismissAnimationDurationInAnimator:(__kindof PDPopupAnimator *)animator;
- (UIColor *)backgroundColorInAnimator:(__kindof PDPopupAnimator *)animator;

@end

@interface PDPopupAnimator : NSObject

@property (nonatomic, weak) id<PDPopupAnimatorDelegate> animatorDelegate;
@property (nonatomic, weak, readonly) UIView *popupView;
@property (nonatomic, weak, readonly) UIView *contentView;
@property (nonatomic, weak, readonly) UIView *backgroundView;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithPopupView:(UIView *)popupView
                      contentView:(UIView *)contentView
                   backgroundView:(UIView *)backgroundView NS_DESIGNATED_INITIALIZER;

- (void)showInView:(UIView *)inView animated:(BOOL)animated completion:(void (^ _Nullable)(BOOL finished))completion;
- (void)showInView:(UIView *)inView animated:(BOOL)animated;

- (void)dismissWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(BOOL finished))completion;
- (void)dismissWithAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
