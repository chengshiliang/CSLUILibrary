//
//  SLCollectSectionProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLCollectRowProtocol.h>

NS_ASSUME_NONNULL_BEGIN
@class SLCollectBaseView;
typedef UICollectionReusableView * _Nullable(^HeaderFooterCollect)(SLCollectBaseView *collectView, NSIndexPath *indexPath);

@protocol SLCollectSectionProtocol <NSObject>
@property (nonatomic, strong) NSMutableArray<id<SLCollectRowProtocol>> *rows;

@property (nonatomic, assign) CGFloat heightForHeader;
@property (nonatomic, assign) CGFloat widthForHeader;

@property (nonatomic, assign) CGFloat heightForFooter;
@property (nonatomic, assign) CGFloat widthForFooter;

@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) UIEdgeInsets insetForSection;

@property (nonatomic, copy) NSString *sectionIndexTitle;

@property (nonatomic, copy) HeaderFooterCollect viewForHeader;
@property (nonatomic, copy) HeaderFooterCollect viewForFooter;

@property (nonatomic, copy) NSString *headerReuseIdentifier;
@property (nonatomic, assign) SLCollectType headerType;
@property (nonatomic, copy) NSString *headerRegisterName;

@property (nonatomic, copy) NSString *footerReuseIdentifier;
@property (nonatomic, assign) SLCollectType footerType;
@property (nonatomic, copy) NSString *footerRegisterName;
@end

NS_ASSUME_NONNULL_END
