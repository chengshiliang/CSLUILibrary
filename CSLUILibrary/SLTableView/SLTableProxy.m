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

@implementation SLTableProxy
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return _tableManager.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableManager.sections[section].rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<SLTableRowProtocol> row = [_tableManager rowAtIndexPath:indexPath];
    UITableViewCell *cell = row.cellForRowBlock(tableView, indexPath);
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<SLTableRowProtocol> rowModel = [_tableManager rowAtIndexPath:indexPath];
    if (rowModel) {
        if ([cell respondsToSelector:@selector(renderWithRowModel:)]) {
            [cell performSelector:@selector(renderWithRowModel:) withObject:rowModel];
        } else {
            !_tableManager.displayCell?:_tableManager.displayCell(tableView,cell,indexPath,rowModel);
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    id<SLTableSectionProtocol> sec = _tableManager.sections[section];
    if(sec) {
        if ([view respondsToSelector:@selector(renderHeaderWithSectionModel:)]) {
            [view performSelector:@selector(renderHeaderWithSectionModel:) withObject:sec];
        } else {
            !_tableManager.displayHeader?:_tableManager.displayHeader(tableView,view,section,sec);
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    id<SLTableSectionProtocol> sec = _tableManager.sections[section];
    if(sec) {
        if ([view respondsToSelector:@selector(renderFooterWithSectionModel:)]) {
            [view performSelector:@selector(renderFooterWithSectionModel:) withObject:sec];
        } else {
            !_tableManager.displayFooter?:_tableManager.displayFooter(tableView,view,section,sec);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_tableManager rowAtIndexPath:indexPath].rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_tableManager rowAtIndexPath:indexPath].estimatedHeight;
}

#pragma mark -- Header

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     return _tableManager.sections[section].titleForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _tableManager.sections[section].heightForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return _tableManager.sections[section].estimatedHeightForHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    id<SLTableSectionProtocol> sec = _tableManager.sections[section];
    return sec.viewForHeader ? sec.viewForHeader(tableView, section) : nil;
}

#pragma mark -- Footer

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return _tableManager.sections[section].titleForFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return _tableManager.sections[section].heightForFooter;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return _tableManager.sections[section].estimatedHeightForFooter;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    id<SLTableSectionProtocol> sec = _tableManager.sections[section];
    return sec.viewForFooter ? sec.viewForFooter(tableView, section) : nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (id<SLTableSectionProtocol> sec in _tableManager.sections) {
        if ([NSString emptyString:sec.sectionIndexTitle]) continue;
        [arrayM addObject:sec.sectionIndexTitle];
    }
    return arrayM.copy;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<SLTableRowProtocol> rowModel = [_tableManager rowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (rowModel) {
        !self.tableManager.selectTableView?:self.tableManager.selectTableView(tableView, cell, indexPath, rowModel);
    }
    
}
@end
