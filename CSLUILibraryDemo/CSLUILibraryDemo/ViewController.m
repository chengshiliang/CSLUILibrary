//
//  ViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/10/31.
//  Copyright © 2019 csl. All rights reserved.
//

#import "ViewController.h"
#import "LabelController.h"
#import "ImageViewController.h"
#import "RecycleViewController.h"
#import "PupViewController.h"
#import "SearchViewController.h"
#import "NavTranslucentViewController.h"
#import "TabbarController.h"
#import "StaticCollectionViewController.h"
#import "NoRuleCollectionViewController.h"
#import "CustomViewController.h"
#import "RuiXingCoffeeHomeVC.h"
#import "ButtonController.h"
#import "CustomTableCellController.h"
#import "AlertController.h"

@implementation MyTableRowModel: SLTableRowModel
- (instancetype)init {
    if (self == [super init]) {
        self.reuseIdentifier = @"MyTableRowCell";
        self.rowHeight = 44.0;
        self.estimatedHeight = 44.0;
        self.type = SLTableRowTypeCode;
        self.registerName = @"UITableViewCell";
    }
    return self;
}
@end
@implementation MyTableSectionModel : SLTableSectionModel
- (instancetype)init {
    if (self == [super init]) {
        self.titleForHeader = @"";
        self.titleForFooter = @"";
        self.heightForHeader = 30.0;
        self.estimatedHeightForHeader = 30.0;
        self.heightForFooter = 0.0001;
        self.estimatedHeightForFooter = 0.0001;
        self.sectionIndexTitle = @"";
        self.viewForHeader = ^UIView * _Nullable(UITableView * _Nullable tableView, NSInteger section) {
            return nil;
        };
        self.viewForFooter = ^UIView * _Nullable(UITableView * _Nullable tableView, NSInteger section) {
            return nil;
        };
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleForHeader = title;
}
@end
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
        secModel.rows = rowArrayM.copy;
        [arrayM addObject:secModel];
    }
    self.tableView.manager = [[SLTableManager alloc]initWithSections:arrayM.copy delegateHandler:nil];
    [self.tableView.manager preLoadCellWithRowModel:[[MyTableRowModel alloc]init]];
    [self.tableView.manager reloadData];
    WeakSelf;
    self.tableView.manager.displayCell = ^(UITableView * _Nonnull tableView, UITableViewCell * _Nonnull cell, NSIndexPath *indexPath, id<SLTableRowProtocol>  _Nonnull rowModel) {
        if ([rowModel isKindOfClass:[MyTableRowModel class]]) {
            MyTableRowModel *rowData = (MyTableRowModel *)rowModel;
            cell.textLabel.text = rowData.title;
        }
    };
    self.tableView.manager.selectTableView = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
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
                vc = [storyboard instantiateViewControllerWithIdentifier:@"alert"];
            } else if (indexPath.row == 7) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"toast"];
            } else if (indexPath.row == 8) {
                vc = [storyboard instantiateViewControllerWithIdentifier:@"popover"];
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
