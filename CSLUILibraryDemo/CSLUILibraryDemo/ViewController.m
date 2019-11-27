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
           cell.textLabel.text = @"TabbarView";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"CustomView";
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
            cell.textLabel.text = @"StaticCollectionView";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"NoRuleCollectionView";
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
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    LabelController *vc = [storyboard instantiateViewControllerWithIdentifier:@"label"];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 1) {
                    ImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"imageView"];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 2) {
                    TabbarController *vc = [storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 3) {
                    CustomViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"custom"];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    RecycleViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"recycle"];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 1) {
                    PupViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"pupview"];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 2) {
                    SearchViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"search"];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 3) {
                    StaticCollectionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"staticcollect"];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 4) {
                   NoRuleCollectionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"norule"];
                   [strongSelf.navigationController pushViewController:vc animated:YES];
               }
            } else if (indexPath.section == 2) {
                 if (indexPath.row == 0) {
                     NavTranslucentViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"translucent"];
                     [strongSelf.navigationController pushViewController:vc animated:YES];
                 } else if (indexPath.row == 1) {
                     RuiXingCoffeeHomeVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"ruixinhome"];
                     [strongSelf.navigationController pushViewController:vc animated:YES];
                 }
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
