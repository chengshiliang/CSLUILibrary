//
//  SLTabbarButton.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SLButtonImagePosition) {
    SLButtonImagePositionLeft   = 1,     // 图片在文字左侧
    SLButtonImagePositionRight  = 2,     // 图片在文字右侧
    SLButtonImagePositionTop    = 0,     // 图片在文字上侧
    SLButtonImagePositionBottom = 3      // 图片在文字下侧
};
@interface SLTabbarButton : UIButton
// Button 的样式 默认为 SLButtonImagePositionTop
@property (nonatomic) SLButtonImagePosition imagePosition;
// 图片和文字之间的间距
@property (nonatomic, assign) CGFloat imageTitleSpace;
// 图片区域的大小，默认为图片的大小
@property (nonatomic, assign) CGSize imageSize;

//快捷UIButton normal 状态下属性的快捷访问属性，实质上就是 set/get 方法
@property (nonatomic, copy) UIFont *font;
@property (nonatomic, copy) UIColor *titleColor;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showTitle;
@end

NS_ASSUME_NONNULL_END
