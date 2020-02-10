//
//  SLRecycleCollectionView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/12.
//

#import "SLRecycleCollectionView.h"
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLCommonLibrary/UIView+SLBase.h>
#import <CSLCommonLibrary/SLTimer.h>
#import <CSLUILibrary/SLPageControl.h>
#import <CSLUILibrary/SLCollectBaseView.h>
#import <CSLUILibrary/SLCollectManager.h>
#import <CSLUILibrary/SLCollectProxy.h>

@interface SLRecycleCollectionView()
{
    BOOL needRefresh;
}
@property (strong, nonatomic) SLRecycleCollectionLayout *layout;
@property (strong, nonatomic) SLCollectBaseView *collectionView;
@property (nonatomic, strong) SLTimer * timer;
@property (nonatomic, assign) NSInteger rightCount;
@property (nonatomic, assign) NSInteger leftCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) SLPageControl *pageControl;
@property (nonatomic, assign) UIEdgeInsets collectInsets;
@end

@implementation SLRecycleCollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.scrollStyle = SLRecycleCollectionViewStylePage;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.startingPosition = 0;
    self.interval = 3.0;
    self.loop = YES;
    self.manual = YES;
    self.hidePageControl = NO;
    self.layout=[[SLRecycleCollectionLayout alloc]init];
    self.collectionView=[[SLCollectBaseView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.decelerationRate = 0;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    self.collectionView.frame = CGRectMake(self.collectInsets.left, self.collectInsets.top, CGRectGetWidth(self.bounds)-self.collectInsets.left-self.collectInsets.right, CGRectGetHeight(self.bounds)-self.collectInsets.top-self.collectInsets.bottom);
    if (needRefresh) {
        [self reloadData];
    }
}

- (void)reloadData {
    self.collectInsets = self.dataSource.insetForSection;
    if (self.collectionView.sl_width <= 0 || self.collectionView.sl_height <= 0) {
        needRefresh = true;
        return;
    }
    needRefresh = false;
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
    self.layout.scrollStyle = self.scrollStyle;
    self.layout.scrollDirection = self.scrollDirection;
    self.dataArray = [self.dataSource.rows copy];
    self.dataSource.insetForSection = UIEdgeInsetsZero;
    self.collectionView.manager = [[SLCollectManager alloc]initWithSections:@[self.dataSource] delegateHandler:[SLCollectRecycleProxy new]];
    self.collectionView.manager.selectCollectView = [self.selectCollectView copy];
    self.collectionView.manager.displayCell = [self.displayCollectCell copy];
    WeakSelf;
    self.collectionView.manager.scrollViewDidScrollCallback = ^(SLCollectBaseView * _Nonnull collectView) {
        StrongSelf;
        [strongSelf scrollViewDidScroll:collectView];
    };
    self.collectionView.manager.scrollViewDidEndDeceleratingCallback = ^(SLCollectBaseView * _Nonnull collectView) {
        StrongSelf;
        [strongSelf scrollViewDidEndDecelerating:collectView];
    };
    self.collectionView.manager.scrollViewDidEndDraggingCallback = ^(SLCollectBaseView * _Nonnull collectView, BOOL decelerate) {
        StrongSelf;
        [strongSelf scrollViewDidEndDragging:collectView willDecelerate:decelerate];
    };
    self.collectionView.manager.scrollViewWillBeginDraggingCallback = ^(SLCollectBaseView * _Nonnull collectView) {
        StrongSelf;
        [strongSelf scrollViewWillBeginDragging:collectView];
    };
    self.collectionView.manager.scrollViewDidEndScrollingAnimationCallback = ^(SLCollectBaseView * _Nonnull collectView) {
        StrongSelf;
        [strongSelf scrollViewDidEndScrollingAnimation:collectView];
    };
    if (self.scrollStyle == SLRecycleCollectionViewStyleStep) self.manual = NO;
    CGFloat width = 0;
    CGFloat height = 0;
    for (int i = 0; i<self.dataSource.rows.count; i ++) {
        id<SLCollectRowProtocol>model = self.dataSource.rows[i];
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            model.rowHeight = self.collectionView.sl_height;
            model.rowWidth = MIN(model.rowWidth, self.collectionView.sl_width);
            width += model.rowWidth;
        } else {
            model.rowWidth = self.collectionView.sl_width;
            model.rowHeight = MIN(model.rowHeight, self.collectionView.sl_height);
            height += model.rowHeight;
        }
    }
    if (self.loop && self.dataSource.rows.count > 0) {
        if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal && width >= self.collectionView.sl_width){
            self.rightCount = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.sl_width - 1, 0)].row + 1;
            if (self.scrollStyle == SLRecycleCollectionViewStylePage){
                self.leftCount = self.dataArray.count - [self.collectionView indexPathForItemAtPoint:CGPointMake(width - self.collectionView.sl_width + 1, 0)].row;
            }
        }else if(self.scrollDirection == UICollectionViewScrollDirectionVertical && height >=self.collectionView.sl_height){
            self.rightCount = [self.collectionView indexPathForItemAtPoint:CGPointMake(0, self.collectionView.sl_height - 1)].row + 1;
            if (self.scrollStyle == SLRecycleCollectionViewStylePage){
                self.leftCount = self.dataArray.count - [self.collectionView indexPathForItemAtPoint:CGPointMake(0, height - self.collectionView.sl_height + 1)].row;
            }
        }
        NSArray * rightSubArray = [self.dataSource.rows subarrayWithRange:NSMakeRange(0, self.rightCount)];
        self.dataSource.rows = [self.dataSource.rows arrayByAddingObjectsFromArray:rightSubArray].mutableCopy;
        if (self.scrollStyle == SLRecycleCollectionViewStylePage){
            NSArray * leftSubArray = [self.dataSource.rows subarrayWithRange:NSMakeRange(self.dataSource.rows.count - self.leftCount, self.leftCount)];
            self.dataSource.rows = [leftSubArray arrayByAddingObjectsFromArray:self.dataSource.rows].mutableCopy;
        }
    }
    [self.collectionView.manager setSections:@[self.dataSource]];
    [self.collectionView.manager reloadData];
    if(!self.manual){
        for(UIGestureRecognizer *g in self.collectionView.gestureRecognizers){
            [self.collectionView removeGestureRecognizer:g];
        }
    }
    if (self.scrollStyle == SLRecycleCollectionViewStylePage) {
        if (self.startingPosition >= self.dataArray.count || self.startingPosition < 0) {
            self.startingPosition = 0;
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.startingPosition + self.leftCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }else{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.startingPosition + self.leftCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }
        if (self.scrollToIndexBlock) self.scrollToIndexBlock(self.dataArray[self.startingPosition], self.startingPosition);
        if (!self.hidePageControl && self.dataArray.count >= 2) {
            self.pageControl = [[SLPageControl alloc] init];
            CGSize pageControlSize = CGSizeMake(100, 15);
            if (self.pageControlSize.width > 0 && self.pageControlSize.height > 0) {
                pageControlSize = self.pageControlSize;
            }
            self.pageControl.frame = CGRectMake((self.sl_width-pageControlSize.width)/2.0,self.sl_height-pageControlSize.height-self.bottomSpace-self.collectInsets.bottom, pageControlSize.width, pageControlSize.height);
            if(self.indicatorImage){ // 自定义图片
                self.pageControl.indicatorImage = self.indicatorImage;
                if (self.currentIndicatorImage) {
                    self.pageControl.currentIndicatorImage = self.currentIndicatorImage;
                } else {
                    self.pageControl.currentIndicatorImage = self.indicatorImage;
                }
            }else{
                self.pageControl.currentPageIndicatorTintColor = self.currentIndicatorColor ?: SLUIHexColor(0xffffff);
                self.pageControl.pageIndicatorTintColor = self.indicatorColor ?: SLUIHexColor(0x999999);
            }
            self.pageControl.numberOfPages = self.dataArray.count;
            self.pageControl.currentPage = self.startingPosition;
            [self addSubview:self.pageControl];
        }
    }
    [self startTime];
}

