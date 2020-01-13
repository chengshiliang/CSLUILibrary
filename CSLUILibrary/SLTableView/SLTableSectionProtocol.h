//
//  SLTableSectionProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLTableRowProtocol.h>

NS_ASSUME_NONNULL_BEGIN
typedef UIView * _Nullable(^HeaderFooter)(UITableView *_Nullable tableView, NSInteger section);

@protocol SLTableSectionProtocol <NSObject>
@property (nonatomic, strong) NSMutableArray<id<SLTableRowProtocol>> *rows;

@property (nonatomic, strong) NSString *titleForHeader;
@property (nonatomic, assign) CGFloat heightForHeader;
@property (nonatomic, assign) CGFloat estimatedHeightForHeader;

@property (nonatomic, strong) NSString *titleForFooter;
@property (nonatomic, assign) CGFloat heightForFooter;
@property (nonatomic, assign) CGFloat estimatedHeightForFooter;

@property (nonatomic, strong) NSString *sectionIndexTitle;

@property (nonatomic, copy) HeaderFooter viewForHeader;
@property (nonatomic, copy) HeaderFooter viewForFooter;
@end

NS_ASSUME_NONNULL_END
