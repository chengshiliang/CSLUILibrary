//
//  SLCollectProxy.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import "SLCollectProxy.h"
#import <CSLUILibrary/SLCollectManager.h>
#import <CSLUILibrary/SLCollectRowRenderProtocol.h>
#import <CSLUtils/NSString+Util.h>
#import <CSLUILibrary/SLCollectBaseView.h>

@implementation SLCollectProxy

- (NSInteger)collectionView:(SLCollectBaseView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.collectManager.sections[section].rows.count;
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(SLCollectBaseView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<SLCollectRowProtocol> row = [self.collectManager rowAtIndexPath:indexPath];
    UICollectionViewCell *cell = row.cellForRowBlock(collectionView, indexPath);
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(SLCollectBaseView *)collectionView {
    return self.collectManager.sections.count;
}

- (UICollectionReusableView *)collectionView:(SLCollectBaseView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader) {
        return (sec.viewForHeader ? sec.viewForHeader(collectionView, indexPath) : nil);
    } else {
        return (sec.viewForFooter ? sec.viewForFooter(collectionView, indexPath) : nil);
    }
}
- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(SLCollectBaseView *)collectionView {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (id<SLCollectSectionProtocol> sec in self.collectManager.sections) {
        if ([NSString emptyString:sec.sectionIndexTitle]) continue;
        [arrayM addObject:sec.sectionIndexTitle];
    }
    return arrayM.copy;
}

- (void)collectionView:(SLCollectBaseView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    id<SLCollectRowProtocol> rowModel = [self.collectManager rowAtIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (rowModel) {
        !self.collectManager.selectCollectView?:self.collectManager.selectCollectView(collectionView, cell, indexPath, rowModel);
    }
}

- (void)collectionView:(SLCollectBaseView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id<SLCollectRowProtocol> rowModel = [self.collectManager rowAtIndexPath:indexPath];
    if (rowModel) {
        if ([cell respondsToSelector:@selector(renderWithRowModel:)]) {
            [cell performSelector:@selector(renderWithRowModel:) withObject:rowModel];
        } else {
            !self.collectManager.displayCell?:self.collectManager.displayCell(collectionView,cell,indexPath,rowModel);
        }
    }
}

- (void)collectionView:(SLCollectBaseView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[indexPath.section];
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (sec) {
            if ([view respondsToSelector:@selector(renderHeaderWithSectionModel:)]) {
                [view performSelector:@selector(renderHeaderWithSectionModel:) withObject:sec];
            } else {
                !self.collectManager.displayHeader?:self.collectManager.displayHeader(collectionView,view,indexPath.section,sec);
            }
        }
    } else {
        if (sec) {
            if ([view respondsToSelector:@selector(renderFooterWithSectionModel:)]) {
                [view performSelector:@selector(renderFooterWithSectionModel:) withObject:sec];
            } else {
                !self.collectManager.displayFooter?:self.collectManager.displayFooter(collectionView,view,indexPath.section,sec);
            }
        }
    }
}
@end

@implementation SLCollectFlowlayoutProxy
-(CGSize)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    id<SLCollectRowProtocol> row = [self.collectManager rowAtIndexPath:indexPath];
    return CGSizeMake(row.rowWidth, row.rowHeight);
}

- (UIEdgeInsets)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return sec.insetForSection;
}
- (CGFloat)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return sec.minimumLineSpacing;
}
- (CGFloat)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return sec.minimumInteritemSpacing;
}
- (CGSize)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return CGSizeMake(sec.widthForHeader, sec.heightForHeader);
}
- (CGSize)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return CGSizeMake(sec.widthForFooter, sec.heightForFooter);
}
@end

@implementation SLCollectScrollProxy
- (void)scrollViewDidEndDecelerating:(SLCollectBaseView *)scrollView {
    !self.collectManager.scrollViewDidEndDeceleratingCallback?:self.collectManager.scrollViewDidEndDeceleratingCallback(scrollView);
}
- (void)scrollViewDidScroll:(SLCollectBaseView *)scrollView{
    !self.collectManager.scrollViewDidScrollCallback?:self.collectManager.scrollViewDidScrollCallback(scrollView);
}

- (void)scrollViewWillBeginDragging:(SLCollectBaseView *)scrollView{
    !self.collectManager.scrollViewWillBeginDraggingCallback?:self.collectManager.scrollViewWillBeginDraggingCallback(scrollView);
}

- (void)scrollViewDidEndDragging:(SLCollectBaseView *)scrollView willDecelerate:(BOOL)decelerate{
    !self.collectManager.scrollViewDidEndDraggingCallback?:self.collectManager.scrollViewDidEndDraggingCallback(scrollView, decelerate);
}
- (void)scrollViewDidEndScrollingAnimation:(SLCollectBaseView *)scrollView {
    !self.collectManager.scrollViewDidEndScrollingAnimationCallback?:self.collectManager.scrollViewDidEndScrollingAnimationCallback(scrollView);
}
@end
@implementation SLCollectRecycleProxy
-(CGSize)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    id<SLCollectRowProtocol> row = [self.collectManager rowAtIndexPath:indexPath];
    return CGSizeMake(row.rowWidth, row.rowHeight);
}

- (UIEdgeInsets)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return sec.insetForSection;
}
- (CGFloat)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return sec.minimumLineSpacing;
}
- (CGFloat)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return sec.minimumInteritemSpacing;
}
- (CGSize)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return CGSizeMake(sec.widthForHeader, sec.heightForHeader);
}
- (CGSize)collectionView:(SLCollectBaseView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    id<SLCollectSectionProtocol> sec = self.collectManager.sections[section];
    return CGSizeMake(sec.widthForFooter, sec.heightForFooter);
}
@end
