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

#import "CSLDelegateProxy.h"

@implementation MyTableView
- (SLTableViewCell *)tableView:(MyTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ViewControllerCellId = @"ViewControllerCellId";
    SLTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ViewControllerCellId];
    if (cell == nil){
        cell = [[SLTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:ViewControllerCellId];
        cell.backgroundColor = [UIColor greenColor];
    }
    SLTableModel *tableModel = self.tableDataSource[indexPath.section];
    SLRowTableModel *rowModel = tableModel.rowDataSource[indexPath.row];
    MyTableModel *model = (MyTableModel *)rowModel.tableRowData;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"UILabel";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"UIImageView";
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
        } else {
            cell.textLabel.text = model.key;
        }
    } else {
        cell.textLabel.text = model.key;
    }
    return cell;
}

- (NSString *)tableView:(MyTableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"基础元素";
    } else if (section == 1) {
        return @"常见功能组件";
    } else {
        return @"";
    }
}

- (void)tableView:(MyTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableDelegate && [self.tableDelegate respondsToSelector:@selector(didSelect:indexPath:)]) {
        [self.tableDelegate didSelect:tableView indexPath:indexPath];
    }
}
@end
@implementation MyTableModel

@end
@interface ViewController ()
@property (weak, nonatomic) IBOutlet MyTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
                }
            }
        }
    }];
    self.tableView.tableDelegate = (id<MyTableViewDelegate>)delegateProxy;
    NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateData) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)updateData {
    NSMutableArray<SLTableModel *> *array = [NSMutableArray array];
    [array addObjectsFromArray:self.tableView.tableDataSource];
    for (int i = 0; i< 3; i ++) {
        SLTableModel *tableModel = [[SLTableModel alloc]init];
        tableModel.tableHeaderHeight = 30;
//        tableModel.tableFooterHeight = 0.0001;
        NSMutableArray<SLRowTableModel *> *subArray = [NSMutableArray array];
        for (int j = 0; j < 3; j ++) {
            SLRowTableModel *rowModel = [[SLRowTableModel alloc]init];
            rowModel.tableRowHeight = 44;
            rowModel.tableRowData = [[MyTableModel alloc]initWithDictionary:@{@"key": [NSString stringWithFormat:@"section---%d;row---%d",i,j]} error:nil];
            [subArray addObject:rowModel];
        }
        tableModel.rowDataSource = subArray.copy;
        [array addObject:tableModel];
    }
    self.tableView.tableDataSource = array.copy;
    [self.tableView reloadData];
}

@end
