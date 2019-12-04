//
//  SLView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import "SLView.h"

@implementation SLView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {

}

@end
