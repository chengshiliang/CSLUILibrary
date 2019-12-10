//
//  UIView+SLBase.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EffectStyle) {
    EffectStyleDefault,
    EffectStyleBlack,
    EffectStyleTranslucent
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SLBase)
@property (nonatomic, assign) CGFloat sl_height;
@property (nonatomic, assign) CGFloat sl_width;

@property (nonatomic, assign) CGFloat sl_y;
@property (nonatomic, assign) CGFloat sl_x;

// 设置图片的毛玻璃效果
- (void)sl_blurEffect;
- (void)sl_blurEffectWithSyle:(EffectStyle)style;
- (void)sl_blurEffect:(CGRect)rect;
- (void)sl_blurEffect:(CGRect)rect style:(EffectStyle)style;

- (void)addLoadingWithFillColor:(UIColor *_Nullable)fillColor
                    strokeColor:(UIColor *_Nullable)strokeColor
                   loadingColor:(UIColor *_Nullable)loadingColor
                      lineWidth:(CGFloat)lineWidth;

- (void)addCornerRadius:(CGFloat)cornerRadius
            shadowColor:(UIColor *)shadowColor
           shadowOffset:(CGSize)shadowOffset
          shadowOpacity:(CGFloat)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius;

/**
 给view增加倒角和边框,会覆盖原有的内容
 */
- (void)addCornerRadius:(CGFloat)cornerRadius
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor * _Nullable)borderColor
        backGroundColor:(UIColor * _Nullable)backColor;
/**
给view增加倒角和边框,不会覆盖原有的内容
*/
- (void)addCorner:(BOOL)corner;

- (void)addCornerRadius:(CGFloat)cornerRadius;
// 拷贝一个view
+ (UIView *)copyView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
