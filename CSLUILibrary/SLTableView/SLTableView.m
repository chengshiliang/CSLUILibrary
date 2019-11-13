//
//  SLTabbleView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLTableView.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CSLUILibrary/SLUtil.h>
#import <CSLUILibrary/SLTableViewCell.h>
#import <CSLUILibrary/SLUIConsts.h>

@interface SLTableView()<UITableViewDelegate, UITableViewDataSource>
@property (assign, nonatomic) CFRunLoopObserverRef observer;
@property (strong, nonatomic) NSMutableArray *indexPaths;
@property (nonatomic, strong) NSMutableArray<SLTableModel *> *dataArr;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation SLTableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    self.indexPaths = [NSMutableArray array];
    self.lock = [[NSLock alloc]init];
    self.dataArr = [NSMutableArray array];
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.estimatedRowHeight = 0;
    if (@available(iOS 11, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    self.delegate = self;
    self.dataSource = self;
    WeakSelf;
    __block NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
    self.observer =  CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        // 控制频率
        NSTimeInterval currentTimeInterVal = [[NSDate date] timeIntervalSince1970];
        if (currentTimeInterVal - timeInterVal < 0.2) {
            return ;
        }
        timeInterVal = currentTimeInterVal;
        StrongSelf;
        [strongSelf.lock lock];
        NSArray *subArr = @[];
        NSMutableArray *tableDatas = strongSelf.tableDataSource.mutableCopy;
        if (tableDatas.count > 0) {
            NSRange range;
            if (tableDatas.count >= 50) {
                range = NSMakeRange(0, 50);
            }else{
                range = NSMakeRange(0, tableDatas.count-1);
            }
            subArr = [tableDatas subarrayWithRange:range];
            [tableDatas removeObjectsInRange:range];
        }
        strongSelf.tableDataSource = tableDatas.copy;
        if (strongSelf.dataArr.count >= 1000) {
            strongSelf.dataArr = [strongSelf.dataArr subarrayWithRange:NSMakeRange(50, 950)].mutableCopy;
        }
        if (subArr.count > 0) {
            [strongSelf.dataArr addObjectsFromArray:subArr];
            [SLUtil runInMain:^{
                [strongSelf reloadData]; // 刷新界面
            }];
        }
        [strongSelf.lock unlock];
//        [strongSelf.indexPaths removeAllObjects];
//        NSArray *visibleCells = [strongSelf visibleCells];
//        for (SLTableViewCell *cell in visibleCells) {
//            NSIndexPath *indexPath = [strongSelf indexPathForCell:cell];
//            SLTableModel *tableModel = strongSelf.tableDataSource[indexPath.section];
//            cell.cellDataSource = tableModel.rowDataSource[indexPath.row];
//            if (fabs([cell.cellDataSource tableRowHeight] - cell.frame.size.height) > 0.1) {
//                [strongSelf.indexPaths addObject:indexPath];
//            }
//        }
//         [strongSelf.lock unlock];
//        if (strongSelf.indexPaths.count > 0) {
//            [SLUtil runInMain:^{
//                [strongSelf beginUpdates];
//                [strongSelf reloadRowsAtIndexPaths:strongSelf.indexPaths withRowAnimation:UITableViewRowAnimationNone];
//                [strongSelf endUpdates];
//            }];
//        }
    });
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
}

- (void)dealloc {
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SLTableModel *tableModel = self.dataArr[section];
    return tableModel.rowDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLTableModel *tableModel = self.dataArr[indexPath.section];
    SLRowTableModel *rowModel = tableModel.rowDataSource[indexPath.row];
    return rowModel.tableRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SLTableModel *tableModel = self.dataArr[section];
    return tableModel.tableHeaderHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SLTableModel *tableModel = self.dataArr[section];
    return tableModel.tableFooterHeight;
}

- (SLTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        NSLog(@"!!!%@", indexPath);
        return [self tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    NSLog(@"~~~%@", indexPath);
    NSString * TableViewCellId = [NSString stringWithFormat:@"%@CellID", NSStringFromClass(self.class)];
    SLTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellId];
    if (cell == nil){
        cell = [[SLTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:TableViewCellId];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([self respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [self tableView:tableView titleForHeaderInSection:section];
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
