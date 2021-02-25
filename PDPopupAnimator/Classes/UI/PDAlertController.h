//
//  PDAlertController.h
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/2/25.
//  Copyright © 2021 liang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PDAlertControllerStyle) {
    PDAlertControllerStyleActionSheet   = 0,
    PDAlertControllerStyleAlert         = 1,
};

@interface PDAlertController : UIViewController

@property (nonatomic, assign, readonly) PDAlertControllerStyle preferredStyle;
@property (nonatomic, assign) BOOL dismissWhenHitBackground; // If style is actionSheet, default YES, else default NO

- (instancetype)initWithStyle:(PDAlertControllerStyle)style NS_DESIGNATED_INITIALIZER;

// The methods `- contentView` and `- contentViewRect` must be override
- (UIView *)contentView;
- (CGRect)contentViewRect;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
