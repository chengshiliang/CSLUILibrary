//
//  StaticCollectionViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/25.
//  Copyright © 2019 csl. All rights reserved.
//

#import "StaticCollectionViewController.h"
#import "StaticCollectionViewCell.h"

@implementation StaticCollectionModel

@end

@interface StaticCollectionViewController ()<SLCollectionViewProtocol>
{
    NSArray *dataSource;
    NSArray *dataSource2;
}
@property (nonatomic, weak) IBOutlet SLStaticCollectionView *staticCollectionView;
@property (nonatomic, weak) IBOutlet SLHorizontalCollectionView *horizontalCollectionView;
@end

@implementation StaticCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *arrM1 = [NSMutableArray array];
    NSMutableArray *arrM2 = [NSMutableArray array];
    SLStaticCollectionModel *staticModel = [SLStaticCollectionModel new];
    for (int i = 0; i < 6; i ++) {
        SLPupModel *pupModel = [SLPupModel new];
        pupModel.width = 200;
        pupModel.height = 300;
        StaticCollectionModel *model = [StaticCollectionModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        pupModel.data = model;
        [arrM2 addObject:pupModel];
    }
    staticModel.datas = arrM2.copy;
    [arrM1 addObject:staticModel];
    dataSource = arrM2.copy;
    dataSource2 = arrM1.copy;
    self.staticCollectionView.dataSource = arrM1.copy;
    self.staticCollectionView.delegate = self;
    self.staticCollectionView.columns = 4;
    self.staticCollectionView.columnMagrin = 5.0f;
    self.staticCollectionView.rowMagrin = 5.0f;
    [self.staticCollectionView reloadData];
    
    self.horizontalCollectionView.dataSource = arrM2.copy;
    self.horizontalCollectionView.delegate = self;
    self.horizontalCollectionView.columnMagrin = 5.0f;
    [self.horizontalCollectionView reloadData];
}

static NSString *const cellId1 = @"kStaticCollectionViewCellID";
static NSString *const cellId2 = @"kHorizontalCollectionViewCellID";

- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view {
    if ([view isKindOfClass:[SLStaticCollectionView class]]) {
        [collectionView registerNib:[UINib nibWithNibName:@"StaticCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId1];
    } else if ([view isKindOfClass:[SLHorizontalCollectionView class]]) {
        [collectionView registerNib:[UINib nibWithNibName:@"StaticCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId2];
    }
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    if ([view isKindOfClass:[SLStaticCollectionView class]]) {
        StaticCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId1 forIndexPath:indexPath];
        SLStaticCollectionModel *staticModel = dataSource2[indexPath.section];
        SLPupModel *pupModel = staticModel.datas[indexPath.item];
        StaticCollectionModel *model = (StaticCollectionModel *)pupModel.data;
        cell.title = model.str;
        return cell;
    } else if ([view isKindOfClass:[SLHorizontalCollectionView class]]) {
        StaticCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId2 forIndexPath:indexPath];
        SLPupModel *pupModel = dataSource[indexPath.row];
        StaticCollectionModel *model = (StaticCollectionModel *)pupModel.data;
        cell.title = model.str;
        return cell;
    }
    return nil;
}
@end
