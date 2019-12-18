//
//  SLTableCellProtocol.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/12/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLTableCellProtocol <NSObject>
@optional

- (UIEdgeInsets)contentInset;
- (UIImageView *)leftImage;// cell左边图片
- (CGSize)leftViewSize;// cell左边视图大小（包括图片和自定义view）
- (float)spaceBetweenImageAndTitleAtLeftItem;// cell左边文字和图片（自定义视图）间距 (leftImage\leftView 返回非空)才调用
- (NSArray<UILabel *> *)leftTitles;// cell左边标题集合
- (float)spaceTitlesAtLeftItem;// cell左边文字间距 numberRowsAtRightItem 大于1的时候才调用
- (UIView *)leftView;// 自定义cell左边视图
- (UIView *)middleView;// 自定义cell中间部分的视图
- (BOOL)middleViewAtLeft;// 中间部分视图显示靠左还是靠右，返回yes，代表靠左，返回no靠右
- (float)spaceBetweenMiddleItemAndLeftItem;// cell左边和中间部分视图的间距
- (float)spaceBetweenMiddleItemAndRightItem;// cell左边和中间部分视图的间距
- (UIImageView *)rightImage;// cell右边图片
- (CGSize)rightViewSize;// cell右边视图大小（包括图片和自定义view）
- (float)spaceBetweenImageAndTitleAtRightItem;// cell右边文字和图片（自定义视图）间距 (rightImage\leftView 返回非空)才调用
- (NSArray<UILabel *> *)rightTitles;// cell右边标题集合
- (float)spaceTitlesAtRightItem;// cell右边文字间距 numberRowsAtRightItem 大于1的时候才调用
- (UIView *)rightView;// 自定义cell左边视图
- (BOOL)bottomLineViewHidden;// 底部线条是否隐藏
- (UIView *)bottomLineView;// 底部线条视图

@end

NS_ASSUME_NONNULL_END
