//
//  SLTableManager.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLTableSectionProtocol.h>

NS_ASSUME_NONNULL_BEGIN
@class SLTableProxy;
@interface SLTableManager : NSObject
@property (nonatomic, weak) SLTableView *tableView;
@property (nonatomic, strong) NSMutableArray<id<SLTableSectionProtocol>> *sections;
@property (nonatomic, strong) SLTableProxy *delegateHandler;
@property (nonatomic, copy) void(^selectTableView)(SLTableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, id<SLTableRowProtocol>rowModel);
@property (nonatomic, copy) void(^displayCell)(SLTableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, id<SLTableRowProtocol>rowModel);
@property (nonatomic, copy) void(^displayHeader)(SLTableView *tableView, UIView *view, NSInteger section, id<SLTableSectionProtocol>secModel);
@property (nonatomic, copy) void(^displayFooter)(SLTableView *tableView, UIView *view, NSInteger section, id<SLTableSectionProtocol>secModel);

- (id)initWithSections:(NSArray<id<SLTableSectionProtocol>> *)sections delegateHandler:(SLTableProxy *_Nullable)handler;

- (void)bindToTableView:(SLTableView *)tableView;

- (id<SLTableRowProtocol>)rowAtIndexPath:(NSIndexPath *)indexPath;

- (void)deleteRowAtIndexPaths:(NSArray<NSIndexPath *>*)indexPaths;

- (void)insertRowAtIndexPaths:(NSArray<NSIndexPath *>*)indexPaths;

- (void)exchangeRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (void)reloadData;
- (void)reloadDataWithIndexpaths:(NSArray<NSIndexPath *>*)indexpathSet;
@end

NS_ASSUME_NONNULL_END
