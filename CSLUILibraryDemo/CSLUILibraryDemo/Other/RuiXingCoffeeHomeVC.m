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
@property (nonatomic, strong) IBOutlet SLStaticCollectionView *staticCollectionView;
@property (nonatomic, strong) RuiXingCoffeeHomeHeaderView *headerView;
@end

@implementation RuiXingCoffeeHomeVC

static NSString * const ruixingHomeHeaderID = @"ruixingHomeHeaderID";
static NSString * const ruixingHomeFooterID = @"ruixingHomeFooterID";

- (void)viewDidLoad {
    [super viewDidLoad];
    recycleViewH = kScreenWidth * 2.0/3;
    noRuleCollectionViewH = kScreenWidth * 0.75;
    
    self.headerView = [[RuiXingCoffeeHomeHeaderView alloc]init];
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSMutableArray *arrM1 = [NSMutableArray array];
    SLCustomCollectionModel *staticModel = [SLCustomCollectionModel new];
    staticModel.headerWidth = kScreenWidth;
    staticModel.headerHeigth = kScreenWidth*(2.0/3+3.0/4);
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
    self.staticCollectionView.dataSource = arrM.copy;
    self.staticCollectionView.delegate = self;
    self.staticCollectionView.columns = 2;
    self.staticCollectionView.columnMagrin = 5.0f;
    self.staticCollectionView.rowMagrin = 5.0f;
    [self.staticCollectionView reloadData];
    [self.staticCollectionView.collectionView registerClass:[RuiXingCoffeeHomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ruixingHomeHeaderID];
    
    [self.headerView.noRuleCollectionView.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.staticCollectionView.collectionView.panGestureRecognizer];
    [self.headerView.recycleView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.staticCollectionView.collectionView.panGestureRecognizer];
}

static NSString *const cellId1 = @"kStaticCollectionViewCellID";

- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view {
    if ([view isKindOfClass:[SLStaticCollectionView class]]) {
        [collectionView registerNib:[UINib nibWithNibName:@"StaticCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId1];
    }
}

- (UICollectionReusableView *)sl_collectionView:(SLCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *supplementaryView = [UICollectionReusableView new];
    RuiXingCoffeeHomeHeaderView *view = (RuiXingCoffeeHomeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ruixingHomeHeaderID forIndexPath:indexPath];
    supplementaryView = view;
    return supplementaryView;
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    if ([view isKindOfClass:[SLStaticCollectionView class]]) {
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
