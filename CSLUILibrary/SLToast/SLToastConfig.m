//
//  SLToastConfig.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/10.
//

#import "SLToastConfig.h"

@interface SLToastConfig()
@property (nonatomic, strong) SLToastManager *toastManager;
@property (nonatomic, strong) SLToastStyle *toastStyle;
@end

@implementation SLToastConfig

static SLToastConfig *instance;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SLToastConfig alloc]init];
        instance.toastManager = [[SLToastManager alloc]init];
        instance.toastStyle = [[SLToastStyle alloc]init];
    });
    return instance;
}

- (void)configToastDuration:(NSTimeInterval)duration position:(SLToastPositon)position {
    if (duration > 0) {
        instance.toastManager.duration = duration;
    }
    if (position > 0) {
        instance.toastManager.position = position;
    }
}

- (void)configToastStyle:(SLToastStyle *)style {
    if (!style) return;
    instance.toastStyle = style;
}


@end
