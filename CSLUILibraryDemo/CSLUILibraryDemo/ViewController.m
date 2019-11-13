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
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 2;
//    } else if (section == 1) {
//        return 3;
//    }
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 30;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.000001;
//}
- (SLTableViewCell *)tableView:(MyTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ViewControllerCellId = @"ViewControllerCellId";
    SLTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ViewControllerCellId];
    if (cell == nil){
        cell = [[SLTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:ViewControllerCellId];
        cell.backgroundColor = [UIColor greenColor];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"UILabel";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"UIImageView";
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"indexpath~~~~~%ld---%ld",indexPath.section, indexPath.row];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"RecycleView";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"PupView";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"SearchControler";
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"indexpath~~~~~%ld---%ld",indexPath.section, indexPath.row];
        }
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"indexpath~~~~~%ld---%ld",indexPath.section, indexPath.row];
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
    NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(updateData) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)updateData {
    NSMutableArray<SLTableModel *> *array = [NSMutableArray array];
    [array addObjectsFromArray:self.tableView.tableDataSource];
    for (int i = 0; i< 50; i ++) {
        SLTableModel *tableModel = [[SLTableModel alloc]init];
        tableModel.tableHeaderHeight = arc4random()%2 == 0 ? 20 : 40;
        tableModel.tableFooterHeight = arc4random()%2 == 0 ? 40 : 60;
        NSMutableArray<SLRowTableModel *> *subArray = [NSMutableArray array];
        for (int j = 0; j < 50; j ++) {
            SLRowTableModel *rowModel = [[SLRowTableModel alloc]init];
            rowModel.tableRowHeight = arc4random()%2 == 0 ? 100 : 20;
            [subArray addObject:rowModel];
        }
        tableModel.rowDataSource = subArray.copy;
        [array addObject:tableModel];
    }
    self.tableView.tableDataSource = array.copy;
}

@end
