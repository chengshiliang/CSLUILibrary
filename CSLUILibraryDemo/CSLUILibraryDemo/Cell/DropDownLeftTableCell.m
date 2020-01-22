//
//  DropDownLeftTableCell.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2020/1/22.
//  Copyright © 2020 csl. All rights reserved.
//

#import "DropDownLeftTableCell.h"

@interface DropDownLeftTableCell()
@property (nonatomic, strong) SLLabel *titleLabel;
@end

@implementation DropDownLeftTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.titleLabel = [[SLLabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = SLUIHexColor(0xFF00FF);
    [self.contentView addSubview:self.titleLabel];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    self.titleLabel.frame = self.contentView.bounds;
}

@end
