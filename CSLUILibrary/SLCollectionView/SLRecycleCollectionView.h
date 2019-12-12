//
//  SLRecycleCollectionView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/12.
//

#import "SLView.h"
#import <CSLUILibrary/SLPupModel.h>
#import <CSLUILibrary/SLCollectionView.h>
#import <CSLUILibrary/SLCollectionViewCell.h>
#import <CSLUILibrary/SLCollectionViewProtocol.h>
#import <CSLUILibrary/SLRecycleCollectionLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRecycleCollectionView : SLView
@property(assign,nonatomic) float columnMagrin;//列距离
@property(assign,nonatomic) float rowMagrin;//行距离
@property(nonatomic,assign) UIEdgeInsets insets;// collectionView的内边距
@property(copy,nonatomic)NSArray<SLPupModel *> *dataSource;
@property(weak,nonatomic)id<SLCollectionViewProtocol>delegate;
@property(strong,nonatomic)SLCollectionView *collectionView;
@property(nonatomic,copy) void(^scrollToIndexBlock)(SLPupModel *model, NSInteger index);
@property(nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@property(nonatomic, assign) SLRecycleCollectionViewStyle scrollStyle;
/**
 * 设置初始化时的位置页码，默认为0 只对分页效果有效
 */
@property(nonatomic,assign) NSInteger startingPosition;
@property(nonatomic,assign) CGFloat interval;// 轮播的时间 默认3秒
@property(nonatomic,assign) BOOL loop;
@property(nonatomic,assign) BOOL manual;
@property(nonatomic,assign) BOOL hidePageControl;
@property (nonatomic, strong) UIImage *currentIndicatorImage;
@property (nonatomic, strong) UIImage *indicatorImage;
@property (nonatomic, strong) UIColor *currentIndicatorColor;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) CGFloat bottomSpace;// indicator距离底部距离，默认15.0
@property (assign, nonatomic) CGSize pageControlSize; // pagecontrol大小
- (void)reloadData;// 瀑布流刷新
@end

NS_ASSUME_NONNULL_END
