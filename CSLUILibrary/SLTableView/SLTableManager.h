//
//  SLTableManager.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLTableSectionProtocol.h>
#import <CSLUILibrary/SLTableProxy.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTableManager : NSObject
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<id<SLTableSectionProtocol>> *sections;
@property (nonatomic, strong) SLTableProxy *delegateHandler;
//@property (nonatomic, strong) LGTablePreloader *preloader;

- (id)initWithSections:(NSArray<id<SLTableSectionProtocol>> *)sections delegateHandler:(SLTableProxy *)handler;

- (void)preLoadCellWithRowModel:(id<SLTableRowProtocol>)row;

- (void)bindToTableView:(UITableView *)tableView;

- (id<SLTableRowProtocol>)rowAtIndexPath:(NSIndexPath *)indexPath;

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)exchangeRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
