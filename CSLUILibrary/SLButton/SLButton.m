//
//  SLButton.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import "SLButton.h"
#import "NSObject+Base.h"
#import <objc/runtime.h>

@interface SLButton()
@property (nonatomic, assign) NSTimeInterval lastEventTime;
@property (nonatomic, copy) void(^onTouchCallback)(SLButton *button);
@end

@implementation SLButton

- (NSTimeInterval)eventInterval {
    if (_eventInterval <= 0) {
        _eventInterval = 1.0;
    }
    return _eventInterval;
}

- (void)onTouch:(NSObject *)target event:(UIControlEvents)event change:(void(^)(SLButton *button))changeBlock{
    [self addTarget:self action:@selector(eventChange:) forControlEvents:event];
    self.onTouchCallback = [changeBlock copy];
    __weak __typeof(self)weakSelf = self;
    [self swizzMethod:target action:Dealloc callback:^(NSObject *__unsafe_unretained  _Nonnull obj) {
        __strong __typeof(self)strongSelf = weakSelf;
        [strongSelf removeTarget:strongSelf action:@selector(eventChange:) forControlEvents:event];
    }];
}

- (void)eventChange:(SLButton *)button {
    if ([NSDate date].timeIntervalSince1970 - self.lastEventTime < self.eventInterval) return;
    if (self.eventInterval > 0) {
        self.lastEventTime = [NSDate date].timeIntervalSince1970;
    }
    if (self.onTouchCallback) {
        self.onTouchCallback(button);
    }
}
@end
