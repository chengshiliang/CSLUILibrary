//
//  SLRecycleCollectionView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/12.
//

#import "SLRecycleCollectionView.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLCommonLibrary/SLTimer.h>
#import <CSLUILibrary/SLPageControl.h>

static NSString *const recycleViewCellID = @"kSLRecycleViewCellID";

@interface SLRecycleCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate, UIScrollViewDelegate>
{
    BOOL needRefresh;
}
@property (strong, nonatomic) SLRecycleCollectionLayout *layout;
@property (nonatomic, strong) SLTimer * timer;
@property (nonatomic, assign) NSInteger rightCount;
@property (nonatomic, assign) NSInteger leftCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) SLPageControl *pageControl;
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
    self.layout.minimumInteritemSpacing = 0;
    self.collectionView=[[SLCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.bounces = YES;
    self.collectionView.decelerationRate = 0;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    CGSize pageControlSize = CGSizeMake(100, 15);
    if (self.pageControlSize.width > 0 && self.pageControlSize.height > 0) {
        pageControlSize = self.pageControlSize;
    }
    self.collectionView.frame = CGRectMake(self.bounds.origin.x+self.insets.left, self.bounds.origin.y+self.insets.top, self.bounds.size.width-self.insets.left-self.insets.right, self.bounds.size.height-self.insets.top-self.insets.bottom);
    self.pageControl.frame = CGRectMake((self.sl_width-pageControlSize.width)/2,self.sl_height-pageControlSize.height-self.bottomSpace-self.insets.bottom, pageControlSize.width, pageControlSize.height);
    if (needRefresh) {
        [self reloadData];
    }
}

- (void)reloadData {
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
    self.layout.minimumLineSpacing = self.minimumLineSpacing;
    self.dataArray = self.dataSource;
    if (self.scrollStyle == SLRecycleCollectionViewStyleStep) self.manual = NO;
    if (self.loop && self.dataSource.count > 0) {
        CGFloat width = 0;
        CGFloat height = 0;
        for (int i = 0; i<self.dataSource.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            CGSize size = [self collectionView:self.collectionView layout:self.layout sizeForItemAtIndexPath:indexPath];
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                width += size.width;
            } else {
                height += size.height;
            }
        }
        if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal && width >= self.collectionView.sl_width){
            self.rightCount = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.sl_width - 1, 0)].row + 1;
            if (self.scrollStyle == SLRecycleCollectionViewStylePage){
                self.leftCount = self.dataSource.count - [self.collectionView indexPathForItemAtPoint:CGPointMake(width - self.collectionView.sl_width + 1, 0)].row;
            }
        }else if(self.scrollDirection == UICollectionViewScrollDirectionVertical && height >=self.collectionView.sl_height){
            self.rightCount = [self.collectionView indexPathForItemAtPoint:CGPointMake(0, self.collectionView.sl_height - 1)].row + 1;
            if (self.scrollStyle == SLRecycleCollectionViewStylePage){
                self.leftCount = self.dataSource.count - [self.collectionView indexPathForItemAtPoint:CGPointMake(0, height - self.collectionView.sl_height + 1)].row;
            }
        }
        NSArray * rightSubArray = [self.dataSource subarrayWithRange:NSMakeRange(0, self.rightCount)];
        self.dataArray = [self.dataSource arrayByAddingObjectsFromArray:rightSubArray];
        if (self.scrollStyle == SLRecycleCollectionViewStylePage){
            NSArray * leftSubArray = [self.dataSource subarrayWithRange:NSMakeRange(self.dataSource.count - self.leftCount, self.leftCount)];
            self.dataArray = [leftSubArray arrayByAddingObjectsFromArray:self.dataArray];
        }
    }
    if(!self.manual){
        for(UIGestureRecognizer *g in self.collectionView.gestureRecognizers){
            [self.collectionView removeGestureRecognizer:g];
        }
    }
    [self.collectionView reloadData];
    if (self.scrollStyle == SLRecycleCollectionViewStylePage) {
        [self.collectionView layoutIfNeeded];
        if (self.startingPosition >= self.dataSource.count || self.startingPosition < 0) {
            self.startingPosition = 0;
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.startingPosition + self.leftCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }else{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.startingPosition + self.leftCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }
        if (self.scrollToIndexBlock) self.scrollToIndexBlock(self.dataSource[self.startingPosition], self.startingPosition);
        if (!self.hidePageControl && self.dataSource.count >= 2) {
            self.pageControl = [[SLPageControl alloc] init];
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
            self.pageControl.numberOfPages = self.dataSource.count;
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
        SLCollectionViewCell * item = (SLCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - self.rightCount inSection:0]];
        connectionPoint = [self.collectionView convertRect:item.frame toView:self.collectionView].origin;
    }
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        if (self.scrollStyle == SLRecycleCollectionViewStylePage) {
            NSInteger currentMiddleIndex = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x + self.collectionView.sl_width/2, 0)].row;
            if (currentMiddleIndex >= self.dataSource.count + self.leftCount) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentMiddleIndex - self.dataSource.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }else if (currentMiddleIndex < self.leftCount) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count + currentMiddleIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
        } else {
            if ((self.collectionView.contentOffset.x >= connectionPoint.x) && connectionPoint.x != 0){
                [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        }
    }else{
        if (self.scrollStyle == SLRecycleCollectionViewStylePage) {
            NSInteger currentMiddleIndex = [self.collectionView indexPathForItemAtPoint:CGPointMake(0, self.collectionView.contentOffset.y + self.collectionView.sl_height/2)].row;
            if (currentMiddleIndex >= self.dataSource.count + self.leftCount) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentMiddleIndex - self.dataSource.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            }else if (currentMiddleIndex < self.leftCount) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow: self.dataSource.count + currentMiddleIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
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
        index = self.dataSource.count - self.leftCount + row;
    }else if (row < self.dataSource.count + self.leftCount && row >= self.leftCount) {
        index = row - self.leftCount;
    }else{
        index = row % (self.dataSource.count + self.leftCount);
    }
    return index;
}

