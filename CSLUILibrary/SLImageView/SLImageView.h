//
//  SLImageView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLImageView : UIImageView
// 倒圆角
@property (nonatomic, assign) BOOL cornerRadis;
// 倒角
@property (nonatomic, assign) CGFloat radis;

- (void)sl_setImage:(UIImage *)image;
/*
 *compressionQuality: 图片质量压缩值:0 ~ 1之间，默认0.5
 */
- (void)sl_setImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality;
// 缩放图片为imageview区域大小
- (void)sl_scaleImage:(UIImage*)image;
// 缩放图片到指定大小
- (void)sl_scaleImage:(UIImage*)image size:(CGSize)imageSize;
/*设置高斯模糊效果
 *alpha: alpha:0 ~ 1之间, alpha 越大，效果越明显
 */
- (void)sl_setAlphaForImage:(UIImage *)image alpha:(CGFloat)alpha;

// 设置图片每个bitmap的权重比：0.5
- (void)sl_imageBlackToTransparent:(UIImage*)image;
/*
 *weight: 每个bitmap的颜色值的权重比:0 ~ 1之间，默认0.5，在原油bitmap的基础上进行弱化
 */
- (void)sl_imageBlackToTransparent:(UIImage*)image weight:(CGFloat)weight;
/*
 *redWeight: 每个bitmap的red的权重比:0 ~ 1之间，默认0.5，在原油bitmap的基础上进行弱化
 *blueWeight: 每个bitmap的blue的权重比:0 ~ 1之间，默认0.5，在原油bitmap的基础上进行弱化
 *greenWeight: 每个bitmap的blue的权重比:0 ~ 1之间，默认0.5，在原油bitmap的基础上进行弱化
 */
- (void)sl_imageBlackToTransparent:(UIImage*)image red:(CGFloat)redWeight blue:(CGFloat)blueWeight green:(CGFloat)greenWeight;
// 保存图片数据到本地
- (void)sl_saveImageToLocal:(NSString*)fileName image:(UIImage *)image;
/**
 解码图片
 */
- (void)decodeImage:(UIImage *)image toSize:(CGSize)size;
+ (UIImage *)decodeImage:(UIImage *)image toSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
