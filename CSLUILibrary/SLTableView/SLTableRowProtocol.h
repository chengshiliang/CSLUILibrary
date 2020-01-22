//
//  SLTableRowProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SLTableView;
typedef NS_ENUM(NSUInteger, SLTableType) {
    SLTableTypeXib = 1,
    SLTableTypeCode
};

typedef UITableViewCell *_Nonnull(^CellForRow)(SLTableView *_Nonnull tableView, NSIndexPath *_Nonnull indexPath);

@protocol SLTableRowProtocol <NSObject>
@property (nonatomic, copy) NSString *reuseIdentifier;

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat estimatedHeight;

@property (nonatomic, assign) SLTableType type;
///XIB Name or Class Name
@property (nonatomic, copy) NSString *registerName;

@property (nonatomic, copy) CellForRow cellForRowBlock;
@end

NS_ASSUME_NONNULL_END

