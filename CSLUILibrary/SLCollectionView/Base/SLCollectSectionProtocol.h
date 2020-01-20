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
typedef UIView * _Nullable(^HeaderFooterCollect)(SLCollectBaseView *_Nullable collectView, NSInteger section);

@protocol SLCollectSectionProtocol <NSObject>
@property (nonatomic, strong) NSMutableArray<id<SLCollectRowProtocol>> *rows;

@property (nonatomic, strong) NSString *titleForHeader;
@property (nonatomic, assign) CGFloat heightForHeader;
@property (nonatomic, assign) CGFloat widthForHeader;

@property (nonatomic, assign) CGFloat heightForFooter;
@property (nonatomic, assign) CGFloat widthForFooter;

@property (nonatomic, strong) NSString *sectionIndexTitle;

@property (nonatomic, copy) HeaderFooterCollect viewForHeader;
@property (nonatomic, copy) HeaderFooterCollect viewForFooter;
@end

NS_ASSUME_NONNULL_END
