//
//  SLScrollView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "SLScrollView.h"
#import <CSLUILibrary/SLUIConsts.h>

@implementation SLScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (instancetype)init {
    if (self == [super init]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    if (@available(iOS 11, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
}

@end
