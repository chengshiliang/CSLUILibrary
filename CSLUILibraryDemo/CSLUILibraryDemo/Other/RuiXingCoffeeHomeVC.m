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
@end

@implementation RuiXingCoffeeHomeVC

static NSString * const ruixingHomeHeaderID = @"ruixingHomeHeaderID";

- (void)viewDidLoad {
    [super viewDidLoad];
    recycleViewH = 300;
    noRuleCollectionViewH = kScreenWidth * 0.75;
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        SLPupModel *pupModel = [SLPupModel new];
        pupModel.width = 200;
        pupModel.height = 200;
        StaticCollectionModel *model = [StaticCollectionModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        pupModel.data = model;
        [arrM addObject:pupModel];
    }
    dataSource = arrM.copy;
    self.staticCollectionView.dataSource = arrM.copy;
    self.staticCollectionView.delegate = self;
    self.staticCollectionView.columns = 2;
    self.staticCollectionView.columnMagrin = 5.0f;
    self.staticCollectionView.rowMagrin = 5.0f;
    [self.staticCollectionView reloadData];
    [self.staticCollectionView.collectionView registerNib:[UINib nibWithNibName:@"RuiXingCoffeeHomeHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ruixingHomeHeaderID];
}

static NSString *const cellId1 = @"kStaticCollectionViewCellID";

- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view {
    if ([view isKindOfClass:[SLStaticCollectionView class]]) {
        [collectionView registerNib:[UINib nibWithNibName:@"StaticCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId1];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
 
 UICollectionReusableView *supplementaryView;
 
 if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
     RuiXingCoffeeHomeHeaderView *view = (RuiXingCoffeeHomeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ruixingHomeHeaderID forIndexPath:indexPath];
     supplementaryView = view;
 }
// else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
// MGFooterView *view = (MGFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifierFooter forIndexPath:indexPath];
// view.footerLabel.text = [NSString stringWithFormat:@"MG这是Footer:%d",indexPath.section];
// supplementaryView = view;
//
// }
 
 return supplementaryView;
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    if ([view isKindOfClass:[SLStaticCollectionView class]]) {
        StaticCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId1 forIndexPath:indexPath];
        SLPupModel *pupModel = dataSource[indexPath.row];
        StaticCollectionModel *model = (StaticCollectionModel *)pupModel.data;
        cell.title = model.str;
        return cell;
    }
    return nil;
}

@end
