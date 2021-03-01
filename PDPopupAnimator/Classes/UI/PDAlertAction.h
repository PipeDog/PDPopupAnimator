//
//  PDAlertAction.h
//  PDPopupAnimator
//
//  Created by liang on 2021/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSInteger PDAlertActionStyle NS_TYPED_EXTENSIBLE_ENUM;
static PDAlertActionStyle const PDAlertActionStyleDefault       = 0;
static PDAlertActionStyle const PDAlertActionStyleCancel        = 1;
static PDAlertActionStyle const PDAlertActionStyleDestructive   = 2;

@interface PDAlertAction : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) PDAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

+ (instancetype)actionWithTitle:(NSString *)title style:(PDAlertActionStyle)style handler:(void (^ _Nullable)(PDAlertAction *action))handler;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
