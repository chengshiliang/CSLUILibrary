//
//  DropDownController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2020/1/17.
//  Copyright © 2020 csl. All rights reserved.
//

#import "DropDownController.h"
#import "MyCardCollectSectionModel.h"
#import "DropDownHeaderView.h"
#import "StaticCollectionViewCell.h"
#import "DropDownLeftTableCell.h"

@interface DropDownController ()
{
    BOOL show;
    NSInteger tag;
}
@end

@implementation DropDownController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self->show) return;
    SLDropDownView *dropDownView = [[SLDropDownView alloc]init];
    dropDownView.spaceVertical = 20;
    UITouch *touch = [touches anyObject];
    switch (self->tag) {
        case 0:
        {
            NSMutableArray<id<SLCollectSectionProtocol>> *arrayM = [NSMutableArray array];
            SLCollectSectionModel *secModel = [[SLCollectSectionModel alloc]init];
            NSArray *rowDataSource = @[@"COUNT 1", @"COUNT 2", @"COUNT 3", @"COUNT 4", @"COUNT 5", @"COUNT 6"];
            NSMutableArray<id<SLCollectRowProtocol>> *rowArrayM = [NSMutableArray arrayWithCapacity:rowDataSource.count];
            for (NSString *title in rowDataSource) {
                MyCollectRowModel *rowModel = [[MyCollectRowModel alloc]init];
                rowModel.title = title;
                [rowArrayM addObject:rowModel];
            }
            secModel.rows = rowArrayM;
            [arrayM addObject:secModel];
            dropDownView.type = SLDropDownViewDisplayCollect;
            dropDownView.collectDatas = arrayM;
            dropDownView.displayCollectCell = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
                if ([rowModel isKindOfClass:[MyCollectRowModel class]]) {
                    MyCollectRowModel *rowData = (MyCollectRowModel *)rowModel;
                    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    UILabel *lablt = [[UILabel alloc]initWithFrame:cell.bounds];
                    lablt.text = rowData.title;
                    lablt.textColor = [UIColor redColor];
                    [cell addSubview:lablt];
                }
            };
        }
            break;
        case 1:
        {
            NSMutableArray<id<SLTableSectionProtocol>> *arrayM = [NSMutableArray array];
            SLTableSectionModel *secModel = [[SLTableSectionModel alloc]init];
            NSArray *rowDataSource = @[@"COUNT 1", @"COUNT 2", @"COUNT 3", @"COUNT 4", @"COUNT 5", @"COUNT 6"];
            NSMutableArray<id<SLTableRowProtocol>> *rowArrayM = [NSMutableArray arrayWithCapacity:rowDataSource.count];
            for (NSString *title in rowDataSource) {
                MyTableRowModel *rowModel = [[MyTableRowModel alloc]init];
                rowModel.title = title;
                [rowArrayM addObject:rowModel];
            }
            secModel.rows = rowArrayM;
            [arrayM addObject:secModel];
            dropDownView.type = SLDropDownViewDisplayTable;
            dropDownView.tableDatas = arrayM;
            dropDownView.displayTableCell = ^(SLTableView * _Nonnull tableView, UITableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLTableRowProtocol>  _Nonnull rowModel) {
                if ([rowModel isKindOfClass:[MyTableRowModel class]]) {
                    MyTableRowModel *rowData = (MyTableRowModel *)rowModel;
                    cell.textLabel.text = rowData.title;
                }
            };
        }
            break;
        case 2:
        {
            NSMutableArray<id<SLCollectSectionProtocol>> *arrayM = [NSMutableArray array];
            for (int i = 0; i < 10; i++) {
                DropDownSectionModel *secModel = [[DropDownSectionModel alloc]init];
                secModel.heightForHeader = 30;
                secModel.widthForHeader = 80;
                secModel.headerRegisterName = @"DropDownHeaderView";
                secModel.headerReuseIdentifier = @"DropDownSectionModel";
                secModel.headerType = SLCollectTypeCode;
                secModel.title = [NSString stringWithFormat:@"SEC %d", i];
                NSMutableArray<id<SLCollectRowProtocol>> *rowArrayM = [NSMutableArray array];
                for (int j = 0; j < 6; j++) {
                    DropDownRowModel *rowModel = [[DropDownRowModel alloc]init];
                    rowModel.title = [NSString stringWithFormat:@"ROW %d %d", i, j];
                    rowModel.rowWidth = 80;
                    rowModel.rowHeight = 30;
                    rowModel.registerName = @"StaticCollectionViewCell";
                    rowModel.type = SLCollectTypeXib;
                    [rowArrayM addObject:rowModel];
                }
                secModel.rows = rowArrayM;
                [arrayM addObject:secModel];
            }
            dropDownView.type = SLDropDownViewDisplayCollect;
            dropDownView.collectDatas = arrayM;
            dropDownView.displayCollectHeader = ^(SLCollectBaseView * _Nonnull collectView, UIView * _Nonnull view, NSInteger section, id<SLCollectSectionProtocol>  _Nonnull secModel) {
                if ([view isKindOfClass:[DropDownHeaderView class]] && [secModel isKindOfClass:[DropDownSectionModel class]]) {
                    DropDownSectionModel *secData = (DropDownSectionModel *)secModel;
                    DropDownHeaderView *headerView = (DropDownHeaderView *)view;
                    headerView.title = secData.title;
                    headerView.width = secData.widthForHeader;
                }
            };
        }
            break;
        case 3:
        {
            NSMutableArray<DropDownTableSectionModel *> *arrayM = [NSMutableArray array];
            for (int i = 0; i < 10; i ++) {
                DropDownTableSectionModel *secModel = [[DropDownTableSectionModel alloc]init];
                secModel.heightForHeader = 30;
                secModel.headerRegisterName = @"DropDownLeftTableCell";
                secModel.headerReuseIdentifier = @"DropDownTableSectionModel";
                secModel.headerType = SLTableTypeCode;
                secModel.title = [NSString stringWithFormat:@"SEC %d", i];
                NSMutableArray<id<SLTableRowProtocol>> *rowArrayM = [NSMutableArray array];
                for (int j = 0; j < 6; j++) {
                    DropDownTableRowModel *rowModel = [[DropDownTableRowModel alloc]init];
                    rowModel.title = [NSString stringWithFormat:@"ROW %d %d", i, j];
                    rowModel.rowHeight = 30;
                    rowModel.estimatedHeight = 30;
                    rowModel.registerName = @"DropDownLeftTableCell";
                    rowModel.type = SLTableTypeCode;
                    [rowArrayM addObject:rowModel];
                }
                secModel.rows = rowArrayM;
                [arrayM addObject:secModel];
            }
            dropDownView.type = SLDropDownViewDisplayTable;
            dropDownView.tableDatas = arrayM;
            dropDownView.displayLeftTableCell = ^(SLTableView * _Nonnull tableView, UITableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLTableRowProtocol>  _Nonnull rowModel) {
                if ([rowModel isKindOfClass:[SLTableRowModel class]] && [cell isKindOfClass:[DropDownLeftTableCell class]]) {
                    DropDownLeftTableCell *leftCell = (DropDownLeftTableCell *)cell;
                    @try {
                        DropDownTableSectionModel *secModel = arrayM[indexPath.row];
                        leftCell.title = secModel.title;
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                }
            };
            dropDownView.displayTableCell = ^(SLTableView * _Nonnull tableView, UITableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLTableRowProtocol>  _Nonnull rowModel) {
                if ([rowModel isKindOfClass:[DropDownTableRowModel class]] && [cell isKindOfClass:[DropDownLeftTableCell class]]) {
                    DropDownLeftTableCell *leftCell = (DropDownLeftTableCell *)cell;
                    DropDownTableRowModel *rowData = (DropDownTableRowModel *)rowModel;
                    leftCell.title = rowData.title;
                }
            };
            dropDownView.leftTableWidth = kScreenWidth/3.0;
        }
            break;
        default:
            break;
    }
    WeakSelf;
    [dropDownView showToPoint:[touch locationInView:self.view] targetView:self.view completeBlock:^{
        StrongSelf;
        strongSelf->show = false;
    }];
    self->show = true;
    if (self->tag == 0) {
        self->tag = 1;
    } else if (self->tag == 1) {
        self->tag = 2;
    } else if (self->tag == 2) {
        self->tag = 3;
    } else if (self->tag == 3) {
        self->tag = 0;
    }
}

@end
