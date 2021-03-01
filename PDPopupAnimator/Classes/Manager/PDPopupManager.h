//
//  PDPopupManager.h
//  PDPopupAnimator
//
//  Created by liang on 2021/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDPopupManager : NSObject

@property (class, strong, readonly) PDPopupManager *defaultManager;
@property (nonatomic, copy, readonly) NSDictionary<NSString *, Class> *widgetMap;

- (void)installWidgets;

@end

NS_ASSUME_NONNULL_END
