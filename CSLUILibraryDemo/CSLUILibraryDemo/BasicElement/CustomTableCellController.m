//
//  CustomTableCellController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/3.
//  Copyright © 2019 csl. All rights reserved.
//

#import "CustomTableCellController.h"

@implementation CustomTableCellModel

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsMake(30, 20, 30, 20);
}

- (UIImageView *)leftImage {
    UIImageView *imageView = [super leftImage];
    if (!imageView) return nil;
    [imageView addCorner:YES borderWidth:0.0 borderColor:nil];
    return imageView;
}

- (NSArray<UILabel *> *)leftTitles {
    NSArray *labes = [super leftTitles];
    for (UILabel *label in labes) {
        label.backgroundColor = [UIColor redColor];
        CGRect frame = label.frame;
        frame.size.width = 85;
        label.frame = frame;
    }
    return labes;
}

- (NSArray<UILabel *> *)rightTitles {
    NSArray *labes = [super rightTitles];
    for (UILabel *label in labes) {
        label.textAlignment = NSTextAlignmentLeft;
    }
    return labes;
}

- (UIView *)leftView {
    if ([super leftView]) return [super leftView];
    UIImageView *imageView = [super leftImage];
    imageView.frame = CGRectMake(0, 3, 57, 54);
    [imageView addCorner:YES borderWidth:0.0 borderColor:nil];
    self.customLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [super leftViewSize].width, [super leftViewSize].height)];
    [self.customLeftView addSubview:imageView];
    UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(54, 0, 6, 6)];
    [self.customLeftView addSubview:dotView];
    [dotView addCornerRadius:3 borderWidth:0.0 borderColor:nil backGroundColor:[UIColor redColor]];
    return [super leftView];
}

- (UIView *)middleView {
    if ([super middleView]) return [super middleView];
    self.customMiddleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.customMiddleView.backgroundColor = [UIColor yellowColor];
    return [super middleView];
}

@end

@implementation CustomTableView

- (NSString *)tableView:(SLTableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (void)tableView:(SLTableView *)tableView willDisplayCell:(SLTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SLTableModel *tableModel = tableView.tableDataSource[indexPath.section];
    SLRowTableModel *rowModel = tableModel.rowDataSource[indexPath.row];
    SLTableCellModel *model = (SLTableCellModel *)rowModel.tableRowData;
//    if (indexPath.section == 0 && indexPath.row == 2) {
//        cell.accessoryView = nil;
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 40)];
//        cell.accessoryView = view;
//    }
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
            model = cellModel;
        } else if (j == 1) {
            rowModel.tableRowHeight = 60;
            SLTableCellModel *cellModel = [[SLTableCellModel alloc]init];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 0; i<2; i++) {
                SLTableCellTitleModel *model = [SLTableCellTitleModel new];
                model.title = i==0 ? @"两行文字第一行" : @"两行文字第二行";
                [arrayM addObject:model];
            }
            cellModel.leftTitleModels = arrayM.copy;
            cellModel.rightTitleModels = arrayM.copy;
            model = cellModel;
        } else if (j == 2) {
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
            model = cellModel;
        } else if (j == 3) {
            SLTableCellModel *cellModel = [[SLTableCellModel alloc]init];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 0; i<1; i++) {
                SLTableCellTitleModel *model = [SLTableCellTitleModel new];
                model.title = @"单行文字";
                [arrayM addObject:model];
            }
            cellModel.leftTitleModels = arrayM.copy;
            cellModel.rightTitleModels = arrayM.copy;
            cellModel.leftImageUrl = @"3.jpg";
            cellModel.rightImageUrl = @"3.jpg";
            cellModel.isLeftImageLocal = YES;
            cellModel.isRightImageLocal = YES;
            cellModel.leftCustomViewSize = CGSizeMake(20, 20);
            cellModel.rightCustomViewSize = CGSizeMake(20, 20);
            model = cellModel;
        } else if (j == 4) {
            rowModel.tableRowHeight = 60;
            SLTableCellModel *cellModel = [[SLTableCellModel alloc]init];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 0; i<2; i++) {
                SLTableCellTitleModel *model = [SLTableCellTitleModel new];
                model.title = i==0 ? @"两行文字第一行" : @"两行文字第二行";
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
        } else if (j == 5) {
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
        } else if (j == 6) {
            rowModel.tableRowHeight = 80;
            CustomTableCellModel *cellModel = [[CustomTableCellModel alloc]init];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 0; i<3; i++) {
                SLTableCellTitleModel *model = [SLTableCellTitleModel new];
                model.title = i==0 ? @"三行文字第一行" : (i==1 ? @"三行文字第二行" : @"三行文字第三行");
                [arrayM addObject:model];
            }
            cellModel.leftTitleModels = arrayM.copy;
            cellModel.rightTitleModels = arrayM.copy;
            UIView *leftCustomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
            SLImageView *leftImageView = [[SLImageView alloc]initWithFrame:CGRectMake(0, 3, 54, 54)];
            [leftImageView sl_setImage:[UIImage imageNamed:@"3.jpg"]];
            [leftCustomView addSubview:leftImageView];
            UIView *leftDotView = [[UIView alloc]initWithFrame:CGRectMake(54, 0, 6, 6)];
            [leftCustomView addSubview:leftDotView];
            [leftDotView addCornerRadius:3 borderWidth:0.0 borderColor:nil backGroundColor:[UIColor redColor]];
            UIView *rightCustomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
            SLImageView *rightImageView = [[SLImageView alloc]initWithFrame:CGRectMake(0, 3, 54, 54)];
            [rightImageView sl_setImage:[UIImage imageNamed:@"3.jpg"]];
            [rightCustomView addSubview:rightImageView];
            UIView *rightDotView = [[UIView alloc]initWithFrame:CGRectMake(54, 0, 6, 6)];
            [rightCustomView addSubview:rightDotView];
            [rightDotView addCornerRadius:3 borderWidth:0.0 borderColor:nil backGroundColor:[UIColor redColor]];
            cellModel.customLeftView = leftCustomView;
            cellModel.customRightView = rightCustomView;
            cellModel.leftCustomViewSize = CGSizeMake(60, 60);
            cellModel.rightCustomViewSize = CGSizeMake(60, 60);
            model = cellModel;
        } else if (j == 7) {
            rowModel.tableRowHeight = 80;
            CustomTableCellModel *cellModel = [[CustomTableCellModel alloc]init];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 0; i<3; i++) {
               SLTableCellTitleModel *model = [SLTableCellTitleModel new];
               model.title = i==0 ? @"三行文字第一行" : (i==1 ? @"三行文字第二行" : @"三行文字第三行");
               [arrayM addObject:model];
            }
            cellModel.leftTitleModels = arrayM.copy;
            cellModel.rightTitleModels = arrayM.copy;
            cellModel.leftImageUrl = @"3.jpg";
            cellModel.isLeftImageLocal = YES;
            cellModel.rightImageUrl = @"3.jpg";
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
    self.tableView.tableDataSource = array.copy;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

@end
