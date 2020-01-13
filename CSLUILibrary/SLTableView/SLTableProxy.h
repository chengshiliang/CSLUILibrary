//
//  SLTableProxy.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SLTableManager;
@interface SLTableProxy : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) SLTableManager *tableManager;
@end

NS_ASSUME_NONNULL_END
