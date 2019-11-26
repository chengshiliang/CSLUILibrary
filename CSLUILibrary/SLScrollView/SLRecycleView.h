//
//  SLRecycleView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import "SLView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^RecycelViewScrollBlock)(NSInteger);

@interface SLRecycleView : SLView
@property (nonatomic, copy) NSArray *imageDatas;
@property (nonatomic, copy) NSArray *titleDatas;
@property (nonatomic) BOOL verticalScroll;// 默认no
@property (nonatomic, copy) RecycelViewScrollBlock indexChangeBlock;// 轮播滚动回调
@property (nonatomic) BOOL hidePageControl;// 默认no
@property (nonatomic) BOOL autoScroll;// 默认yes
@property (nonatomic) BOOL manualScroll;// 默认yes
@property (nonatomic) BOOL showTitle;// 默认no
@property (nonatomic, assign) CGFloat cellMargin; // 轮播图之间的间隔
@property (nonatomic, strong) UIFont *titleFont;// 文字字体
@property (nonatomic, strong) UIColor *titleColor;// 文字颜色
@property (nonatomic) NSTimeInterval autoTime;// 默认3.0
@property (nonatomic, strong) UIImage *currentIndicatorImage;
@property (nonatomic, strong) UIImage *indicatorImage;
@property (nonatomic, strong) UIColor *currentIndicatorColor;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) CGFloat bottomSpace;// indicator距离底部距离，默认15.0
@property (nonatomic, assign) CGFloat titleSpace;// 文字距离底部距离，默认10.0
@property (nonatomic, strong) UIImage *placeHolderImage; // 网络请求时的占位图片
@property (nonatomic, assign) NSLineBreakMode breakMode; // 文字换行样式
@property (assign, nonatomic) CGSize pageSize; // pagecontrol大小
- (void)startLoading;
- (void)startLoadingByIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
