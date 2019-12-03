//
//  CustomTableCellController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/3.
//  Copyright © 2019 csl. All rights reserved.
//

#import "CustomTableCellController.h"

@implementation CustomTableView

- (NSString *)tableView:(SLTableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"title only";
    } else if (section == 1) {
        return @"常见功能组件";
    } else if (section == 2) {
        return @"特色功能";
    } else {
        return @"";
    }
}

- (void)tableView:(SLTableView *)tableView willDisplayCell:(SLTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SLTableModel *tableModel = tableView.tableDataSource[indexPath.section];
    SLRowTableModel *rowModel = tableModel.rowDataSource[indexPath.row];
    SLTableCellModel *model = (SLTableCellModel *)rowModel.tableRowData;
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 40)];
        cell.accessoryView = view;
    }
    cell.model = model;
}

@end

@interface CustomTableCellController ()<UITableViewDelegate>
@property (nonatomic, weak) IBOutlet CustomTableView *tableView;
@end

@implementation CustomTableCellController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray<SLTableModel *> *array = [NSMutableArray array];
    SLTableModel *tableModel1 = [[SLTableModel alloc]init];
    tableModel1.tableHeaderHeight = 30;
    NSMutableArray<SLRowTableModel *> *subArray = [NSMutableArray array];
    for (int j = 0; j < 10; j ++) {
        SLRowTableModel *rowModel = [[SLRowTableModel alloc]init];
        rowModel.tableRowHeight = 50;
        id model;
        if (j == 0) {
            SLTableCellModel *cellModel = [[SLTableCellModel alloc]init];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 0; i<1; i++) {
                SLTableCellTitleModel *model = [SLTableCellTitleModel new];
                model.title = @"单行文字";
                [arrayM addObject:model];
            }
            cellModel.leftTitleModels = arrayM.copy;
            cellModel.rightTitleModels = arrayM.copy;
            cellModel.isLeftImageLocal = YES;
            cellModel.isRightImageLocal = YES;
            cellModel.leftImageUrl = @"3.jpg";
            cellModel.rightImageUrl = @"3.jpg";
            model = cellModel;
        } else if (j == 1) {
            rowModel.tableRowHeight = 60;
            SLTableCellModel *cellModel = [[SLTableCellModel alloc]init];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 0; i<2; i++) {
                SLTableCellTitleModel *model = [SLTableCellTitleModel new];
                model.title = i==0 ? @"双行文字第一行" : @"双行文字第二行";
                [arrayM addObject:model];
            }
            cellModel.leftTitleModels = arrayM.copy;
            cellModel.rightTitleModels = arrayM.copy;
            cellModel.leftImageUrl = @"3.jpg";
            cellModel.rightImageUrl = @"3.jpg";
            cellModel.isLeftImageLocal = YES;
            cellModel.isRightImageLocal = YES;
            cellModel.leftCustomViewSize = CGSizeMake(40, 40);
            cellModel.rightCustomViewSize = CGSizeMake(40, 40);
            model = cellModel;
        }  else if (j == 2) {
            rowModel.tableRowHeight = 80;
            SLTableCellModel *cellModel = [[SLTableCellModel alloc]init];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 0; i<3; i++) {
                SLTableCellTitleModel *model = [SLTableCellTitleModel new];
                model.title = i==0 ? @"三行文字第一行" : (i==1 ? @"三行文字第二行" : @"三行文字第三行");
                [arrayM addObject:model];
            }
            cellModel.leftTitleModels = arrayM.copy;
            cellModel.rightTitleModels = arrayM.copy;
            cellModel.leftImageUrl = @"3.jpg";
            cellModel.rightImageUrl = @"3.jpg";
            cellModel.isLeftImageLocal = YES;
            cellModel.isRightImageLocal = YES;
            cellModel.leftCustomViewSize = CGSizeMake(60, 60);
            cellModel.rightCustomViewSize = CGSizeMake(60, 60);
            model = cellModel;
        } else {
            model = [[SLModel alloc]init];
        }
        
        rowModel.tableRowData = model;
        [subArray addObject:rowModel];
    }
    tableModel1.rowDataSource = subArray.copy;
    [array addObject:tableModel1];
    SLTableModel *tableModel2 = [[SLTableModel alloc]init];
    tableModel2.tableHeaderHeight = 30;
    subArray = [NSMutableArray array];
    for (int j = 0; j < 10; j ++) {
        SLRowTableModel *rowModel = [[SLRowTableModel alloc]init];
        rowModel.tableRowHeight = 50;
        id model = [[SLModel alloc]init];
        rowModel.tableRowData = model;
        [subArray addObject:rowModel];
    }
    tableModel2.rowDataSource = subArray.copy;
    [array addObject:tableModel2];
    self.tableView.tableDataSource = array.copy;
    [self.tableView reloadData];
}

@end
