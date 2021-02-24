//
//  PDAlertView.h
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/2/24.
//  Copyright © 2021 liang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDAlertView : UIView

- (void)showInView:(UIView * _Nullable)inView animated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
