//
//  SLTableViewCell.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import <UIKit/UIKit.h>
#import <CSLUILibrary/SLTableModel.h>
#import <CSLUILibrary/SLTableCellProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTableViewCell : UITableViewCell
@property (nonatomic, weak) id<SLTableCellProtocol>model;
@end

NS_ASSUME_NONNULL_END
