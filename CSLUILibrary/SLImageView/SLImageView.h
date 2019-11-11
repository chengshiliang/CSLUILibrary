//
//  SLImageView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FilterType) {
    OriginImage,
    CIPhotoEffectMono,
    CIPhotoEffectChrome,
    CIPhotoEffectFade,
    CIPhotoEffectInstant,
    CIPhotoEffectNoir,
    CIPhotoEffectProcess,
    CIPhotoEffectTonal,
    CIPhotoEffectTransfer,
    CISRGBToneCurveToLinear,
    CIVignetteEffect
};

@interface SLImageView : UIImageView
// 滤镜类型
@property (nonatomic, assign) FilterType filterType;
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
/*设置图片透明度
 *alpha: alpha:0 ~ 1之间
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
/* 创建滤镜图片
 * filterName: 滤镜效果名称 可参考官网的名称类型
 */
- (void)sl_filterImage:(UIImage *)image filterName:(NSString *)filterName;
// 给图片设置倒圆角
- (void)sl_corner:(UIImage *)image cornerRadis:(BOOL)cornerRadis;
// 自定义图片倒角
- (void)sl_corner:(UIImage *)image radis:(CGFloat)cornerRadis;
// 保存图片数据到本地
- (void)sl_saveImageToLocal:(NSString*)fileName image:(UIImage *)image;
- (void)decodeImage:(UIImage *)image toSize:(CGSize)size;
/**
 解码图片
 */
+ (UIImage *)decodeImage:(UIImage *)image toSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
