//
//  SLTabbleView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import <UIKit/UIKit.h>
#import <CSLUILibrary/SLTableModel.h>
#import <CSLUILibrary/SLTableManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTableView : UITableView
@property (nonatomic, copy) NSArray<SLTableModel *> *tableDataSource;
@property (nonatomic, strong) SLTableManager *manager;
@end

NS_ASSUME_NONNULL_END
