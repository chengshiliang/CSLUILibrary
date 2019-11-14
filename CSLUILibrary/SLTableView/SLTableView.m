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

//static const NSInteger maxTableCount = 200;
//static const NSInteger minRefreshCount = 10;

@interface SLTableView()<UITableViewDelegate, UITableViewDataSource>
@property (assign, nonatomic) CFRunLoopObserverRef observer;
//@property (strong, nonatomic) NSMutableArray *spareArray;
@property (strong, nonatomic) NSMutableArray *indexPaths;
//@property (nonatomic, strong) NSMutableArray<SLTableModel *> *dataArr;
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
//    self.spareArray = [NSMutableArray array];
    self.indexPaths = [NSMutableArray array];
    self.lock = [[NSLock alloc]init];
//    self.dataArr = [NSMutableArray array];
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
        NSTimeInterval currentTimeInterVal = [[NSDate date] timeIntervalSince1970];
        if (currentTimeInterVal - timeInterVal < 0.2) {
            return ;
        }
        timeInterVal = currentTimeInterVal;
        StrongSelf;
        CFStringRef model = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
        NSString *modeString = (__bridge NSString *)model;
        CFRelease(model);
//            NSArray <SLTableModel *>*subArr = @[];
//            NSMutableArray <SLTableModel *>*tableDatas = strongSelf.tableDataSource.mutableCopy;
//            if (tableDatas.count > 0) {
//                NSRange range;
//                if (tableDatas.count >= minRefreshCount) {
//                    range = NSMakeRange(0, minRefreshCount);
//                }else{
//                    range = NSMakeRange(0, tableDatas.count-1);
//                }
//                subArr = [tableDatas subarrayWithRange:range];
//                [tableDatas removeObjectsInRange:range];
//            }
//            strongSelf.tableDataSource = tableDatas.copy;
//            if (subArr.count > 0) {
//                [strongSelf.dataArr addObjectsFromArray:subArr.copy];
//                if (strongSelf.dataArr.count == subArr.count) {
//                    [SLUtil runInMain:^{
//                        [strongSelf reloadData];
//                    }];
//                    [strongSelf.lock unlock];
//                    return;
//                }
//                NSMutableArray *indexPathArrayM = [NSMutableArray array];
//                for (int section = 0; section < subArr.count; section ++) {
//                    SLTableModel *tableModel = subArr[section];
//                    NSArray <SLRowTableModel *>*rowModels = tableModel.rowDataSource;
//                    for (int row = 0; row < rowModels.count; row++) {
//                        [indexPathArrayM addObject:[NSIndexPath indexPathForRow:row inSection:strongSelf.dataArr.count-subArr.count+section]];
//                    }
//                }
//                [SLUtil runInMain:^{
//                    [strongSelf beginUpdates];
//                    [strongSelf insertRowsAtIndexPaths:indexPathArrayM.copy withRowAnimation:UITableViewRowAnimationFade];
//                    [strongSelf endUpdates];
//                }];
//            }
//        else
        if ([modeString isEqualToString:@"UITrackingRunLoopMode"]) {
            [strongSelf.lock lock];
            [strongSelf.indexPaths removeAllObjects];
            NSArray *visibleCells = [strongSelf visibleCells];
            for (SLTableViewCell *cell in visibleCells) {
                if (fabs(cell.cellDataSource.tableRowHeight - cell.frame.size.height) > 0.1) {
                    [strongSelf.indexPaths addObject:[strongSelf indexPathForCell:cell]];
                }
            }
            if (strongSelf.indexPaths.count > 0) {
                [SLUtil runInMain:^{
                    [strongSelf beginUpdates];
                    [strongSelf reloadRowsAtIndexPaths:strongSelf.indexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [strongSelf endUpdates];
                }];
            }
            [strongSelf.lock unlock];
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observer, kCFRunLoopCommonModes);
}

- (void)dealloc {
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SLTableModel *tableModel = self.tableDataSource[section];
    return tableModel.rowDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLTableModel *tableModel = self.tableDataSource[indexPath.section];
    SLRowTableModel *rowModel = tableModel.rowDataSource[indexPath.row];
    return rowModel.tableRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SLTableModel *tableModel = self.tableDataSource[section];
    return tableModel.tableHeaderHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SLTableModel *tableModel = self.tableDataSource[section];
    return tableModel.tableFooterHeight;
}

- (SLTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [self tableView:tableView cellForRowAtIndexPath:indexPath];
    }
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
