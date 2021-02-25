//
//  PDAlertAction.m
//  PDPopupAnimator
//
//  Created by liang on 2021/2/25.
//

#import "PDAlertAction.h"
#import "PDAlertAction+Internal.h"

@implementation PDAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(PDAlertActionStyle)style handler:(void (^)(PDAlertAction * _Nonnull))handler {
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(PDAlertActionStyle)style handler:(void (^)(PDAlertAction * _Nonnull))handler {
    self = [super init];
    if (self) {
        _title = [title copy];
        _style = style;
        _handler = [handler copy];
        _enabled = YES;
    }
    return self;
}

@end
