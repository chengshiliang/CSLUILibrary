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
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat estimatedHeight;
@property (nonatomic, assign) SLTableRowType type;
@property (nonatomic, strong) NSString *registerName;
@property (nonatomic, copy) CellForRow cellForRowBlock;
@end

@protocol SLTableSectionModel <NSObject>
@end
@interface SLTableSectionModel : SLModel<SLTableSectionProtocol>
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

@protocol SLTableModel <NSObject>
@end
@interface SLTableModel : SLModel
@end

NS_ASSUME_NONNULL_END
