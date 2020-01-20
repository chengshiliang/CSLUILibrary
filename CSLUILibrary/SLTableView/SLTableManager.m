//
//  SLTableManager.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import "SLTableManager.h"
#import <CSLUILibrary/SLTableProxy.h>

@implementation SLTableManager
- (id)initWithSections:(NSArray<id<SLTableSectionProtocol>> *)sections delegateHandler:(SLTableProxy *)handler{
    self = [super init];
    if (self) {
        //保存数据源
        _sections = sections.mutableCopy;
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

- (void)bindToTableView:(UITableView *)tableView{
    tableView.delegate = self.delegateHandler;
    tableView.dataSource = self.delegateHandler;
    self.tableView = tableView;
}

- (id<SLTableRowProtocol>)rowAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(indexPath.section < self.sections.count, @"数组越界");
    id<SLTableSectionProtocol> section = self.sections[indexPath.section];
    if (indexPath.row < section.rows.count) {
        return section.rows[indexPath.row];
    }
    return nil;
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(indexPath.section < self.sections.count, @"数组越界");
    id<SLTableSectionProtocol> section = self.sections[indexPath.section];
    if (indexPath.row < section.rows.count) {
        [section.rows removeObjectAtIndex:indexPath.row];
    }
}

- (void)exchangeRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSAssert(fromIndexPath.section < self.sections.count, @"数组越界");
    NSAssert(toIndexPath.section < self.sections.count, @"数组越界");
    id<SLTableSectionProtocol> fromSection = self.sections[fromIndexPath.section];
    id<SLTableSectionProtocol> toSection = self.sections[toIndexPath.section];
    if (fromIndexPath.row < fromSection.rows.count && toIndexPath.row < toSection.rows.count) {
        id<SLTableRowProtocol> fromRow = fromSection.rows[fromIndexPath.row];
        id<SLTableRowProtocol> toRow = toSection.rows[toIndexPath.row];
        [fromSection.rows removeObjectAtIndex:fromIndexPath.row];
        [fromSection.rows insertObject:toRow atIndex:fromIndexPath.row];
        [toSection.rows removeObjectAtIndex:toIndexPath.row];
        [toSection.rows insertObject:fromRow atIndex:toIndexPath.row];
    }
}

- (void)reloadData{
    NSAssert(self.tableView != nil, @"tableView is nil");
    if ([NSThread isMainThread]) {
        [self.tableView reloadData];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

@end
