//
//  SLImageView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/1.
//

#import "SLImageView.h"
#import <CSLCommonLibrary/SLUtil.h>
#import <Accelerate/Accelerate.h>
#import <CSLCommonLibrary/UIImage+SLBase.h>

@interface SLImageView()
{
    dispatch_queue_t imageViewQueue;
}
@end

@implementation SLImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    imageViewQueue = dispatch_queue_create("com.csl.imageViewQueue", DISPATCH_QUEUE_CONCURRENT);
}

- (void)sl_setImage:(UIImage *)image {
    if (!image) return;
    dispatch_async(imageViewQueue, ^{
        CGImageRef imageRef = image.CGImage;
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }

        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;

        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGImageRef newImage = CGBitmapContextCreateImage(context);// 创建一张新的解压缩后的位图
        CFRelease(context);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = [UIImage imageWithCGImage:newImage];
        });
    });
}

- (void)sl_setImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality{
    if (!image) return;
    NSData *jpgImageData = UIImageJPEGRepresentation(image, compressionQuality);
    UIImage *result = [UIImage imageWithData:jpgImageData];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds=YES;
        self.image = result;
    });
}

- (void)sl_scaleImage:(UIImage *)image {
    return [self sl_scaleImage:image size:image.size];
}

- (void)sl_scaleImage:(UIImage*)image size:(CGSize)imageSize{
    if (!image) return;
    dispatch_async(imageViewQueue, ^{
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 1.0f);
        [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentMode = UIViewContentModeScaleAspectFill;
            self.clipsToBounds=YES;
            self.image = newImage;
        });
    });
}

- (void)sl_setAlphaForImage:(UIImage *)image alpha:(CGFloat)alpha {
    if (!image) return;
    if (alpha < 0.0 || alpha > 1.0) {
        alpha = 0.5;
    }
    dispatch_async(imageViewQueue, ^{
        int boxSize = (int)(alpha * 100);
        boxSize = boxSize - (boxSize % 2) + 1;
        CGImageRef img = image.CGImage;
        vImage_Buffer inBuffer, outBuffer;
        vImage_Error error;
        void *pixelBuffer;
        CGDataProviderRef inProvider = CGImageGetDataProvider(img);
        CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
        inBuffer.width = CGImageGetWidth(img);
        inBuffer.height = CGImageGetHeight(img);
        inBuffer.rowBytes = CGImageGetBytesPerRow(img);
        inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
        pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
        if(pixelBuffer == NULL) {
            NSLog(@"No pixelbuffer");
            return;
        }
        outBuffer.data = pixelBuffer;
        outBuffer.width = CGImageGetWidth(img);
        outBuffer.height = CGImageGetHeight(img);
        outBuffer.rowBytes = CGImageGetBytesPerRow(img);
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        if (error) {
            NSLog(@"error from convolution %ld", error);
            return;
        }
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
        CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
        UIImage *newImage = [UIImage imageWithCGImage:imageRef];
        CFRelease(inBitmapData);
        free(pixelBuffer);
        CGColorSpaceRelease(colorSpace);
        CGImageRelease(imageRef);
        CGContextRelease(ctx);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = newImage;
        });
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
    dispatch_async(imageViewQueue, ^{
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
        UInt8 *pixBuf = (UInt8 *)CFDataGetBytePtr(dataRef);
        for (int offset = 0; offset<dataLength; offset+=4) {
            @autoreleasepool{
                int red = pixBuf[offset] * redWeight;
                int green = pixBuf[offset + 1] * greenWeight;
                int blue = pixBuf[offset + 2] * blueWeight;
                pixBuf[offset] = red;
                pixBuf[offset + 1] = green;
                pixBuf[offset + 2] = blue;
            }
        }
        CGContextRef context = CGBitmapContextCreate(pixBuf, width, height, pix, perRowSize, colorSpaceRef, alphaInfo);
        CGImageRef newImageRef = CGBitmapContextCreateImage(context);
        UIImage *newImage =  [UIImage imageWithCGImage:newImageRef];
        CFRelease(dataRef);
        CGImageRelease(newImageRef);
        CGColorSpaceRelease(colorSpaceRef);
        CGContextRelease(context);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = newImage;
        });
    });
}

- (void)sl_saveImageToLocal:(NSString*)fileName image:(UIImage *)image {
    if (!image) return;
    dispatch_async(imageViewQueue, ^{
        NSData* imageData =  UIImagePNGRepresentation(image);
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        filePath = [filePath stringByAppendingPathComponent:fileName];
        if ([imageData writeToFile:filePath atomically:YES]) {}
   });
}

- (void)decodeImage:(UIImage *)image toSize:(CGSize)size {
    self.image = [UIImage decodeImage:image toSize:size];
}

@end
