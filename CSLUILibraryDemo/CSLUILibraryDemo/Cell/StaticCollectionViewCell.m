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
@property (weak, nonatomic) IBOutlet SLImageView *imageView;
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
    self.backgroundColor = [UIColor yellowColor];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)renderWithRowModel:(id<SLCollectRowProtocol>)row {
    self.imageView.image = nil;
    if ([row isKindOfClass:[StaticCollectionModel class]]) {
        StaticCollectionModel *model = (StaticCollectionModel*)row;
        self.title = model.str;
        self.backgroundColor = [UIColor yellowColor];
    } else if ([row isKindOfClass:[MyStaticCollectRowModel class]]) {
        MyStaticCollectRowModel *model = (MyStaticCollectRowModel*)row;
        self.title = model.str;
        self.backgroundColor = [UIColor yellowColor];
    } else if ([row isKindOfClass:[MyNoRuleCollectRowModel class]]) {
        MyNoRuleCollectRowModel *model = (MyNoRuleCollectRowModel*)row;
        self.title = model.str;
        self.backgroundColor = model.color;
    } else if ([row isKindOfClass:[MyRecycleRowModel class]]) {
        MyRecycleRowModel *model = (MyRecycleRowModel*)row;
        self.title = model.str;
        self.imageView.image = [UIImage imageNamed:model.imageUrl];
        self.backgroundColor = model.color;
    } else {
        self.title = @"";
        self.backgroundColor = [UIColor yellowColor];
    }
}

@end
