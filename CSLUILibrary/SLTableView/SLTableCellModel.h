//
//  SLTableCellModel.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/12/2.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLTableCellProtocol.h>
#import <CSLUILibrary/SLTableModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLTableCellTitleModel <NSObject>
@end

@interface SLTableCellTitleModel : NSObject
@property (nonatomic, assign) CGFloat width;// 文本宽度，默认为屏幕宽度
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIFont *font;// 默认system 14
@property (nonatomic, strong) UIColor *color;// 默认 0x666666
@end

@protocol SLTableCellModel  <NSObject>
@end

@interface SLTableCellModel : SLTableRowModel<SLTableCellProtocol>
@property (nonatomic, assign) UIEdgeInsets contentEdgeInset;
@property (nonatomic, assign) CGSize leftCustomViewSize;// cell左边视图大小（包括图片和自定义view）
@property (nonatomic, assign) CGFloat rowSpaceLeftItem;// cell左边文字和图片（自定义视图）间距
@property (nonatomic, assign) CGFloat columnSpaceLeftItem;// cell左边文字之间的间距
@property (nonatomic, assign) CGSize rightCustomViewSize;// cell右边视图大小（包括图片和自定义view）
@property (nonatomic, assign) CGFloat rowSpaceRightItem;// cell右边文字和图片（自定义视图）间距
@property (nonatomic, assign) CGFloat columnSpaceRightItem;// cell右边文字之间的间距
@property (nonatomic, assign) CGFloat rowSpaceLeftAndMiddleItem;// cell左边和中间之间的间距
@property (nonatomic, assign) CGFloat rowSpaceMiddleAndRightItem;// cell右边和中间之间的间距
@property (nonatomic, assign) BOOL isLeftForMiddleView;
@property (nonatomic, assign) BOOL isLeftImageLocal;// 是否为本地图片地址
@property (nonatomic, assign) BOOL isRightImageLocal;// 是否为本地图片地址
@property (nonatomic, copy) NSString *leftImageUrl;
@property (nonatomic, copy) NSString *rightImageUrl;
@property (nonatomic, copy) NSArray<SLTableCellTitleModel *> *leftTitleModels;
@property (nonatomic, copy) NSArray<SLTableCellTitleModel *> *rightTitleModels;
@property (nonatomic, strong) UIView *customLeftView;
@property (nonatomic, strong) UIView *customRightView;
@property (nonatomic, strong) UIView *customMiddleView;
@property (nonatomic, assign) BOOL isHiddenForBottomLineView;
@property (nonatomic, strong) UIView *customBottomLineView;
@end



NS_ASSUME_NONNULL_END
