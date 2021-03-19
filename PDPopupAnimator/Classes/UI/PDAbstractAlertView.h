//
//  PDAbstractAlertView.h
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/2/25.
//  Copyright © 2021 liang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PDAlertViewStyle) {
    PDAlertViewStyleActionSheet = 0,
    PDAlertViewStyleAlert       = 1,
};

@interface PDAbstractAlertView : UIView

@property (nonatomic, assign, readonly) PDAlertViewStyle preferredStyle;
@property (nonatomic, assign) BOOL dismissWhenHitBackground; // If style is actionSheet, default YES, else default NO

- (instancetype)initWithStyle:(PDAlertViewStyle)style NS_DESIGNATED_INITIALIZER;

- (void)showInView:(UIView * _Nullable)inView animated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated;

- (void)showInView:(UIView * _Nullable)inView animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
- (void)dismissWithAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

// The methods `- contentView` and `- contentViewRect` must be override
- (UIView *)contentView;
- (CGRect)contentViewRectForBounds:(CGRect)bounds;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
