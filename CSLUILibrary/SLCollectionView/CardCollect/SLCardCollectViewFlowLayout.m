//
//  SLCardCollectViewFlowLayout.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/29.
//

#import "SLCardCollectViewFlowLayout.h"
#import <CSLUtils/UIView+SLBase.h>

@interface SLCardCollectViewFlowLayout()
{
    NSInteger index;
}
@end
@implementation SLCardCollectViewFlowLayout
- (instancetype)init {
    if (self == [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

-(void)prepareLayout{
    [super prepareLayout];
    self.itemSize = CGSizeMake(self.collectionView.sl_width - self.sectionInset.left - self.sectionInset.right, self.collectionView.sl_height - self.sectionInset.top - self.sectionInset.bottom);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * original = [super layoutAttributesForElementsInRect:rect];
    NSArray * attsArray = [[NSArray alloc] initWithArray:original copyItems:YES];
    //collectionView中心点的值
    //屏幕中心点对应于collectionView中content位置
    CGFloat centerXY = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        centerXY = self.collectionView.sl_width / 2 + self.collectionView.contentOffset.x;
    } else {
        centerXY = self.collectionView.sl_height / 2 + self.collectionView.contentOffset.y;
    }
    //cell中的item一个个取出来进行更改
    for (UICollectionViewLayoutAttributes *atts in attsArray) {
        // cell的中心点x 和 collectionView中心点 的距离
        CGFloat space = 0;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            space = ABS(atts.center.x - centerXY);
        } else {
            space = ABS(atts.center.y - centerXY);
        }
        CGFloat scale = 1;
        CGFloat count = self.data.count > 0 ? self.data.count > 0 : 1;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            scale = 1 - (space/self.collectionView.sl_width/count);
        } else {
            scale = 1 - (space/self.collectionView.sl_height/count);
        }
        atts.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return attsArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 计算出最终显示的矩形框
    CGRect rect;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        rect.origin.y = 0;
        rect.origin.x = proposedContentOffset.x;//最终要停下来的X
    } else {
        rect.origin.y = proposedContentOffset.y;//最终要停下来的Y
        rect.origin.x = 0;
    }
    rect.size = self.collectionView.frame.size;
    
    NSArray * original = [super layoutAttributesForElementsInRect:rect];
    NSArray * attsArray = [[NSArray alloc] initWithArray:original copyItems:YES];
    //计算collection中心点X
    //视图中心点相对于collectionView的content起始点的位置
    CGFloat centerXY = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        centerXY = self.collectionView.sl_width / 2 + proposedContentOffset.x;
    } else {
        centerXY = self.collectionView.sl_height / 2 + proposedContentOffset.y;
    }
    CGFloat minSpace = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in attsArray) {
        //找到距离视图中心点最近的cell，并将minSpace值置为两者之间的距离
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            if (ABS(minSpace) > ABS(attrs.center.x - centerXY)) {
                minSpace = attrs.center.x - centerXY;        //各个不同的cell与显示中心点的距离
            }
        } else {
            if (ABS(minSpace) > ABS(attrs.center.y - centerXY)) {
                minSpace = attrs.center.y - centerXY;        //各个不同的cell与显示中心点的距离
            }
        }
    }
    // 修改原有的偏移量
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        proposedContentOffset.x += minSpace;
    } else {
        proposedContentOffset.y += minSpace;
    }
    return proposedContentOffset;
}
@end
