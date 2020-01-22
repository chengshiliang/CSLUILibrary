//
//  DropDownHeaderView.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2020/1/22.
//  Copyright © 2020 csl. All rights reserved.
//

#import "DropDownHeaderView.h"

@interface DropDownHeaderView()
@property (nonatomic, strong) SLLabel *titleLabel;
@property (nonatomic, strong) UIView *view;
@end

@implementation DropDownHeaderView

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
    UIView *view = [[UIView alloc]init];
    [self addSubview:view];
    self.view = view;
    self.titleLabel = [[SLLabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.titleLabel];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setWidth:(CGFloat)width {
    _width = width;
    self.view.frame = CGRectMake(10, 0, width, self.sl_height);
    self.titleLabel.frame = CGRectMake(0, 0, width, self.view.sl_height);
    [self.view addCornerRadius:self.view.sl_height/2.0 borderWidth:2.0 borderColor:SLUIHexColor(0x666666) backGroundColor:nil];
}

@end
