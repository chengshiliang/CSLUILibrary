//
//  PupViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/6.
//  Copyright © 2019 csl. All rights reserved.
//

#import "PupViewController.h"
#import "MyPupCollectionViewCell.h"
#import "MyCardCollectSectionModel.h"

@interface PupViewController()
@property (weak, nonatomic) IBOutlet SLPupView *pupView;
@end
@implementation PupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *_colorAry = [NSMutableArray array];
    [_colorAry addObject:[UIColor whiteColor]];
    [_colorAry addObject:[UIColor blackColor]];
    [_colorAry addObject:[UIColor blueColor]];
    [_colorAry addObject:[UIColor redColor]];
    [_colorAry addObject:[UIColor yellowColor]];
    [_colorAry addObject:[UIColor orangeColor]];
    [_colorAry addObject:[UIColor purpleColor]];
    MyPupCollectSectionModel *sectionModel = [[MyPupCollectSectionModel alloc]init];
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 30; i ++) {
        MyPupCollectRowModel *model = [MyPupCollectRowModel new];
        model.rowWidth = 300;
        model.rowHeight = 50*(i+1);
        model.color = _colorAry[i%_colorAry.count];
        [arrM addObject:model];
    }
    sectionModel.rows = arrM.copy;
    self.pupView.dataSource = sectionModel;
    self.pupView.columns = 4;
    self.pupView.selectCollectView = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
        NSLog(@"click %d", indexPath.row);
    };
    [self.pupView reloadData];
}
@end
