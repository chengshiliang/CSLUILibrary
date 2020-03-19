//
//  StaticCollectionViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/25.
//  Copyright © 2019 csl. All rights reserved.
//

#import "StaticCollectionViewController.h"
#import "MyCardCollectSectionModel.h"

@interface StaticCollectionViewController ()
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
    sectionModel2.rows = arrM2;
    self.staticCollectionView.dataSource = sectionModel2;
    self.staticCollectionView.columns = 3;
    self.staticCollectionView.selectCollectView = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
    };
    [self.staticCollectionView reloadData];
    
    MyStaticCollectSectionModel *sectionModel3 = [[MyStaticCollectSectionModel alloc]init];
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        MyStaticCollectRowModel *model = [MyStaticCollectRowModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        model.rowWidth = 100;
        model.rowHeight = 50;
        [arrM addObject:model];
    }
    sectionModel3.rows = arrM;
    self.horizontalCollectionView.dataSource = sectionModel3;
    self.horizontalCollectionView.selectCollectView = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
    };
    [self.horizontalCollectionView reloadData];
    
    MyCardCollectSectionModel *sectionModel = [[MyCardCollectSectionModel alloc]init];
    NSMutableArray *arrM3 = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        StaticCollectionModel *model = [StaticCollectionModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        [arrM3 addObject:model];
    }
    sectionModel.rows = arrM3;
    self.cardCollectionView.dataSource = sectionModel;
    self.cardCollectionView.direction = Vertical;
    self.cardCollectionView.scrollEndBlock = ^(NSInteger index) {
        
    };
    [self.cardCollectionView reloadData];
}

@end
