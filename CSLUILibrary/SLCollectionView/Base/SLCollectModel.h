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
@property (nonatomic, copy) NSString *reuseIdentifier;

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat rowWidth;

@property (nonatomic, assign) SLCollectType type;

///XIB Name or Class Name
@property (nonatomic, copy) NSString *registerName;

@property (nonatomic, copy) CollectCellForRow cellForRowBlock;
@end

@protocol SLCollectSectionModel <NSObject>
@end
@interface SLCollectSectionModel : SLModel<SLCollectSectionProtocol>
@property (nonatomic, strong) NSMutableArray<id<SLCollectRowProtocol>> *rows;

@property (nonatomic, copy) NSString *titleForHeader;
@property (nonatomic, assign) CGFloat heightForHeader;
@property (nonatomic, assign) CGFloat widthForHeader;

@property (nonatomic, assign) CGFloat heightForFooter;
@property (nonatomic, assign) CGFloat widthForFooter;

@property (nonatomic, copy) NSString *sectionIndexTitle;

@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) UIEdgeInsets insetForSection;

@property (nonatomic, copy) HeaderFooterCollect viewForHeader;
@property (nonatomic, copy) HeaderFooterCollect viewForFooter;

@property (nonatomic, copy) NSString *headerReuseIdentifier;
@property (nonatomic, assign) SLCollectType headerType;
@property (nonatomic, copy) NSString *headerRegisterName;

@property (nonatomic, copy) NSString *footerReuseIdentifier;
@property (nonatomic, assign) SLCollectType footerType;
@property (nonatomic, copy) NSString *footerRegisterName;
@end

@protocol SLCollectModel <NSObject>
@end
@interface SLCollectModel : SLModel
@end

NS_ASSUME_NONNULL_END
