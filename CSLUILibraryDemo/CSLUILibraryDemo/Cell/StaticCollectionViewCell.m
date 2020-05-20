//
//  StaticCollectionViewCell.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/25.
//  Copyright © 2019 csl. All rights reserved.
//

#import "StaticCollectionViewCell.h"
#import "MyCardCollectSectionModel.h"

@interface StaticCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet SLLabel *titleLabel;
@end

@implementation StaticCollectionViewCell

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
    self.containerView.backgroundColor = [UIColor yellowColor];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = title;
    self.titleLabel.font = SLUINormalFont(12.0);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = SLUIHexColor(0x00FF00);
}

- (void)renderWithRowModel:(id<SLCollectRowProtocol>)row {
    self.containerView.backgroundColor = [UIColor yellowColor];
    if ([row isKindOfClass:[StaticCollectionModel class]]) {
        StaticCollectionModel *model = (StaticCollectionModel*)row;
        self.title = model.str;
    } else if ([row isKindOfClass:[MyStaticCollectRowModel class]]) {
        MyStaticCollectRowModel *model = (MyStaticCollectRowModel*)row;
        self.title = model.str;
    } else if ([row isKindOfClass:[MyNoRuleCollectRowModel class]]) {
        MyNoRuleCollectRowModel *model = (MyNoRuleCollectRowModel*)row;
        self.title = model.str;
        self.containerView.backgroundColor = model.color;
    } else if ([row isKindOfClass:[MyRecycleRowModel class]]) {
        MyRecycleRowModel *model = (MyRecycleRowModel*)row;
        self.title = model.str;
        self.containerView.backgroundColor = model.color;
    } else if ([row isKindOfClass:[DropDownRowModel class]]) {
        DropDownRowModel *rowData = (DropDownRowModel *)row;
        self.title = rowData.title;
        [self.containerView addCornerRadius:self.sl_height/2.0 borderWidth:2.0 borderColor:SLUIHexColor(0x999999) backGroundColor:nil];
    } else {
        self.title = @"";
    }
}

@end
