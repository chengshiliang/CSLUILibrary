//
//  RuiXingCoffeeHomeHeaderView.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/27.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RuiXingCoffeeHomeHeaderView.h"
#import "MyCardCollectSectionModel.h"

@interface RuiXingCoffeeHomeHeaderView()
{
    NSArray *dataSource;
    NSArray *dataSource1;
}
@end
static NSString *const cellId = @"ruixingheaderrecycleview";

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
    self.recycleView = [[SLRecycleCollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*2.0/3)];
    [self addSubview:self.recycleView];
    self.recycleView.loop = YES;
    self.recycleView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.recycleView.interval = 1.0;
    self.recycleView.scrollToIndexBlock = ^(id<SLCollectRowProtocol>  _Nonnull model, NSInteger index) {
        NSLog(@"index %d", index);
    };
    WeakSelf;
    self.recycleView.selectCollectView = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
        StrongSelf;
        NSLog(@"click %d", [strongSelf.recycleView indexOfSourceArray:indexPath.item]);
    };
    self.noRuleCollectionView = [[SLNoRuleCollectionView alloc]initWithFrame:CGRectMake(0, kScreenWidth*2.0/3, kScreenWidth, kScreenWidth*3.0/4)];
    [self addSubview:self.noRuleCollectionView];
    self.noRuleCollectionView.columns = 4;
    self.noRuleCollectionView.ajustFrame = NO;
    self.noRuleCollectionView.selectCollectView = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
        NSLog(@"click %d", indexPath.row);
    };
}
@end