- (void)horizontalRollAnimation{
    if (self.collectionView.contentSize.width <= 0) return;
    [self resetContentOffset];
    if (self.scrollStyle == SLRecycleCollectionViewStylePage){
        NSInteger currentMiddleIndex= [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x + self.collectionView.sl_width/2, 0)].row;
        NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:(currentMiddleIndex + 1) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else{
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + self.interval, 0) animated:NO];
    }
}

- (void)verticalRollAnimation{
    if (self.collectionView.contentSize.height <= 0) return;
    [self resetContentOffset];
    if (self.scrollStyle == SLRecycleCollectionViewStylePage){
        NSInteger currentMiddleIndex= [self.collectionView indexPathForItemAtPoint:CGPointMake(0, self.collectionView.contentOffset.y + self.collectionView.sl_height/2)].row;
        NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:(currentMiddleIndex + 1) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    } else {
        [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + self.interval) animated:NO];
    }
}

- (void)resetContentOffset{
    CGPoint connectionPoint = CGPointZero;
    if (self.scrollStyle == SLRecycleCollectionViewStyleStep){
        UICollectionViewCell * item = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.rows.count - self.rightCount inSection:0]];
        connectionPoint = [self.collectionView convertRect:item.frame toView:self.collectionView].origin;
    }
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        if (self.scrollStyle == SLRecycleCollectionViewStylePage) {
            NSInteger currentMiddleIndex = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x + self.collectionView.sl_width/2, 0)].row;
            if (currentMiddleIndex >= self.dataArray.count + self.leftCount) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentMiddleIndex - self.dataArray.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }else if (currentMiddleIndex < self.leftCount) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count + currentMiddleIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
        } else {
            if ((self.collectionView.contentOffset.x >= connectionPoint.x) && connectionPoint.x != 0){
                [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        }
    }else{
        if (self.scrollStyle == SLRecycleCollectionViewStylePage) {
            NSInteger currentMiddleIndex = [self.collectionView indexPathForItemAtPoint:CGPointMake(0, self.collectionView.contentOffset.y + self.collectionView.sl_height/2)].row;
            if (currentMiddleIndex >= self.dataArray.count + self.leftCount) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentMiddleIndex - self.dataArray.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            }else if (currentMiddleIndex < self.leftCount) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow: self.dataArray.count + currentMiddleIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            }
        } else {
            if ((self.collectionView.contentOffset.y >= connectionPoint.y) && connectionPoint.y != 0){
                [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
            }
        }
    }
}

