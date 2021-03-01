//
//  PDPopupWidgetQueue.m
//  PDPopupAnimator
//
//  Created by liang on 2021/2/26.
//

#import "PDPopupWidgetQueue.h"

@implementation PDPopupWidgetQueue {
    NSMutableArray<id<PDPopupWidget>> *_widgets;
}

- (instancetype)init {
    return [self initWithName:nil];
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = [name copy];
        _widgets = [NSMutableArray array];
    }
    return self;
}

- (void)addWidget:(id<PDPopupWidget>)widget {
    [_widgets addObject:widget];
}

- (void)removeWidget:(id<PDPopupWidget>)widget {
    [_widgets removeObject:widget];
}

- (BOOL)containsWidget:(id<PDPopupWidget>)widget {
    BOOL contains = [_widgets containsObject:widget];
    return contains;
}

- (id<PDPopupWidget>)popHeadWidget {
    id<PDPopupWidget> widget = _widgets.firstObject;
    if (widget) { [_widgets removeObjectAtIndex:0]; }
    return widget;
}

- (id<PDPopupWidget>)headWidget {
    id<PDPopupWidget> widget = _widgets.firstObject;
    return widget;
}

- (void)removeAllWidgets {
    [_widgets removeAllObjects];
}

- (NSUInteger)count {
    NSUInteger count = _widgets.count;
    return count;
}

- (NSArray<id<PDPopupWidget>> *)allWidgets {
    return [_widgets copy];
}

@end
