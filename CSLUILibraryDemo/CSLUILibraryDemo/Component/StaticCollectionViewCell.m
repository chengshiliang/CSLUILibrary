//
//  StaticCollectionViewCell.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/25.
//  Copyright © 2019 csl. All rights reserved.
//

#import "StaticCollectionViewCell.h"

@interface StaticCollectionViewCell()
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

@end
