//
//  SLTableRowProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SLTableView;
typedef NS_ENUM(NSUInteger, SLTableRowType) {
    SLTableRowTypeXib,
    SLTableRowTypeCode
};

typedef UITableViewCell *_Nonnull(^CellForRow)(SLTableView *_Nonnull tableView, NSIndexPath *_Nonnull indexPath);

@protocol SLTableRowProtocol <NSObject>
@property (nonatomic, strong) NSString *reuseIdentifier;

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat estimatedHeight;

@property (nonatomic, assign) SLTableRowType type;

///XIB Name or Class Name
@property (nonatomic, strong) NSString *registerName;

@property (nonatomic, copy) CellForRow cellForRowBlock;
@end

NS_ASSUME_NONNULL_END