- (void)startTime {
    [self invalidateTimer];
    if (self.interval <= 0 || !self.loop) return;
    WeakSelf;
    self.timer = [SLTimer sl_timerWithTimeInterval:self.scrollStyle == SLRecycleCollectionViewStyleStep ? 1/60.0 : self.interval target:self userInfo:nil repeats:YES mode:NSRunLoopCommonModes callback:^(NSArray * _Nonnull array) {
        StrongSelf;
        if(strongSelf.scrollDirection == UICollectionViewScrollDirectionHorizontal){
            if (strongSelf.collectionView.contentSize.width < strongSelf.collectionView.sl_width) {
                [strongSelf invalidateTimer];
                return;
            }
            [strongSelf horizontalRollAnimation];
        }else{
            if (strongSelf.collectionView.contentSize.height < strongSelf.collectionView.sl_height) {
                [strongSelf invalidateTimer];
                return;
            }
            [strongSelf verticalRollAnimation];
        }
    }];
}

- (void)invalidateTimer {
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (NSInteger)indexOfSourceArray:(NSInteger)row{
    NSInteger index = 0;
    if(row < self.leftCount){
        index = self.dataArray.count - self.leftCount + row;
    }else if (row < self.dataArray.count + self.leftCount && row >= self.leftCount) {
        index = row - self.leftCount;
    }else{
        index = row % (self.dataArray.count + self.leftCount);
    }
    return index;
}

- (void)getCurrentIndex{
    if (self.scrollStyle != SLRecycleCollectionViewStylePage) return;
    NSInteger currentIndex= 0;
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        currentIndex= [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x + self.collectionView.sl_width/2, 0)].row;
    }else{
        currentIndex= [self.collectionView indexPathForItemAtPoint:CGPointMake(0,self.collectionView.contentOffset.y + self.collectionView.sl_height/2)].row;
    }
    NSInteger currentPage = [self indexOfSourceArray:currentIndex];
    if (currentPage == self.currentPage) return;
    self.currentPage = currentPage;
    self.pageControl.currentPage = currentPage;
    if (self.scrollToIndexBlock) self.scrollToIndexBlock(self.dataArray[currentPage], currentPage);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.loop) {
        [self getCurrentIndex];
        return;
    }
    if ((scrollView.contentOffset.x < 1 || scrollView.contentOffset.x > scrollView.contentSize.width - self.collectionView.sl_width - 1) && self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        [self resetContentOffset];
    }else if ((scrollView.contentOffset.y < 1 || scrollView.contentOffset.y > scrollView.contentSize.height - self.collectionView.sl_height - 1) && self.scrollDirection == UICollectionViewScrollDirectionVertical){
        [self resetContentOffset];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!self.loop) return;
    if (decelerate) return;
    [self resetContentOffset];
    [self startTime];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.loop) return;
    [self resetContentOffset];
    [self startTime];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (!self.loop) return;
    [self getCurrentIndex];
    [self resetContentOffset];
}
@end
