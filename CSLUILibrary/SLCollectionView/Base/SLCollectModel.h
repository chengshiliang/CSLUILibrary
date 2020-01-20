//
//  SLCollectModel.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLModel.h"
#import <CSLUILibrary/SLCollectSectionProtocol.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SLCollectRowModel <NSObject>
@end

@interface SLCollectRowModel : SLModel<SLCollectRowProtocol>
@property (nonatomic, strong) NSString *reuseIdentifier;

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat rowWidth;

@property (nonatomic, assign) SLCollectRowType type;

///XIB Name or Class Name
@property (nonatomic, strong) NSString *registerName;

@property (nonatomic, copy) CollectCellForRow cellForRowBlock;
@end

@protocol SLCollectSectionModel <NSObject>
@end
@interface SLCollectSectionModel : SLModel<SLCollectSectionProtocol>
@property (nonatomic, strong) NSMutableArray<id<SLCollectRowProtocol>> *rows;

@property (nonatomic, strong) NSString *titleForHeader;
@property (nonatomic, assign) CGFloat heightForHeader;
@property (nonatomic, assign) CGFloat widthForHeader;

@property (nonatomic, assign) CGFloat heightForFooter;
@property (nonatomic, assign) CGFloat widthForFooter;

@property (nonatomic, strong) NSString *sectionIndexTitle;

@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) UIEdgeInsets insetForSection;

@property (nonatomic, copy) HeaderFooterCollect viewForHeader;
@property (nonatomic, copy) HeaderFooterCollect viewForFooter;
@end

@protocol SLCollectModel <NSObject>
@end
@interface SLCollectModel : SLModel
@end

NS_ASSUME_NONNULL_END
