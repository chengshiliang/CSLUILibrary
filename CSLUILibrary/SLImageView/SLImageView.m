//
//  SLImageView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/1.
//

#import "SLImageView.h"
#import <CSLUILibrary/SLUtil.h>
#import <Accelerate/Accelerate.h>

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

- (instancetype)init {
    if (self == [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
//    self.rasterize = YES;
    imageViewQueue = dispatch_queue_create("com.csl.imageViewQueue", DISPATCH_QUEUE_CONCURRENT);
}

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
//        self.layer.shouldRasterize = self.rasterize;// 光栅栏效果
//        self.layer.contents = (id)newImage.CGImage;
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
        UInt8 *pixBuf = CFDataGetBytePtr(dataRef);
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
        [self sl_setImage:image];
    }else{
        dispatch_async(imageViewQueue, ^{
            @autoreleasepool{
                CIImage *ciImage = [[CIImage alloc] initWithImage:image];
                CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
                [filter setDefaults];
                CIContext *context = [CIContext contextWithOptions:nil];
                CIImage *outputImage = [filter outputImage];
                CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
                UIImage *newImage = [UIImage imageWithCGImage:cgImage];
                CGImageRelease(cgImage);
                [self sl_setImage:newImage];
            }
        });
    }
}

- (void)sl_corner:(UIImage *)image cornerRadis:(BOOL)cornerRadis {
    [self setCornerRadis:YES];
    [self sl_setImage:image];
}

- (void)sl_corner:(UIImage *)image radis:(CGFloat)cornerRadis {
    [self setRadis:cornerRadis];
    dispatch_async(imageViewQueue, ^{
        [self sl_setImage:image];
    });
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
    dispatch_async(imageViewQueue, ^{
        NSData* imageData =  UIImagePNGRepresentation(image);
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        filePath = [filePath stringByAppendingPathComponent:fileName];
        if ([imageData writeToFile:filePath atomically:YES]) {}
   });
}

- (void)decodeImage:(UIImage *)image toSize:(CGSize)size {
    [self sl_setImage:[[self class] decodeImage:image toSize:size]];
}

+ (UIImage *)decodeImage:(UIImage *)image toSize:(CGSize)size {
    if (image == nil) return nil;
    // animated images
    if (image.images != nil) return image;
    CGImageRef imageRef = image.CGImage;
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    BOOL anyAlpha = (alpha == kCGImageAlphaFirst ||
                     alpha == kCGImageAlphaLast ||
                     alpha == kCGImageAlphaPremultipliedFirst ||
                     alpha == kCGImageAlphaPremultipliedLast);
    if (anyAlpha) {
        NSLog(@"图片解压失败，存在alpha通道");
        return image;
    }
    CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
    CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
    BOOL unsupportedColorSpace = (imageColorSpaceModel == kCGColorSpaceModelUnknown ||
                                  imageColorSpaceModel == kCGColorSpaceModelMonochrome ||
                                  imageColorSpaceModel == kCGColorSpaceModelCMYK ||
                                  imageColorSpaceModel == kCGColorSpaceModelIndexed);
    if (unsupportedColorSpace) {
        colorspaceRef = CGColorSpaceCreateDeviceRGB();
    }
    size_t width = size.width;
    size_t height = size.height;
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorspaceRef,
                                                 kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
    UIImage *imageWithoutAlpha = [UIImage imageWithCGImage:imageRefWithoutAlpha
                                                     scale:image.scale
                                               orientation:image.imageOrientation];
    CGImageRelease(imageRefWithoutAlpha);
    CGColorSpaceRelease(colorspaceRef);
    CGContextRelease(context);
    return imageWithoutAlpha;
}

@end
