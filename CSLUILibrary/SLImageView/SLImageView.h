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
- (void)sl_setAlphaForImage:(UIImage*)image alpha:(CGFloat)alpha;
- (void)sl_imageBlackToTransparent:(UIImage*)image;
/*
 *weight: 权重比:0 ~ 1之间，默认0.5
 */
- (void)sl_imageBlackToTransparent:(UIImage*)image weight:(CGFloat)weight;
/* 创建滤镜图片
 * filterName: 滤镜效果名称 可参考官网的名称类型
 */
- (void)sl_filterImage:(UIImage *)image filterName:(NSString *)filterName;
// 保存图片数据到本地
- (void)sl_saveImageToLocal:(NSString*)fileName image:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
