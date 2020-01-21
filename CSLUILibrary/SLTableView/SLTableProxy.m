//
//  SLTableProxy.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import "SLTableProxy.h"
#import <CSLUILibrary/SLTableManager.h>
#import <CSLUILibrary/SLTableRowRenderProtocol.h>
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/SLTableView.h>

@implementation SLTableProxy
- (NSInteger)numberOfSectionsInTableView:(SLTableView *)tableView{
   return _tableManager.sections.count;
}

- (NSInteger)tableView:(SLTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableManager.sections[section].rows.count;
}

- (UITableViewCell *)tableView:(SLTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<SLTableRowProtocol> row = [_tableManager rowAtIndexPath:indexPath];
    UITableViewCell *cell = row.cellForRowBlock(tableView, indexPath);
    return cell;
}

- (void)tableView:(SLTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<SLTableRowProtocol> rowModel = [_tableManager rowAtIndexPath:indexPath];
    if (rowModel) {
        if ([cell respondsToSelector:@selector(renderWithRowModel:)]) {
            [cell performSelector:@selector(renderWithRowModel:) withObject:rowModel];
        } else {
            !_tableManager.displayCell?:_tableManager.displayCell(tableView,cell,indexPath,rowModel);
        }
    }
}

- (void)tableView:(SLTableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    id<SLTableSectionProtocol> sec = _tableManager.sections[section];
    if(sec) {
        if ([view respondsToSelector:@selector(renderHeaderWithSectionModel:)]) {
            [view performSelector:@selector(renderHeaderWithSectionModel:) withObject:sec];
        } else {
            !_tableManager.displayHeader?:_tableManager.displayHeader(tableView,view,section,sec);
        }
    }
}

- (void)tableView:(SLTableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    id<SLTableSectionProtocol> sec = _tableManager.sections[section];
    if(sec) {
        if ([view respondsToSelector:@selector(renderFooterWithSectionModel:)]) {
            [view performSelector:@selector(renderFooterWithSectionModel:) withObject:sec];
        } else {
            !_tableManager.displayFooter?:_tableManager.displayFooter(tableView,view,section,sec);
        }
    }
}

- (CGFloat)tableView:(SLTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_tableManager rowAtIndexPath:indexPath].rowHeight;
}

- (CGFloat)tableView:(SLTableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_tableManager rowAtIndexPath:indexPath].estimatedHeight;
}

#pragma mark -- Header

- (NSString *)tableView:(SLTableView *)tableView titleForHeaderInSection:(NSInteger)section{
     return _tableManager.sections[section].titleForHeader;
}

- (CGFloat)tableView:(SLTableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _tableManager.sections[section].heightForHeader;
}

- (CGFloat)tableView:(SLTableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return _tableManager.sections[section].estimatedHeightForHeader;
}

- (UIView *)tableView:(SLTableView *)tableView viewForHeaderInSection:(NSInteger)section{
    id<SLTableSectionProtocol> sec = _tableManager.sections[section];
    return sec.viewForHeader ? sec.viewForHeader(tableView, section) : nil;
}

#pragma mark -- Footer

- (NSString *)tableView:(SLTableView *)tableView titleForFooterInSection:(NSInteger)section{
    return _tableManager.sections[section].titleForFooter;
}

- (CGFloat)tableView:(SLTableView *)tableView heightForFooterInSection:(NSInteger)section{
    return _tableManager.sections[section].heightForFooter;
}

- (CGFloat)tableView:(SLTableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return _tableManager.sections[section].estimatedHeightForFooter;
}

- (UIView *)tableView:(SLTableView *)tableView viewForFooterInSection:(NSInteger)section{
    id<SLTableSectionProtocol> sec = _tableManager.sections[section];
    return sec.viewForFooter ? sec.viewForFooter(tableView, section) : nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(SLTableView *)tableView {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (id<SLTableSectionProtocol> sec in _tableManager.sections) {
        if ([NSString emptyString:sec.sectionIndexTitle]) continue;
        [arrayM addObject:sec.sectionIndexTitle];
    }
    return arrayM.copy;
}

- (void)tableView:(SLTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<SLTableRowProtocol> rowModel = [_tableManager rowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (rowModel) {
        !self.tableManager.selectTableView?:self.tableManager.selectTableView(tableView, cell, indexPath, rowModel);
    }
    
}
@end
