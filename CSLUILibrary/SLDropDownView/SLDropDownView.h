//
//  SLDropDownView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/17.
//

#import "SLView.h"
#import <CSLUILibrary/SLCollectSectionProtocol.h>
#import <CSLUILibrary/SLTableSectionProtocol.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SLDropDownViewDisplayType) {
    SLDropDownViewDisplayTable,// 通过tableview展示
    SLDropDownViewDisplayCollect// 通过collectionview展示
};

@interface SLDropDownView : SLView
@property (nonatomic, assign) CGFloat spaceVertical; // dropDown 和指定视图或者指定位置之间的距离
@property (nonatomic, assign) UIEdgeInsets contentInset; // 内容内边距
@property (assign,nonatomic) int columns;//collectview 列数 默认1列
@property (assign,nonatomic) float columnMagrin;//collectview 列距离
@property (assign,nonatomic) float rowMagrin;//collectview 行距离
@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, assign) SLDropDownViewDisplayType type;
@property (nonatomic, copy) NSArray <id<SLCollectSectionProtocol>>* collectDatas;// collectionView展示数据源
@property (nonatomic, copy) NSArray <id<SLTableSectionProtocol>> *tableDatas;// table展示数据源
@property (nonatomic, copy) void(^displayTableCell)(SLTableView * _Nonnull tableView, UITableViewCell * _Nonnull cell, NSIndexPath *indexPath, id<SLTableRowProtocol>  _Nonnull rowModel);
@property (nonatomic, copy) void(^displayCollectCell)(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel);

- (void)showToView:(UIView *)pointView targetView:(UIView *)targetView completeBlock:(void(^)(void))completeBlock;

- (void)showToPoint:(CGPoint)toPoint targetView:(UIView *)targetView completeBlock:(void(^)(void))completeBlock;

- (void)hide;
@end

NS_ASSUME_NONNULL_END
