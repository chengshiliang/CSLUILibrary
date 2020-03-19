//
//  PageableCollectionController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/13.
//  Copyright © 2019 csl. All rights reserved.
//

#import "PageableCollectionController.h"
#import "MyCardCollectSectionModel.h"

@interface PageableCollectionController ()
@property (nonatomic, weak) IBOutlet SLPageableCollectionView *collectionView;
@end

@implementation PageableCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    SLPageableCollectSectionModel *secModel = [SLPageableCollectSectionModel new];
    secModel.minimumLineSpacing = 50;
    secModel.minimumInteritemSpacing = 10;
    secModel.insetForSection = UIEdgeInsetsMake(40, 20, 40, 20);
    NSMutableArray<SLPageableCollectRowModel *> *arrM = [NSMutableArray array];
    for (int i = 0; i < 2; i ++) {
        SLPageableCollectRowModel *rowModel = [SLPageableCollectRowModel new];
        MyStaticCollectSectionModel *secSubModel = [MyStaticCollectSectionModel new];
        NSMutableArray*arrM2 = [NSMutableArray array];
        for (int j = 0; j < 12; j ++) {
            MyStaticCollectRowModel *model = [MyStaticCollectRowModel new];
            model.str = [NSString stringWithFormat:@"COUNT%@", @(j)];
            [arrM2 addObject:model];
        }
        secSubModel.rows = arrM2;
        rowModel.rowModel = secSubModel;
        rowModel.rowWidth = kScreenWidth-50;
        [arrM addObject:rowModel];
    }
    secModel.rows = arrM;
    self.collectionView.dataSource = secModel;
    self.collectionView.columns = 4;
    self.collectionView.scrollToIndexBlock = ^(id<SLCollectRowProtocol>  _Nonnull model, NSInteger index) {

    };
    self.collectionView.selectSubCollectView = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {

    };
    [self.collectionView reload];
}

@end
