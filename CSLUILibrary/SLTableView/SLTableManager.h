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
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<id<SLTableSectionProtocol>> *sections;
@property (nonatomic, strong) SLTableProxy *delegateHandler;
@property (nonatomic, copy) void(^selectTableView)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) void(^displayCell)(UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, id<SLTableRowProtocol>rowModel);

- (id)initWithSections:(NSArray<id<SLTableSectionProtocol>> *)sections delegateHandler:(SLTableProxy *_Nullable)handler;

- (void)bindToTableView:(UITableView *)tableView;

- (id<SLTableRowProtocol>)rowAtIndexPath:(NSIndexPath *)indexPath;

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)exchangeRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
