//
//  SLTabbarButton.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SLTabbarButtonType) {
    SLButtonTypeOnlyImage,  // 仅图片
    SLButtonTypeOnlyTitle,  // 仅文字
    SLButtonTypeLeft,       // 图片在文字左侧
    SLButtonTypeRight,      // 图片在文字右侧
    SLButtonTypeTop,        // 图片在文字上侧
    SLButtonTypeBottom      // 图片在文字下侧
};
@interface SLTabbarButton : UIButton
@property (nonatomic, assign) SLTabbarButtonType buttonTypes;
// 图片和文字之间的间距
@property (nonatomic, assign) CGFloat imageTitleSpace;
// 图片区域的大小，默认为图片的大小
@property (nonatomic, assign) CGSize imageSize;

- (void)show;
@end

NS_ASSUME_NONNULL_END
