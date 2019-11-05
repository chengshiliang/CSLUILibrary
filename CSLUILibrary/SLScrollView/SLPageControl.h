//
//  SLPageControl.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SLPageControlAlignment) {
    SLPageControlAlignmentLeft = 1,
    SLPageControlAlignmentCenter = 0,
    SLPageControlAlignmentRight =2
};

typedef NS_ENUM(NSUInteger, SLPageControlTapBehavior) {
    SLPageControlTapBehaviorStep = 1,
    SLPageControlTapBehaviorJump
};

@interface SLPageControl : UIControl
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGFloat indicatorMargin;
@property (nonatomic) CGFloat indicatorDiameter;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic) SLPageControlAlignment alignment;
@property (nonatomic) SLPageControlTapBehavior tapBehavior;
@property (nonatomic, strong) UIImage *indicatorImage;
@property (nonatomic, strong) UIImage *indicatorMaskImage;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, strong) UIImage *currentIndicatorImage;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
@property (nonatomic) BOOL hidesForSinglePage;
@property (nonatomic) BOOL defersCurrentPageDisplay;

- (void)updateCurrentPageDisplay;
- (CGRect)rectForPageIndicator:(NSInteger)pageIndex;
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;
- (void)setImage:(UIImage *)image forPage:(NSInteger)pageIndex;
- (void)setCurrentImage:(UIImage *)image forPage:(NSInteger)pageIndex;
- (void)setImageMask:(UIImage *)image forPage:(NSInteger)pageIndex;
- (UIImage *)imageForPage:(NSInteger)pageIndex;
- (UIImage *)currentImageForPage:(NSInteger)pageIndex;
- (UIImage *)imageMaskForPage:(NSInteger)pageIndex;
- (void)updatePageNumberForScrollView:(UIScrollView *)scrollView;
- (void)setScrollViewContentOffsetForCurrentPage:(UIScrollView *)scrollView animated:(BOOL)animated;
- (void)setName:(NSString *)name forPage:(NSInteger)pageIndex;
- (NSString *)nameForPage:(NSInteger)pageIndex;
@end

NS_ASSUME_NONNULL_END
