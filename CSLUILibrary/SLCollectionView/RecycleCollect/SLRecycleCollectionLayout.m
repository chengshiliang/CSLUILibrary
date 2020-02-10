//
//  SLRecycleCollectionLayout.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/12.
//

#import "SLRecycleCollectionLayout.h"
#import <CSLUtils/UIView+SLBase.h>

@interface SLRecycleCollectionLayout()
@end

@implementation SLRecycleCollectionLayout
- (void)prepareLayout {
    [super prepareLayout];
}
- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return NO;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    if (self.scrollStyle == SLRecycleCollectionViewStylePage) {
        CGRect rect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.sl_width, self.collectionView.sl_height);
        NSArray *array = [super layoutAttributesForElementsInRect:rect];
        CGFloat minDetal = MAXFLOAT;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
            CGFloat centerX = proposedContentOffset.x + self.collectionView.sl_width * 0.5;
            for (UICollectionViewLayoutAttributes *attrs in array){
                if (ABS(minDetal) > ABS(centerX - attrs.center.x)){
                    minDetal = attrs.center.x - centerX;
                }
            }
            return CGPointMake(proposedContentOffset.x + minDetal, proposedContentOffset.y);
        }else{
            CGFloat centerY = proposedContentOffset.y + self.collectionView.sl_height * 0.5;
            for (UICollectionViewLayoutAttributes *attrs in array){
                if (ABS(minDetal) > ABS(centerY - attrs.center.y)){
                    minDetal = attrs.center.y - centerY;
                }
            }
            return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + minDetal);
        }
    }
    return proposedContentOffset;
}
@end
