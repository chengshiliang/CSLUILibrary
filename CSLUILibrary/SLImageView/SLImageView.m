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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        [image drawInRect:rect blendMode:kCGBlendModeMultiply alpha:alpha];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self sl_setImage:newImage];
    });
}

- (void)sl_imageBlackToTransparent:(UIImage *)image {
    return [self sl_imageBlackToTransparent:image weight:0.5];
}

- (void)sl_imageBlackToTransparent:(UIImage *)image weight:(CGFloat)weight {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGRect imageRect = CGRectMake(0, 0, image.size.width*image.scale, image.size.height*image.scale);
        int width = imageRect.size.width;
        int height = imageRect.size.height;
        uint32_t *pixels = (uint32_t*) malloc(width * height *sizeof(uint32_t));
        memset(pixels,0, width * height *sizeof(uint32_t));
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(pixels, width, height,8, width *sizeof(uint32_t), colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(context,CGRectMake(0,0, width, height), [image CGImage]);
        const int RED = 1;
        const int GREEN = 2;
        const int BLUE = 3;
        for(int y = 0; y < height; y++) {
            for(int x = 0; x < width; x++) {
                uint8_t *rgbaPixel = (uint8_t*) &pixels[y * width + x];
                uint32_t gray = weight * rgbaPixel[RED] +weight * rgbaPixel[GREEN] +weight * rgbaPixel[BLUE];
                rgbaPixel[RED] = gray;
                rgbaPixel[GREEN] = gray;
                rgbaPixel[BLUE] = gray;
            }
        }
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        free(pixels);
        UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        [self sl_setImage:newImage];
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
