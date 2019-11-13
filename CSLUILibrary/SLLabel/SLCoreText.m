//
//  SLCoreText.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLCoreText.h"
#import <CoreText/CoreText.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLImageView.h>
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/UIView+SLBase.h>

static NSString *kCoreTextContentKey = @"content";
static NSString *kCoreTextFrameKey = @"frame";
static NSString *kCoreTextClickKey = @"onClick";
static NSString *kLCoreTextImageWidthPro = @"kLCoreTextImageWidthPro";
static NSString *kLCoreTextImageHeightPro = @"kLCoreTextImageHeightPro";

static CGFloat ctRunDelegateGetWidthCallback (void * refCon ){
    NSDictionary *infoDict = (__bridge NSDictionary*)refCon;
    if ([infoDict isKindOfClass:[NSDictionary class]]) {
        return  [infoDict[kLCoreTextImageWidthPro] floatValue];
    }
    return 0;
}

static CGFloat ctRunDelegateGetAscentCallback (void * refCon ){
    NSDictionary *infoDict = (__bridge NSDictionary*)refCon;
    if ([infoDict isKindOfClass:[NSDictionary class]]) {
        return  [infoDict[kLCoreTextImageHeightPro] floatValue];
    }
    return 0;
}

static CGFloat ctRunDelegateGetDescentCallback (void * refCon ){
    return 0;
}

@interface SLCoreText()
@property (nonatomic, strong) NSMutableDictionary *coreTextFrames;
@property (nonatomic, assign) NSInteger contentSpaceIndex;
@property (nonatomic, assign) double lineHeight;// 图文显示总高度
@end

@implementation SLCoreText

- (NSMutableDictionary *)coreTextFrames {
    if (!_coreTextFrames) {
        _coreTextFrames = [NSMutableDictionary dictionary];
    }
    return _coreTextFrames;
}

- (NSMutableAttributedString *)attributeString {
    if (!_attributeString) {
        _attributeString = [[NSMutableAttributedString alloc]initWithString:self.text attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor}];
        self.contentSpaceIndex = self.text.length;
        self.userInteractionEnabled = YES;
        self.lineHeight = MAXFLOAT;
    }
    return _attributeString;
}

- (void)addAttributeString:(NSString *)string
                      font:(UIFont *)font
                     color:(UIColor *)color
                     click:(void(^)(NSString *string))clickBlock {
    [self addAttributeString:string
                        font:font
                       color:color
                  attributes:nil
                       click:clickBlock];
}

- (void)addAttributeString:(NSString *)string
                      font:(UIFont *)font
                     color:(UIColor *)color
                attributes:(NSDictionary *)attributes
                     click:(void(^)(NSString *string))clickBlock {
    if ([string emptyString]) return;
    NSMutableDictionary *attributesM = [NSMutableDictionary dictionary];
    [attributesM addEntriesFromDictionary:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    if(attributes) [attributesM addEntriesFromDictionary:attributes];
    NSMutableAttributedString *stringAttributeM = [[NSMutableAttributedString alloc] initWithString:string attributes:attributesM.copy];
    [self.attributeString appendAttributedString:stringAttributeM];
    
    if ([string hasPrefix:@"\r\n"]) {
        self.contentSpaceIndex += 2;
        string = [string substringFromIndex:2];
    } else if ([string hasPrefix:@"\r"] || [string hasPrefix:@"\n"]) {
        self.contentSpaceIndex += 1;
        string = [string substringFromIndex:1];
    }
    NSString *key = [NSString stringWithFormat:@"%ld", (long)self.contentSpaceIndex];
    if (!self.coreTextFrames[key]) {
        self.coreTextFrames[key] = @{kCoreTextContentKey:string, kCoreTextClickKey:clickBlock}.copy;
    }
    self.contentSpaceIndex += string.length;
}

- (void)addAttributeImage:(UIImage *)image
                    click:(void(^)(UIImage *image))clickBlock{
    [self addAttributeImage:image
                      width:image.size.width
                     height:image.size.height
                      click:clickBlock];
}

- (void)addAttributeImage:(UIImage *)image
                    width:(CGFloat)width
                   height:(CGFloat)height
                    click:(void(^)(UIImage *image))clickBlock{
    if (!image) return;
    [self.attributeString appendAttributedString:[self imageSpaceWithWidth:width heith:height]];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)self.contentSpaceIndex];
    if (!self.coreTextFrames[key]) {
        self.coreTextFrames[key] = @{kCoreTextContentKey:image, kCoreTextClickKey:clickBlock}.copy;
    }
    self.contentSpaceIndex += 1;
}

