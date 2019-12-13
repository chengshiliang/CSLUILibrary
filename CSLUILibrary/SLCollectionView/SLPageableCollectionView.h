//
//  SLPageableCollectionView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/13.
//

#import "SLView.h"
#import <CSLUILibrary/SLRecycleCollectionView.h>
#import <CSLUILibrary/SLStaticCollectionView.h>
#import <CSLUILibrary/SLCollectionViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPageableCollectionView : SLView
@property (nonatomic, copy) NSArray<NSArray<SLPupModel *> *> *dataSource;
@property (nonatomic, assign) UIEdgeInsets insets;// 每页的insets
@property (assign, nonatomic) int columns;
@property (assign, nonatomic) float columnMagrin;
@property (assign, nonatomic) float rowMagrin;
@property (copy, nonatomic) SLCollectionViewCell *(^cellConfig)(NSInteger section,NSInteger row, SLCollectionViewCell *cell);
@property (nonatomic, assign) float bottomSpace;// page分页器和底部距离
- (void)reload;
@end

NS_ASSUME_NONNULL_END
