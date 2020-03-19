//
//  SLTableManager.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import "SLTableManager.h"
#import <CSLUILibrary/SLTableProxy.h>
#import <CSLUILibrary/SLTableView.h>
#import <CSLCommonLibrary/SLUtil.h>

@interface SLTableManager()
@property (nonatomic, strong) dispatch_queue_t dataQueue;
@end

@implementation SLTableManager
- (id)initWithSections:(NSMutableArray<id<SLTableSectionProtocol>> *)sections delegateHandler:(SLTableProxy *)handler{
    self = [super init];
    if (self) {
        self.dataQueue = dispatch_queue_create("com.csl.tablemanager.data", DISPATCH_QUEUE_SERIAL);
        //保存数据源
        _sections = sections;
        //设置代理
        if (!handler) {
            _delegateHandler = [[SLTableProxy alloc]init];
        } else {
            _delegateHandler = handler;
        }
        _delegateHandler.tableManager = self;
    }
    return self;
}

- (void)bindToTableView:(SLTableView *)tableView{
    tableView.delegate = self.delegateHandler;
    tableView.dataSource = self.delegateHandler;
    self.tableView = tableView;
}

- (id<SLTableRowProtocol>)rowAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(indexPath.section < self.sections.count, @"数组越界");
    __block id<SLTableRowProtocol> rowData = nil;
    dispatch_sync(self.dataQueue, ^{
        id<SLTableSectionProtocol> section = self.sections[indexPath.section];
        if (indexPath.row < section.rows.count) {
            rowData = section.rows[indexPath.row];
        }
    });
    return rowData;
}

- (void)deleteRowAtIndexPaths:(NSArray<NSIndexPath *>*)indexPaths{
    NSAssert(self.tableView != nil, @"tableView is nil");
    dispatch_barrier_async(self.dataQueue, ^{
        for (NSIndexPath *indexPath in indexPaths) {
            if (indexPath.section > self.sections.count-1) continue;
            id<SLTableSectionProtocol> section = self.sections[indexPath.section];
            if (indexPath.row > section.rows.count-1) continue;
            [section.rows removeObjectAtIndex:indexPath.row];
        }
        [SLUtil runInMain:^{
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    });
}

- (void)insertRowAtIndexPath:(NSIndexPath*)indexPath withObject:(id<SLTableSectionProtocol>)secData{
    NSAssert(self.tableView != nil, @"tableView is nil");
    NSAssert(secData != nil, @"insert object with nil");
    dispatch_barrier_async(self.dataQueue, ^{
        if (indexPath.section > self.sections.count-1) {
            [self.sections insertObject:secData atIndex:indexPath.section];
        } else {
            id<SLTableSectionProtocol> section = self.sections[indexPath.section];
            NSInteger row = indexPath.row >= section.rows.count ? section.rows.count : indexPath.row;
            [section.rows insertObject:secData.rows[row] atIndex:row];
        }
        [SLUtil runInMain:^{
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    });
}

- (void)exchangeRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSAssert(fromIndexPath.section < self.sections.count, @"数组越界");
    NSAssert(toIndexPath.section < self.sections.count, @"数组越界");
    dispatch_barrier_async(self.dataQueue, ^{
        id<SLTableSectionProtocol> fromSection = self.sections[fromIndexPath.section];
        id<SLTableSectionProtocol> toSection = self.sections[toIndexPath.section];
        if (fromIndexPath.row < fromSection.rows.count && toIndexPath.row < toSection.rows.count) {
            id<SLTableRowProtocol> fromRow = fromSection.rows[fromIndexPath.row];
            id<SLTableRowProtocol> toRow = toSection.rows[toIndexPath.row];
            [fromSection.rows removeObjectAtIndex:fromIndexPath.row];
            [fromSection.rows insertObject:toRow atIndex:fromIndexPath.row];
            [toSection.rows removeObjectAtIndex:toIndexPath.row];
            [toSection.rows insertObject:fromRow atIndex:toIndexPath.row];
            [SLUtil runInMain:^{
                [self.tableView beginUpdates];
                [self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                [self.tableView endUpdates];
            }];
        }
    });
}

- (void)reloadData{
    NSAssert(self.tableView != nil, @"tableView is nil");
    [SLUtil runInMain:^{
        [self.tableView reloadData];
    }];
}

- (void)reloadDataWithIndexpaths:(NSArray<NSIndexPath *> *)indexpathSet {
    NSAssert(self.tableView != nil, @"tableView is nil");
    [SLUtil runInMain:^{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexpathSet withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];
}
@end
