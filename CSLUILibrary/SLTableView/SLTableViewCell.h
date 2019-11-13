//
//  SLTableViewCell.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import <UIKit/UIKit.h>
#import <CSLUILibrary/SLTableModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTableViewCell : UITableViewCell
@property (nonatomic, copy) SLRowTableModel *cellDataSource;
@end

NS_ASSUME_NONNULL_END
