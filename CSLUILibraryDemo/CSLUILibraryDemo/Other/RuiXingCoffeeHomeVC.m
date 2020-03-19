//
//  RuiXingCoffeeHomeVC.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/27.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RuiXingCoffeeHomeVC.h"
#import "MyCardCollectSectionModel.h"
#import "RuiXingCoffeeHomeHeaderView.h"

@interface RuiXingCoffeeHomeVC ()
@property (nonatomic, strong) SLCollectBaseView *collectionView;
@end

@implementation RuiXingCoffeeHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    RuixingCoffeeSectionModel *secModel = [RuixingCoffeeSectionModel new];
    secModel.heightForHeader = kScreenWidth*(2.0/3+3.0/4);
    secModel.widthForHeader = kScreenWidth;
    secModel.insetForSection = UIEdgeInsetsMake(40, 20, 40, 20);
    secModel.headerRegisterName = @"RuiXingCoffeeHomeHeaderView";
    secModel.headerReuseIdentifier = @"RuixingCoffeeSection";
    
    MyRecycleSectionModel *secRecycleModel = [MyRecycleSectionModel new];
    secModel.insetForSection = UIEdgeInsetsMake(40, 20, 40, 20);
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        MyRecycleRowModel *model = [MyRecycleRowModel new];
        model.rowWidth = kScreenWidth-20;
        model.rowHeight = 50;
        model.str = [NSString stringWithFormat:@"第%d个", i];
        model.imageUrl = [NSString stringWithFormat:@"cir%d", i];
        [arrM addObject:model];
    }
    secRecycleModel.rows = arrM;
    secModel.recycleModel = secRecycleModel;
    
    MyNoRuleCollectSectionModel *secNoRuleModel = [[MyNoRuleCollectSectionModel alloc]init];
    NSMutableArray *arrM1 = [NSMutableArray array];
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
        [arrM1 addObject:rowModel];
    }
    secNoRuleModel.rows = arrM1;
    secModel.noRuleModel = secNoRuleModel;
    
    NSMutableArray<id<SLCollectRowProtocol>> *arrayM = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        StaticCollectionModel *model = [StaticCollectionModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        model.rowWidth = (kScreenWidth-40-5)/2.0;
        model.rowHeight = 200;
        [arrayM addObject:model];
    }
    secModel.rows = arrayM;
    self.collectionView = [[SLCollectBaseView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.collectionView];
    self.collectionView.manager = [[SLCollectManager alloc]initWithSections:[@[secModel]mutableCopy] delegateHandler:[SLCollectFlowlayoutProxy new]];
    self.collectionView.manager.displayHeader = ^(SLCollectBaseView * _Nonnull collectView, UIView * _Nonnull view, NSInteger section, id<SLCollectSectionProtocol>  _Nonnull secModel) {
        if ([view isKindOfClass:[RuiXingCoffeeHomeHeaderView class]] && section == 0 && [secModel isKindOfClass:[RuixingCoffeeSectionModel class]]) {
            RuiXingCoffeeHomeHeaderView *headerView = (RuiXingCoffeeHomeHeaderView *)view;
            RuixingCoffeeSectionModel *model = (RuixingCoffeeSectionModel *)secModel;
            headerView.recycleView.dataSource = model.recycleModel;
            [headerView.recycleView reloadData];
            headerView.noRuleCollectionView.dataSource = model.noRuleModel;
            [headerView.noRuleCollectionView reloadData];
        }
    };
    [self.collectionView.manager reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sl_hiddenNavbar];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
