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
