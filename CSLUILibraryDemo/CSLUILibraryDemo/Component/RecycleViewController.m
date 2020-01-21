//
//  RecycleViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/5.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RecycleViewController.h"
#import "MyCardCollectSectionModel.h"

@interface RecycleViewController ()
@property (weak, nonatomic) IBOutlet SLRecycleCollectionView *scollView1;
@property (weak, nonatomic) IBOutlet SLRecycleCollectionView *scollView2;
@end

@implementation RecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *_colorAry = [NSMutableArray array];
    [_colorAry addObject:[UIColor blackColor]];
    [_colorAry addObject:[UIColor blueColor]];
    [_colorAry addObject:[UIColor redColor]];
    [_colorAry addObject:[UIColor yellowColor]];
    [_colorAry addObject:[UIColor orangeColor]];
    MyRecycleSectionModel *secModel = [MyRecycleSectionModel new];
    secModel.insetForSection = UIEdgeInsetsMake(40, 20, 40, 20);
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        MyRecycleRowModel *model = [MyRecycleRowModel new];
        model.rowWidth = kScreenWidth-20;
        model.rowHeight = 50;
        model.str = [NSString stringWithFormat:@"第%d个", i];
        model.color = _colorAry[i%_colorAry.count];
        [arrM addObject:model];
    }
    secModel.rows = arrM.copy;
    self.scollView1.loop = YES;
    self.scollView1.dataSource = secModel;
    self.scollView2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.scollView1.interval = 1.0;
    self.scollView1.scrollToIndexBlock = ^(id<SLCollectRowProtocol>  _Nonnull model, NSInteger index) {
        NSLog(@"index %d", index);
    };
    WeakSelf;
    self.scollView1.selectCollectView = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
        StrongSelf;
        NSLog(@"click %d", [strongSelf.scollView1 indexOfSourceArray:indexPath.item]);
    };
    [self.scollView1 reloadData];
    MyRecycleSectionModel *secModel1 = [MyRecycleSectionModel new];
    secModel1.insetForSection = UIEdgeInsetsMake(40, 20, 40, 20);
    NSMutableArray *arrM1 = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        MyRecycleRowModel *model = [MyRecycleRowModel new];
        model.rowWidth = kScreenWidth-20;
        model.rowHeight = 80;
        model.str = [NSString stringWithFormat:@"第%d个", i];
        model.color = _colorAry[i%_colorAry.count];
        [arrM1 addObject:model];
    }
    secModel1.rows = arrM1.copy;
    self.scollView2.loop = YES;
    self.scollView2.dataSource = secModel1;
    self.scollView2.manual = NO;
    self.scollView2.interval = 3.0;// 在step的情况下等于speed
    self.scollView2.scrollStyle = SLRecycleCollectionViewStyleStep;
    self.scollView2.hidePageControl = YES;
    self.scollView2.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.scollView2.selectCollectView = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
        StrongSelf;
        NSLog(@"click222 %d", [strongSelf.scollView1 indexOfSourceArray:indexPath.item]);
    };
    [self.scollView2 reloadData];
}

@end
