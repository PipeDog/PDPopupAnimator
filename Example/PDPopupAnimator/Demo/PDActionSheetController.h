//
//  PDActionSheetController.h
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/3/12.
//  Copyright © 2021 liang. All rights reserved.
//

#import "PDAbstractAlertController.h"
#import "PDAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDActionSheetController : PDAbstractAlertController

@property (nonatomic, assign) BOOL autoDismissWhenHitAction; // Default is YES
@property (nonatomic, copy, readonly) NSArray<PDAlertAction *> *actions;

- (void)addAction:(PDAlertAction *)action;

@end

NS_ASSUME_NONNULL_END
