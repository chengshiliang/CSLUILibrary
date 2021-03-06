//
//  ViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/10/31.
//  Copyright © 2019 csl. All rights reserved.
//

#import "ViewController.h"

#import "RouteConfig.h"

#import "MyCardCollectSectionModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SLTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self updateData];
}

- (void)updateData {
    NSArray *dataSource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ViewControllerData" ofType:@"plist"]];
    NSMutableArray<id<SLTableSectionProtocol>> *arrayM = [NSMutableArray arrayWithCapacity:dataSource.count];
    for (NSDictionary *dic in dataSource) {
        MyTableSectionModel *secModel = [[MyTableSectionModel alloc]init];
        secModel.title = dic[@"title"];
        NSArray *rowDataSource = dic[@"rows"];
        NSMutableArray<id<SLTableRowProtocol>> *rowArrayM = [NSMutableArray arrayWithCapacity:rowDataSource.count];
        for (NSDictionary *rowDic in rowDataSource) {
            MyTableRowModel *rowModel = [[MyTableRowModel alloc]init];
            rowModel.title = rowDic[@"title"];
            [rowArrayM addObject:rowModel];
        }
        secModel.rows = rowArrayM;
        [arrayM addObject:secModel];
    }
    self.tableView.manager = [[SLTableManager alloc]initWithSections:arrayM.copy delegateHandler:nil];
    [self.tableView.manager reloadData];
    WeakSelf;
    self.tableView.manager.displayCell = ^(UITableView * _Nonnull tableView, UITableViewCell * _Nonnull cell, NSIndexPath *indexPath, id<SLTableRowProtocol>  _Nonnull rowModel) {
        if ([rowModel isKindOfClass:[MyTableRowModel class]]) {
            MyTableRowModel *rowData = (MyTableRowModel *)rowModel;
            cell.textLabel.text = rowData.title;
        }
    };
    self.tableView.manager.selectTableView = ^(UITableView * _Nonnull tableView, UITableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLTableRowProtocol>  _Nonnull rowModel) {
        StrongSelf;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = nil;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"label"];
            } else if (indexPath.row == 1) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"imageView"];
            } else if (indexPath.row == 2) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
            } else if (indexPath.row == 3) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"button"];
            } else if (indexPath.row == 4) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"cell"];
            } else if (indexPath.row == 5) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"custom"];
            } else if (indexPath.row == 6) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"noticebar"];
            } else if (indexPath.row == 7) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"progress"];
            } else if (indexPath.row == 8) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"slider"];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"recycle"];
            } else if (indexPath.row == 1) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"pupview"];
            } else if (indexPath.row == 2) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"search"];
            } else if (indexPath.row == 3) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"staticcollect"];
            } else if (indexPath.row == 4) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"norule"];
            } else if (indexPath.row == 5) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"pageable"];
            } else if (indexPath.row == 6) {
                vc = [[[Route new] produce]getTargetVC];// [storyboard instantiateViewControllerWithIdentifier:@"alert"];
            } else if (indexPath.row == 7) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"toast"];
            } else if (indexPath.row == 8) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"popover"];
            } else if (indexPath.row == 9) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"dropdown"];
            } else if (indexPath.row == 10) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"paint"];
                [strongSelf presentViewController:vc animated:YES completion:nil];
                return;
            }
        } else if (indexPath.section == 2) {
             if (indexPath.row == 0) {
                 vc = [storyboard instantiateViewControllerWithIdentifier:@"translucent"];
             } else if (indexPath.row == 1) {
                 vc = [storyboard instantiateViewControllerWithIdentifier:@"ruixinhome"];
             } else if (indexPath.row == 2) {
                 vc = [storyboard instantiateViewControllerWithIdentifier:@"filedownload"];
             }
        }
        if (vc) {
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    };
}

@end
