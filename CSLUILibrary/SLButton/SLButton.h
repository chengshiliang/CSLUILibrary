//
//  SLButton.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLButton : UIButton
/**
 给按钮增加倒角和边框
 */
- (void)addCornerRadius:(CGFloat)cornerRadius
    borderWidth:(CGFloat)borderWidth
    borderColor:(UIColor *)borderColor
backGroundColor:(UIColor *)backColor;
@end

NS_ASSUME_NONNULL_END
