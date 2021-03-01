//
//  PDWidgetDataManager.h
//  PDPopupAnimator
//
//  Created by liang on 2021/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDWidgetDataManager : NSObject

@property (class, strong, readonly) PDWidgetDataManager *defaultManager;

- (void)bindIMP:(IMP)imp forSelector:(SEL)sel inClass:(Class)aClass;
- (IMP)impForSelector:(SEL)sel inClass:(Class)aClass;

- (void)bindArguments:(NSArray *)arguments forSelector:(SEL)sel inObject:(id)anObject;
- (NSArray *)argumentsForSelector:(SEL)sel inObject:(id)anObject;
- (void)invalidArgumentsForObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
