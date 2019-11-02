//
//  SLImageView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/1.
//

#import "SLImageView.h"
#import <CSLUILibrary/SLUtil.h>

@implementation SLImageView

- (void)sl_setImage:(UIImage *)image {
    [self sl_setImage:image compressionQuality:0.5];
}

- (void)sl_setImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality{
    if (!image) return;
    NSData *jpgImageData = UIImageJPEGRepresentation(image, compressionQuality);
    [self sl_scaleImage:[UIImage imageWithData:jpgImageData]];
}

- (void)sl_scaleImage:(UIImage *)image {
    return [self sl_scaleImage:image size:image.size];
}

- (void)sl_scaleImage:(UIImage*)image size:(CGSize)imageSize{
    if (!image) return;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 1.0f);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    dispatch_async(dispatch_get_main_queue(), ^{
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds=YES;
        self.image = newImage;
    });
}

- (void)sl_setAlphaForImage:(UIImage *)image alpha:(CGFloat)alpha {
    if (!image) return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
        CGContextSetAlpha(ctx, alpha);
        CGContextDrawImage(ctx, area, image.CGImage);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self sl_setImage:newImage];
    });
}

- (void)sl_imageBlackToTransparent:(UIImage *)image {
    [self sl_imageBlackToTransparent:image weight:0.5];
}

- (void)sl_imageBlackToTransparent:(UIImage *)image weight:(CGFloat)weight {
    [self sl_imageBlackToTransparent:image red:weight blue:weight green:weight];
}

- (void)sl_imageBlackToTransparent:(UIImage *)image red:(CGFloat)redWeight blue:(CGFloat)blueWeight green:(CGFloat)greenWeight{
    if (!image) return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGImageRef imageRef = image.CGImage;
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        size_t pix = CGImageGetBitsPerComponent(imageRef);
        size_t perRowSize = CGImageGetBytesPerRow(imageRef);
        CGColorSpaceRef colorSpaceRef = CGImageGetColorSpace(imageRef);
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
        CGDataProviderRef dataProviderRef = CGImageGetDataProvider(imageRef);
        CFDataRef dataRef = CGDataProviderCopyData(dataProviderRef);
        long dataLength = CFDataGetLength(dataRef);
        UInt8 *pixBuf = CFDataGetMutableBytePtr(dataRef);
        for (int offset; offset<dataLength; offset+=4) {
            int red = pixBuf[offset] * redWeight;
            int green = pixBuf[offset + 1] * greenWeight;
            int blue = pixBuf[offset + 2] * blueWeight;
            pixBuf[offset] = red;
            pixBuf[offset + 1] = green;
            pixBuf[offset + 2] = blue;
        }
        CGContextRef context = CGBitmapContextCreate(pixBuf, width, height, pix, perRowSize, colorSpaceRef, alphaInfo);
        CGImageRef filterImageRef = CGBitmapContextCreateImage(context);
        UIImage *filterImage =  [UIImage imageWithCGImage:filterImageRef];
        [self sl_setImage:filterImage];
    });
}

- (void)setFilterType:(FilterType)filterType {
    _filterType = filterType;
    NSString *fiterName = [SLUtil fiterName:filterType];
    [self sl_filterImage:self.image filterName:fiterName];
}

- (void)sl_filterImage:(UIImage *)image filterName:(NSString *)filterName {
    if ([filterName isEqualToString:@"OriginImage"]) {
        self.image = image;
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CIImage *ciImage = [[CIImage alloc] initWithImage:image];
            CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
            [filter setDefaults];
            CIContext *context = [CIContext contextWithOptions:nil];
            CIImage *outputImage = [filter outputImage];
            CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
            UIImage *newImage = [UIImage imageWithCGImage:cgImage];
            CGImageRelease(cgImage);
            [self sl_setImage:newImage];
        });
    }
}

- (void)sl_corner:(UIImage *)image cornerRadis:(BOOL)cornerRadis {
    [self setCornerRadis:YES];
    [self sl_setImage:image];
}

- (void)sl_corner:(UIImage *)image radis:(CGFloat)cornerRadis {
    [self setRadis:cornerRadis];
    [self sl_setImage:image];
}

- (void)setCornerRadis:(BOOL)cornerRadis {
    _cornerRadis = cornerRadis;
    [self setRadis:MIN(self.bounds.size.width, self.bounds.size.height)/2.0];
}

- (void)setRadis:(CGFloat)radis {
    _radis = radis;
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = self.bounds;
    UIBezierPath *bezierPath;
    if (radis > 0) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radis];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    }
    shaperLayer.path = bezierPath.CGPath;
    self.layer.mask = shaperLayer;
}

- (void)sl_saveImageToLocal:(NSString*)fileName image:(UIImage *)image {
    if (!image) return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData* imageData =  UIImagePNGRepresentation(image);
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        filePath = [filePath stringByAppendingPathComponent:fileName];
        if ([imageData writeToFile:filePath atomically:YES]) {
            NSLog(@"图片保存成功");
        }
   });
}

@end
