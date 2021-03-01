//
//  PDPopupWidgetQueue.h
//  PDPopupAnimator
//
//  Created by liang on 2021/2/26.
//

#import <Foundation/Foundation.h>
#import "PDPopupWidget.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDPopupWidgetQueue : NSObject

@property (nonatomic, strong, readonly) NSString *name;

- (instancetype)initWithName:(NSString * _Nullable)name NS_DESIGNATED_INITIALIZER;

- (void)addWidget:(id<PDPopupWidget>)widget;
- (void)removeWidget:(id<PDPopupWidget>)widget;
- (BOOL)containsWidget:(id<PDPopupWidget>)widget;
- (id<PDPopupWidget>)popHeadWidget;
- (id<PDPopupWidget>)headWidget;
- (void)removeAllWidgets;
- (NSUInteger)count;
- (NSArray<id<PDPopupWidget>> *)allWidgets;

@end

NS_ASSUME_NONNULL_END
