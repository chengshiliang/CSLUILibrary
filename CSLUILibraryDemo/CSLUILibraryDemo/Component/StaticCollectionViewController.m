//
//  StaticCollectionViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/25.
//  Copyright © 2019 csl. All rights reserved.
//

#import "StaticCollectionViewController.h"
#import "StaticCollectionViewCell.h"
#import "MyCardCollectSectionModel.h"

@interface StaticCollectionViewController ()<SLCollectionViewProtocol>
{
    NSArray *dataSource;
}
@property (nonatomic, weak) IBOutlet SLStaticCollectionView *staticCollectionView;
@property (nonatomic, weak) IBOutlet SLHorizontalCollectionView *horizontalCollectionView;
@property (nonatomic, weak) IBOutlet SLCardCollectionView *cardCollectionView;
@end

@implementation StaticCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyStaticCollectSectionModel *sectionModel2 = [[MyStaticCollectSectionModel alloc]init];
    NSMutableArray *arrM2 = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        MyStaticCollectRowModel *model = [MyStaticCollectRowModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        [arrM2 addObject:model];
    }
    sectionModel2.rows = arrM2.copy;
    self.staticCollectionView.dataSource = sectionModel2;
    self.staticCollectionView.columns = 4;
    self.staticCollectionView.selectCollectView = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
        NSLog(@"index %d", indexPath.row);
    };
    [self.staticCollectionView reloadData];
    
    self.horizontalCollectionView.dataSource = arrM2.copy;
    self.horizontalCollectionView.delegate = self;
    self.horizontalCollectionView.columnMagrin = 5.0f;
    [self.horizontalCollectionView reloadData];
    
    MyCardCollectSectionModel *sectionModel = [[MyCardCollectSectionModel alloc]init];
    NSMutableArray *arrM3 = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        StaticCollectionModel *model = [StaticCollectionModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        [arrM3 addObject:model];
    }
    sectionModel.rows = arrM3.copy;
    self.cardCollectionView.dataSource = sectionModel;
    self.cardCollectionView.direction = Vertical;
    self.cardCollectionView.scrollEndBlock = ^(NSInteger index) {NSLog(@"index %d", index);};
    [self.cardCollectionView reloadData];
}

static NSString *const cellId2 = @"kHorizontalCollectionViewCellID";

- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view {
    if ([view isKindOfClass:[SLHorizontalCollectionView class]]) {
        [collectionView registerNib:[UINib nibWithNibName:@"StaticCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId2];
    }
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    if ([view isKindOfClass:[SLHorizontalCollectionView class]]) {
        StaticCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId2 forIndexPath:indexPath];
        SLPupModel *pupModel = dataSource[indexPath.row];
        StaticCollectionModel *model = (StaticCollectionModel *)pupModel.data;
        cell.title = model.str;
        return cell;
    }
    return nil;
}
@end
