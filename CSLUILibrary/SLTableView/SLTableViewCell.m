//
//  SLTableViewCell.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLTableViewCell.h"

@implementation SLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor whiteColor];
}

@end
