//
//  DropDownController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2020/1/17.
//  Copyright © 2020 csl. All rights reserved.
//

#import "DropDownController.h"
#import "StaticCollectionViewController.h"
#import "StaticCollectionViewCell.h"
#import "ViewController.h"

@implementation MyCollectRowModel
- (instancetype)init {
    if (self == [super init]) {
        self.reuseIdentifier = @"MyCollectRowCell";
        self.rowHeight = 40;
        self.rowWidth = 100;
        self.type = SLTableRowTypeCode;
        self.registerName = @"UICollectionViewCell";
    }
    return self;
}
@end
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
            secModel.rows = rowArrayM.copy;
            [arrayM addObject:secModel];
            dropDownView.type = SLDropDownViewDisplayCollect;
            dropDownView.collectDatas = arrayM;
            dropDownView.displayCollectCell = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
                if ([rowModel isKindOfClass:[MyCollectRowModel class]]) {
                    MyCollectRowModel *rowData = (MyCollectRowModel *)rowModel;
                    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    UILabel *lablt = [[UILabel alloc]initWithFrame:cell.bounds];
                    lablt.text = rowData.title;
                    lablt.textColor = [UIColor whiteColor];
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
            secModel.rows = rowArrayM.copy;
            [arrayM addObject:secModel];
            dropDownView.type = SLDropDownViewDisplayTable;
            dropDownView.tableDatas = arrayM;
            dropDownView.displayTableCell = ^(UITableView * _Nonnull tableView, UITableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLTableRowProtocol>  _Nonnull rowModel) {
                if ([rowModel isKindOfClass:[MyTableRowModel class]]) {
                    MyTableRowModel *rowData = (MyTableRowModel *)rowModel;
                    cell.textLabel.text = rowData.title;
                }
            };
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
