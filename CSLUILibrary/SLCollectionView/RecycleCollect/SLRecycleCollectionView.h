//
//  SLRecycleCollectionView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/12.
//

#import "SLView.h"
#import <CSLUILibrary/SLCollectSectionProtocol.h>
#import <CSLUILibrary/SLRecycleCollectionLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRecycleCollectionView : SLView
@property (nonatomic, assign, readonly) NSInteger currentPage;
@property (strong,nonatomic)id<SLCollectSectionProtocol>dataSource;
@property (nonatomic,copy) void(^scrollToIndexBlock)(id<SLCollectRowProtocol>model, NSInteger index);
@property (nonatomic, copy) void(^selectCollectView)(SLCollectBaseView *collectView, UICollectionViewCell *cell, NSIndexPath *indexPath, id<SLCollectRowProtocol>rowModel);
@property (nonatomic, copy) void(^displayCollectCell)(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel);
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, assign) SLRecycleCollectionViewStyle scrollStyle;
/**
 * 设置初始化时的位置页码，默认为0 只对分页效果有效
 */
@property (nonatomic, assign) NSInteger startingPosition;
@property (nonatomic, assign) CGFloat interval;// 轮播的时间 默认3秒
@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) BOOL manual;
@property (nonatomic, assign) BOOL hidePageControl;
@property (nonatomic, strong) UIImage *currentIndicatorImage;
@property (nonatomic, strong) UIImage *indicatorImage;
@property (nonatomic, strong) UIColor *currentIndicatorColor;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) CGFloat bottomSpace;// indicator距离底部距离，默认15.0
@property (assign, nonatomic) CGSize pageControlSize; // pagecontrol大小
- (void)reloadData;
- (NSInteger)indexOfSourceArray:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
