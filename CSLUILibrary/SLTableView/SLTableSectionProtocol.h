//
//  SLTableSectionProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLTableRowProtocol.h>

NS_ASSUME_NONNULL_BEGIN
typedef UIView * _Nullable(^HeaderFooter)(SLTableView *tableView, NSInteger section);

@protocol SLTableSectionProtocol <NSObject>
@property (nonatomic, strong) NSMutableArray<id<SLTableRowProtocol>> *rows;

@property (nonatomic, copy) NSString *titleForHeader;
@property (nonatomic, assign) CGFloat heightForHeader;
@property (nonatomic, assign) CGFloat estimatedHeightForHeader;

@property (nonatomic, copy) NSString *titleForFooter;
@property (nonatomic, assign) CGFloat heightForFooter;
@property (nonatomic, assign) CGFloat estimatedHeightForFooter;

@property (nonatomic, copy) NSString *sectionIndexTitle;

@property (nonatomic, copy) HeaderFooter viewForHeader;
@property (nonatomic, copy) HeaderFooter viewForFooter;

@property (nonatomic, copy) NSString *headerReuseIdentifier;
@property (nonatomic, assign) SLTableType headerType;
@property (nonatomic, copy) NSString *headerRegisterName;

@property (nonatomic, copy) NSString *footerReuseIdentifier;
@property (nonatomic, assign) SLTableType footerType;
@property (nonatomic, copy) NSString *footerRegisterName;
@end

NS_ASSUME_NONNULL_END
