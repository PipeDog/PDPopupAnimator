//
//  PDAlertAction+Internal.h
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/2/25.
//  Copyright © 2021 liang. All rights reserved.
//

#import "PDAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDAlertAction ()

@property (nonatomic, copy, readonly) void (^handler)(PDAlertAction *);

@end

NS_ASSUME_NONNULL_END
