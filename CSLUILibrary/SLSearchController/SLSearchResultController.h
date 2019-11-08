//
//  SLSearchResultController.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLSearchResultController : UITableViewController
@property(nonatomic, copy)NSArray *filterDataArr;
@property(nonatomic, copy)void(^selectBlock)(NSIndexPath *indexPath);
@end

NS_ASSUME_NONNULL_END
