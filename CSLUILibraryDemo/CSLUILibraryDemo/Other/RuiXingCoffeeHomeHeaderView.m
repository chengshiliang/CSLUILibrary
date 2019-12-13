//
//  RuiXingCoffeeHomeHeaderView.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/27.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RuiXingCoffeeHomeHeaderView.h"
#import "StaticCollectionViewController.h"
#import "StaticCollectionViewCell.h"
#import <CSLCommonLibrary/NSNotificationCenter+Base.h>
#import "RecycleViewController.h"

@interface RuiXingCoffeeHomeHeaderView()<SLCollectionViewProtocol>
{
    NSArray *dataSource;
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
    NSMutableArray *arrM1 = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        SLPupModel *pupModel = [SLPupModel new];
        pupModel.width = kScreenWidth-20;
        RecycleViewModel *model = [RecycleViewModel new];
        model.title = [NSString stringWithFormat:@"第%d个", i];
        model.imageUrl = [NSString stringWithFormat:@"cir%d", i];
        pupModel.data = model;
        [arrM1 addObject:pupModel];
    }
    self.recycleView.loop = YES;
    self.recycleView.dataSource = arrM1.copy;
    self.recycleView.delegate = self;
    self.recycleView.minimumLineSpacing = 0;
    self.recycleView.insets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.recycleView.interval = 1.0;
    [self.recycleView.collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [self addSubview:self.recycleView];
    [self.recycleView reloadData];
    self.noRuleCollectionView = [[SLNoRuleCollectionView alloc]initWithFrame:CGRectMake(0, kScreenWidth*2.0/3, kScreenWidth, kScreenWidth*3.0/4)];
    [self addSubview:self.noRuleCollectionView];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        SLPupModel *pupModel = [SLPupModel new];
        CGFloat width = 0;
        CGFloat height = 0;
        switch (i) {
            case 0:
            {
                width = kScreenWidth*0.5;
                height = kScreenWidth*0.5;
            }
                break;
            case 1:
            {
                width = kScreenWidth*0.5;
                height = kScreenWidth*0.25;
            }
                break;
            case 2:
            {
                width = kScreenWidth*0.25;
                height = kScreenWidth*0.25;
            }
                break;
            case 3:
            {
                width = kScreenWidth*0.25;
                height = kScreenWidth*0.25;
            }
                break;
            case 4:
            {
                width = kScreenWidth*0.75;
                height = kScreenWidth*0.25;
            }
                break;
            case 5:
            {
                width = kScreenWidth*0.25;
                height = kScreenWidth*0.25;
            }
                break;
            default:
                break;
        }
        pupModel.width = width;
        pupModel.height = height;
        StaticCollectionModel *model = [StaticCollectionModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        pupModel.data = model;
        [arrM addObject:pupModel];
    }
    dataSource = arrM.copy;
    self.noRuleCollectionView.dataSource = arrM.copy;
    self.noRuleCollectionView.delegate = self;
    self.noRuleCollectionView.columns = 4;
    self.noRuleCollectionView.columnMagrin = 5.0f;
    self.noRuleCollectionView.rowMagrin = 5.0f;
    self.noRuleCollectionView.insets = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.noRuleCollectionView reloadData];
}

static NSString *const cellId3 = @"kNoRuleCollectionViewCellID";

- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view {
    if ([view isKindOfClass:[SLNoRuleCollectionView class]]) {
        [collectionView registerNib:[UINib nibWithNibName:@"StaticCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId3];
    }
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    if ([view isKindOfClass:[SLNoRuleCollectionView class]]) {
        StaticCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId3 forIndexPath:indexPath];
        SLPupModel *pupModel = dataSource[indexPath.row];
        StaticCollectionModel *model = (StaticCollectionModel *)pupModel.data;
        cell.title = model.str;
        if (indexPath.row%3==0) {
            cell.backgroundColor = [UIColor redColor];
        } else if (indexPath.row%3==1) {
            cell.backgroundColor = [UIColor greenColor];
        } else if (indexPath.row%3==2) {
            cell.backgroundColor = [UIColor blueColor];
        }
        return cell;
    }
    SLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    return cell;
}
@end