- (void)getCurrentIndex{
    if (self.scrollStyle == SLRecycleCollectionViewStylePage){
        NSInteger currentIndex= 0;
        if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
            currentIndex= [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x + self.collectionView.sl_width/2, 0)].row;
        }else{
            currentIndex= [self.collectionView indexPathForItemAtPoint:CGPointMake(0,self.collectionView.contentOffset.y + self.collectionView.sl_height/2)].row;
        }
        NSInteger currentPage = [self indexOfSourceArray:currentIndex];
        self.currentPage = currentPage;
        self.pageControl.currentPage = currentPage;
        if (self.scrollToIndexBlock) self.scrollToIndexBlock(self.dataSource[currentPage], currentPage);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self getCurrentIndex];
    if (!self.loop) return;
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
    [self resetContentOffset];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger i = [self indexOfSourceArray:indexPath.item];
    SLPupModel *model = self.dataSource[i];
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return CGSizeMake(model.width, self.collectionView.sl_height);
    } else {
        return CGSizeMake(self.collectionView.sl_width, model.height-self.insets.top-self.insets.bottom);
    }
}
-(NSInteger)collectionView:(SLCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customCellForItemAtIndexPath:forView:)]) {
        return [self.delegate collectionView:collectionView customCellForItemAtIndexPath:indexPath forView:self];
    }
    SLCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:recycleViewCellID forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(SLCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self indexOfSourceArray:indexPath.item];
    NSIndexPath *indexP = [NSIndexPath indexPathForItem:index inSection:indexPath.section];
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customDidSelectItemAtIndexPath:forView:)]) {
        [self.delegate collectionView:collectionView customDidSelectItemAtIndexPath:indexP forView:self];
    }
}

@end
