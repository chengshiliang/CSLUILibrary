//
//  SLTableModel.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLModel.h"
#import <CSLUILibrary/SLTableSectionProtocol.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SLTableRowModel <NSObject>
@end

@interface SLTableRowModel : SLModel<SLTableRowProtocol>
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat estimatedHeight;
@property (nonatomic, assign) SLTableType type;
@property (nonatomic, copy) NSString *registerName;
@property (nonatomic, copy) CellForRow cellForRowBlock;
@end

@protocol SLTableSectionModel <NSObject>
@end
@interface SLTableSectionModel : SLModel<SLTableSectionProtocol>
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

@protocol SLTableModel <NSObject>
@end
@interface SLTableModel : SLModel
@end

NS_ASSUME_NONNULL_END
