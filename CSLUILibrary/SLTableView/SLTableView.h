//
//  SLTabbleView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SLTableManager;
@interface SLTableView : UITableView
@property (nonatomic, strong) SLTableManager *manager;
@end

NS_ASSUME_NONNULL_END
