//
//  SLTabbarButton.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SLTabbarButtonType) {
    SLButtonTypeOnlyTitle = 4,  // 仅文字
    SLButtonTypeOnlyImage = 5,  // 仅图片
    SLButtonTypeLeft   = 1,     // 图片在文字左侧
    SLButtonTypeRight  = 2,     // 图片在文字右侧
    SLButtonTypeTop    = 0,     // 图片在文字上侧
    SLButtonTypeBottom = 3      // 图片在文字下侧
};
@interface SLTabbarButton : UIButton
@property (nonatomic, assign) SLTabbarButtonType buttonType;
// 图片和文字之间的间距
@property (nonatomic, assign) CGFloat imageTitleSpace;
// 图片区域的大小，默认为图片的大小
@property (nonatomic, assign) CGSize imageSize;

- (void)show;
@end

NS_ASSUME_NONNULL_END
