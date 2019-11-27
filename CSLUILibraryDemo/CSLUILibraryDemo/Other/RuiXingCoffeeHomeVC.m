//
//  RuiXingCoffeeHomeVC.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/27.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RuiXingCoffeeHomeVC.h"
#import "StaticCollectionViewController.h"
#import "StaticCollectionViewCell.h"
#import "RuiXingCoffeeHomeHeaderView.h"

@interface RuiXingCoffeeHomeVC ()<SLCollectionViewProtocol>
{
    CGFloat recycleViewH;
    CGFloat noRuleCollectionViewH;
    NSArray *dataSource;
}
@property (nonatomic, strong) IBOutlet SLCustomCollectionView *collectionView;
@property (nonatomic, strong) RuiXingCoffeeHomeHeaderView *headerView;
@end

@implementation RuiXingCoffeeHomeVC

static NSString * const ruixingHomeHeaderID = @"ruixingHomeHeaderID";
static NSString * const ruixingHomeFooterID = @"ruixingHomeFooterID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sl_hiddenNavbar];
    
    recycleViewH = kScreenWidth * 2.0/3;
    noRuleCollectionViewH = kScreenWidth * 0.75;
    
    self.headerView = [[RuiXingCoffeeHomeHeaderView alloc]init];
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSMutableArray *arrM1 = [NSMutableArray array];
    SLCustomCollectionModel *staticModel = [SLCustomCollectionModel new];
    staticModel.headerWidth = kScreenWidth;
    staticModel.headerHeigth = kScreenWidth*(2.0/3+3.0/4) + 40;
    for (int i = 0; i < 6; i ++) {
        SLPupModel *pupModel = [SLPupModel new];
        pupModel.width = 200;
        pupModel.height = 200;
        StaticCollectionModel *model = [StaticCollectionModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        pupModel.data = model;
        [arrM1 addObject:pupModel];
    }
    staticModel.datas = arrM1.copy;
    [arrM addObject:staticModel];
    dataSource = arrM.copy;
    self.collectionView.dataSource = arrM.copy;
    self.collectionView.delegate = self;
    self.collectionView.columns = 2;
    self.collectionView.columnMagrin = 5.0f;
    self.collectionView.rowMagrin = 5.0f;
    [self.collectionView reloadData];
    [self.collectionView.collectionView registerClass:[RuiXingCoffeeHomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ruixingHomeHeaderID];
    
    [self.headerView.noRuleCollectionView.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.collectionView.collectionView.panGestureRecognizer];
    [self.headerView.recycleView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.collectionView.collectionView.panGestureRecognizer];
}

static NSString *const cellId1 = @"kcollectionViewCellID";

- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view {
    if ([view isKindOfClass:[SLCustomCollectionView class]]) {
        [collectionView registerNib:[UINib nibWithNibName:@"StaticCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId1];
    }
}

- (UICollectionReusableView *)sl_collectionView:(SLCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    RuiXingCoffeeHomeHeaderView *view = (RuiXingCoffeeHomeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ruixingHomeHeaderID forIndexPath:indexPath];
    return view;
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    if ([view isKindOfClass:[SLCustomCollectionView class]]) {
        StaticCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId1 forIndexPath:indexPath];
        SLCustomCollectionModel *staticModel = dataSource[indexPath.section];
        SLPupModel *pupModel = staticModel.datas[indexPath.item];
        StaticCollectionModel *model = (StaticCollectionModel *)pupModel.data;
        cell.title = model.str;
        return cell;
    }
    return nil;
}

@end
