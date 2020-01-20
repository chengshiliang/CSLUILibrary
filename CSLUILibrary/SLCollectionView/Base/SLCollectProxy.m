//
//  SLCollectProxy.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import "SLCollectProxy.h"
#import <CSLUILibrary/SLCollectManager.h>
#import <CSLUILibrary/SLCollectRowRenderProtocol.h>
#import <CSLUILibrary/NSString+Util.h>

@implementation SLCollectProxy

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.collectManager.sections[section].rows.count;
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<SLCollectRowProtocol> row = [self.collectManager rowAtIndexPath:indexPath];
    UICollectionViewCell *cell = row.cellForRowBlock(collectionView, indexPath);
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.collectManager.sections.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader) {
        return (sec.viewForHeader ? sec.viewForHeader(collectionView, indexPath.section) : nil);
    } else {
        return (sec.viewForFooter ? sec.viewForFooter(collectionView, indexPath.section) : nil);
    }
}
- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (id<SLCollectSectionProtocol> sec in self.collectManager.sections) {
        if ([NSString emptyString:sec.sectionIndexTitle]) continue;
        [arrayM addObject:sec.sectionIndexTitle];
    }
    return arrayM.copy;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return self.collectManager.sections[index].titleForHeader;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    id<SLCollectRowProtocol> rowModel = [self.collectManager rowAtIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (rowModel) {
        !self.collectManager.selectCollectView?:self.collectManager.selectCollectView(collectionView, cell, indexPath, rowModel);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id<SLCollectRowProtocol> rowModel = [self.collectManager rowAtIndexPath:indexPath];
    if (rowModel) {
        if ([cell respondsToSelector:@selector(renderWithRowModel:)]) {
            [cell performSelector:@selector(renderWithRowModel:) withObject:rowModel];
        } else {
            !self.collectManager.displayCell?:self.collectManager.displayCell(collectionView,cell,indexPath,rowModel);
        }
    }
}
@end

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

@implementation SLCollectScrollProxy
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    !self.collectManager.scrollViewDidEndDeceleratingCallback?:self.collectManager.scrollViewDidEndDeceleratingCallback(scrollView);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    !self.collectManager.scrollViewDidScrollCallback?:self.collectManager.scrollViewDidScrollCallback(scrollView);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    !self.collectManager.scrollViewWillBeginDraggingCallback?:self.collectManager.scrollViewWillBeginDraggingCallback(scrollView);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    !self.collectManager.scrollViewDidEndDraggingCallback?:self.collectManager.scrollViewDidEndDraggingCallback(scrollView, decelerate);
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    !self.collectManager.scrollViewDidEndScrollingAnimationCallback?:self.collectManager.scrollViewDidEndScrollingAnimationCallback(scrollView);
}
@end
@implementation SLCollectRecycleProxy
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
