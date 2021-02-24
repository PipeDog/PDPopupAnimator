//
//  PDPopupBackgroundView.m
//  PDPopupAnimator
//
//  Created by liang on 2021/2/24.
//

#import "PDPopupBackgroundView.h"

@implementation PDPopupBackgroundView {
    void (^_hitBlock)(void);
}

- (instancetype)initWithHitBlock:(void (^)(void))hitBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _hitBlock = [hitBlock copy];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)sender {
    !_hitBlock ?: _hitBlock();
}

@end
