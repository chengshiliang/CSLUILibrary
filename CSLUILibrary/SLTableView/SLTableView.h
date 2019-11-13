//
//  SLTabbleView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import <UIKit/UIKit.h>
#import <CSLUILibrary/SLTableModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTableView : UITableView
@property (nonatomic, copy) NSArray<SLTableModel *> *tableDataSource;
@end

NS_ASSUME_NONNULL_END
