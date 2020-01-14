//
//  SLTableViewCell.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLTableViewCell.h"

@interface SLTableViewCell()
@end

@implementation SLTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {}

@end
