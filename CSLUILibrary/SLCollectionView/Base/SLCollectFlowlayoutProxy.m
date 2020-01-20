//
//  SLCollectFlowlayoutProxy.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/20.
//

#import "SLCollectFlowlayoutProxy.h"
#import <CSLUILibrary/SLCollectManager.h>

@implementation SLCollectFlowlayoutProxy
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    id<SLCollectRowProtocol> row = [self.collectManager rowAtIndexPath:indexPath];
    return CGSizeMake(row.rowWidth, row.rowHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return sec.insetForSection;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return sec.minimumLineSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return sec.minimumInteritemSpacing;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return CGSizeMake(sec.widthForHeader, sec.heightForHeader);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return CGSizeMake(sec.widthForFooter, sec.heightForFooter);
}
@end
