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

@implementation MyTableView
- (void)tableView:(SLTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SLTableModel *tableModel = self.tableDataSource[indexPath.section];
    SLRowTableModel *rowModel = tableModel.rowDataSource[indexPath.row];
    MyTableModel *model = (MyTableModel *)rowModel.tableRowData;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"UILabel";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"UIImageView";
        } else if (indexPath.row == 2) {
           cell.textLabel.text = @"自定义tabbar";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"UIButton";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"自定义cell";
        } else if (indexPath.row == 5) {
            cell.textLabel.text = @"特色view";
        } else {
            cell.textLabel.text = model.key;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"RecycleView";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"PupView";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"SearchControler";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"CollectionView";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"不规则的CollectionView";
        } else {
            cell.textLabel.text = model.key;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"NavTranslucent";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"瑞幸咖啡首页";
        } else {
            cell.textLabel.text = model.key;
        }
    } else {
        cell.textLabel.text = model.key;
    }
}

- (NSString *)tableView:(MyTableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"基础元素";
    } else if (section == 1) {
        return @"常见功能组件";
    } else if (section == 2) {
        return @"特色功能";
    } else {
        return @"";
    }
}

- (void)tableView:(MyTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.tableDelegate && [self.tableDelegate respondsToSelector:@selector(didSelect:indexPath:)]) {
        [self.tableDelegate didSelect:tableView indexPath:indexPath];
    }
}
@end
@implementation MyTableModel

@end
@interface ViewController ()
{
    SLTimer *timer;
}
@property (weak, nonatomic) IBOutlet MyTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    CSLDelegateProxy *delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(MyTableViewDelegate)];
    __weak typeof (self)weakSelf = self;
    [delegateProxy addSelector:@selector(didSelect:indexPath:) callback:^(NSArray *params) {
        if (params && params.count == 2) {
            NSIndexPath *indexPath = params[1];
            __strong typeof (weakSelf)strongSelf = weakSelf;
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
               }
            } else if (indexPath.section == 2) {
                 if (indexPath.row == 0) {
                     vc = [storyboard instantiateViewControllerWithIdentifier:@"translucent"];
                 } else if (indexPath.row == 1) {
                     vc = [storyboard instantiateViewControllerWithIdentifier:@"ruixinhome"];
                 }
            }
            if (vc) {
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
    self.tableView.tableDelegate = (id<MyTableViewDelegate>)delegateProxy;
    
    timer =  [SLTimer sl_timerWithTimeInterval:.5f target:self userInfo:nil repeats:YES mode:NSRunLoopCommonModes callback:^(NSArray * _Nonnull array) {
        __strong typeof (weakSelf)strongSelf = weakSelf;
        [strongSelf updateData];
    }];
}

- (void)updateData {
    NSMutableArray<SLTableModel *> *array = [NSMutableArray array];
    [array addObjectsFromArray:self.tableView.tableDataSource];
    if (array.count >= 100 && timer) {
        [timer invalidate];
        timer = nil;
        return;
    }
    for (int i = 0; i< 10; i ++) {
        SLTableModel *tableModel = [[SLTableModel alloc]init];
        tableModel.tableHeaderHeight = 30;
        NSMutableArray<SLRowTableModel *> *subArray = [NSMutableArray array];
        for (int j = 0; j < 10; j ++) {
            SLRowTableModel *rowModel = [[SLRowTableModel alloc]init];
            rowModel.tableRowHeight = 50;
            rowModel.tableRowData = [[MyTableModel alloc]initWithDictionary:@{@"key": [NSString stringWithFormat:@"section---%ld;row---%d",self.tableView.tableDataSource.count + i,j]} error:nil];
            [subArray addObject:rowModel];
        }
        tableModel.rowDataSource = subArray.copy;
        [array addObject:tableModel];
    }
    self.tableView.tableDataSource = array.copy;
    [self.tableView reloadData];
}

@end
