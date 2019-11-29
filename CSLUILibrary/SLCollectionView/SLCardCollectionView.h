//
//  SLCardCollectionView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/29.
//

#import "SLView.h"
#import <CSLUILibrary/SLModel.h>
#import <CSLUILibrary/SLCollectionView.h>
#import <CSLUILibrary/SLCollectionViewCell.h>
#import <CSLUILibrary/SLCollectionViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SLCardCollectionViewScrollDirection) {
    Horizontal,// 横向
    Vertical,// 纵向
};
@interface SLCardCollectionView : SLView
@property(strong,nonatomic)SLCollectionView *collectionView;
@property(nonatomic,assign) UIEdgeInsets insets;// sectionInset
@property(copy,nonatomic)NSArray<SLModel *> *dataSource;
@property(weak,nonatomic)id<SLCollectionViewProtocol>delegate;
@property(nonatomic,assign)CGFloat itemMargin; // item 间距
@property(nonatomic,assign)SLCardCollectionViewScrollDirection direction; //滚动方向
@property(nonatomic,copy) void(^scrollEndBlock)(NSInteger index); // 滚动结束，当前显示中间的cell序号
- (void)reloadData;// collectionview刷新
@end

NS_ASSUME_NONNULL_END