- (void)reload {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CTFramesetterRef frameSetterRef =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributeString);
    CGPathRef pathRef = CGPathCreateWithRect(CGRectMake(0, 0, self.sl_width, self.lineHeight), &CGAffineTransformIdentity);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), pathRef, nil);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    CGContextTranslateCTM(contextRef, 0, self.lineHeight);
    CGContextScaleCTM(contextRef, 1, -1);
    CTFrameDraw(frameRef, contextRef);
    
    NSArray *lineAry = (__bridge NSArray*)CTFrameGetLines(frameRef);
    CGPoint pointAry[lineAry.count];
    memset(pointAry, 0, sizeof(pointAry));
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), pointAry);
    double heightAddup = 0;
    double widthMax = 0;
    for (int i = 0; i < lineAry.count; i++) {
        CTLineRef lineRef = (__bridge CTLineRef)lineAry[i];
        NSArray *runAry =  (__bridge NSArray*)CTLineGetGlyphRuns(lineRef);
        CGFloat ascent = 0;
        CGFloat descent = 0;
        CGFloat lineGap = 0;
        CTLineGetTypographicBounds(lineRef, &ascent, &descent, &lineGap);
        double startX = 0;
        double runHeight = ascent + descent + lineGap;
        for (int j = 0; j < runAry.count; j++) {
            CTRunRef runRef = (__bridge CTRunRef)runAry[j];
            CFRange runRange = CTRunGetStringRange(runRef);
            double runWidth = CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), 0, 0, 0);
            NSMutableDictionary *tempCoreTextFrames = self.coreTextFrames.mutableCopy;
            for (NSString *key in tempCoreTextFrames) {
                NSInteger contentSpaceIndex = [key integerValue];
                if (contentSpaceIndex != runRange.location || contentSpaceIndex >= runRange.location + runRange.length) continue;
                if (!tempCoreTextFrames[key]) continue;
                NSMutableDictionary *dicM = [tempCoreTextFrames[key] mutableCopy];
                [dicM setValue:[NSValue valueWithCGRect:CGRectMake(startX, heightAddup, runWidth, runHeight)] forKey:kCoreTextFrameKey];
                self.coreTextFrames[key] = dicM.copy;
            }
            startX += runWidth;
        }
        heightAddup += runHeight;
        widthMax = MAX(startX, widthMax);
    }
    self.lineHeight = heightAddup;
    self.sl_height = heightAddup;
    self.sl_width = widthMax;
    !self.sizeChange?:self.sizeChange(heightAddup, widthMax);
    if (self.coreTextFrames.allKeys.count <= 0) return;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[SLImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    for (NSString *key in self.coreTextFrames) {
        NSMutableDictionary *dicM = [self.coreTextFrames[key] mutableCopy];
        NSValue *frameValue = dicM[kCoreTextFrameKey];
        id content = dicM[kCoreTextContentKey];
        CGRect imageViewFrame = [frameValue CGRectValue];
        if (imageViewFrame.size.width <= 0) continue;
        if (![content isKindOfClass:[UIImage class]]) continue;
        SLImageView *imageView = [[SLImageView alloc] init];
        [imageView sl_setImage:(UIImage *)content];
        imageView.frame = imageViewFrame;
        [self addSubview:imageView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.coreTextFrames.allKeys.count <= 0) return;
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    for (NSString *key in self.coreTextFrames) {
        NSMutableDictionary *dicM = [self.coreTextFrames[key] mutableCopy];
        NSValue *frameValue = dicM[kCoreTextFrameKey];
        CGRect viewFrame = [frameValue CGRectValue];
        if (viewFrame.size.width <= 0) continue;
        if (!CGRectContainsPoint(viewFrame, touchPoint)) continue;
        id content = dicM[kCoreTextContentKey];
        void(^clickBlock)(id) = dicM[kCoreTextClickKey];
        if (clickBlock) clickBlock(content);
    }
}

- (NSMutableAttributedString*)imageSpaceWithWidth:(float)width heith:(float)heigth{
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.getWidth = ctRunDelegateGetWidthCallback;
    callBacks.getAscent = ctRunDelegateGetAscentCallback;
    callBacks.getDescent = ctRunDelegateGetDescentCallback;
    callBacks.version = kCTRunDelegateCurrentVersion;
    
    NSMutableAttributedString *spaceAttribut = [[NSMutableAttributedString alloc] initWithString:@" "];
    static NSMutableDictionary *argDict = nil;
    argDict = [NSMutableDictionary dictionary];
    [argDict setValue:@(width) forKey:kLCoreTextImageWidthPro];
    [argDict setValue:@(heigth) forKey:kLCoreTextImageHeightPro];
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callBacks, (__bridge void*)argDict);
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)spaceAttribut, CFRangeMake(0, 1), kCTRunDelegateAttributeName, runDelegate);
    return spaceAttribut;
}
@end
