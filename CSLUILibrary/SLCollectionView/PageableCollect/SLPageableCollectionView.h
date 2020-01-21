//
//  SLPageableCollectionView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/13.
//

#import "SLView.h"
#import <CSLUILibrary/SLCollectSectionProtocol.h>
#import <CSLUILibrary/SLCollectModel.h>
#import <CSLUILibrary/SLCollectViewBaseCell.h>
#import <CSLUILibrary/SLStaticCollectionView.h>

NS_ASSUME_NONNULL_BEGIN
@interface SLPageableCollectSectionModel : SLCollectSectionModel

@end
@interface SLPageableCollectRowModel : SLCollectRowModel
@property (nonatomic, strong) id<SLCollectSectionProtocol> rowModel;
@end
@interface SLPageableCollectionCell : SLCollectViewBaseCell
@property (nonatomic, strong) SLStaticCollectionView *staticCollectView;
@end
@interface SLPageableCollectionView : SLView
@property (strong,nonatomic) SLPageableCollectSectionModel *dataSource;
@property (assign, nonatomic) int columns;
@property (nonatomic, strong) UIImage *currentIndicatorImage;
@property (nonatomic, strong) UIImage *indicatorImage;
@property (nonatomic, strong) UIColor *currentIndicatorColor;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (assign, nonatomic) CGSize pageControlSize; // pagecontrol大小
@property (nonatomic, assign) float bottomSpace;// page分页器和底部距离
@property (nonatomic,copy) void(^scrollToIndexBlock)(id<SLCollectRowProtocol>model, NSInteger index);
@property (nonatomic, copy) void(^displaySubCollectCell)(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel);
@property (nonatomic, copy) void(^selectSubCollectView)(SLCollectBaseView *collectView, UICollectionViewCell *cell, NSIndexPath *indexPath, id<SLCollectRowProtocol>rowModel);
- (void)reload;
@end

NS_ASSUME_NONNULL_END
