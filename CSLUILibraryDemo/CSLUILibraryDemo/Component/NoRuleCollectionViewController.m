//
//  NoRuleCollectionViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/26.
//  Copyright © 2019 csl. All rights reserved.
//

#import "NoRuleCollectionViewController.h"
#import "MyCardCollectSectionModel.h"

@interface NoRuleCollectionViewController ()
@property (nonatomic, weak) IBOutlet SLNoRuleCollectionView *noRuleCollectionView;
@end

@implementation NoRuleCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyNoRuleCollectSectionModel *secModel = [[MyNoRuleCollectSectionModel alloc]init];
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        MyNoRuleCollectRowModel *rowModel = [MyNoRuleCollectRowModel new];
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
        rowModel.rowWidth = width;
        rowModel.rowHeight = height;
        rowModel.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        if (i%3==0) {
            rowModel.color = [UIColor redColor];
        } else if (i%3==1) {
            rowModel.color = [UIColor greenColor];
        } else if (i%3==2) {
            rowModel.color = [UIColor blueColor];
        }
        [arrM addObject:rowModel];
    }
    secModel.rows = arrM.copy;
    self.noRuleCollectionView.dataSource = secModel;
    self.noRuleCollectionView.columns = 4;
    self.noRuleCollectionView.ajustFrame = NO;
    self.noRuleCollectionView.selectCollectView = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
        NSLog(@"click %d", indexPath.row);
    };
    [self.noRuleCollectionView reloadData];
}

@end
