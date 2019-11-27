//
//  RuiXingCoffeeHomeHeaderView.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/27.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RuiXingCoffeeHomeHeaderView.h"

@interface RuiXingCoffeeHomeHeaderView()
@property (weak, nonatomic) IBOutlet SLRecycleView *recycleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recycleRadio;
@property (weak, nonatomic) IBOutlet SLNoRuleCollectionView *noRuleCollectionView;
@end

@implementation RuiXingCoffeeHomeHeaderView

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
    NSLog(@"%lf", self.recycleRadio.constant);
}

@end
