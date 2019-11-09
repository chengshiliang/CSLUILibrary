//
//  SLLabel.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import "SLLabel.h"
#import <CoreText/CoreText.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLUIConst.h>
#import <CSLUILibrary/SLUtil.h>
#import <CSLUILibrary/SLUIConfig.h>
#import <CSLUILibrary/NSString+Util.h>

#define SLCoreTextImageWidthPro @"SLCoreTextImageWidthPro"
#define SLCoreTextImageHeightPro @"SLCoreTextImageHeightPro"

static const NSString *kCoreTextImageKey = @"image";
static const NSString *kCoreTextImageFrameKey = @"frame";

static CGFloat ctRunDelegateGetWidthCallback (void * refCon ){
    NSDictionary *infoDict = (__bridge NSDictionary*)refCon;
    if ([infoDict isKindOfClass:[NSDictionary class]]) {
        return  [infoDict[SLCoreTextImageWidthPro] floatValue];
    }
    return 0;
}

static CGFloat ctRunDelegateGetAscentCallback (void * refCon ){
    NSDictionary *infoDict = (__bridge NSDictionary*)refCon;
    if ([infoDict isKindOfClass:[NSDictionary class]]) {
        return  [infoDict[SLCoreTextImageHeightPro] floatValue];
    }
    return 0;
}

static CGFloat ctRunDelegateGetDescentCallback (void * refCon ){
    return 0;
}

@interface SLLabel()
@property (nonatomic, strong) NSMutableDictionary *imageViewFrames;
@property (nonatomic, assign) NSInteger imageSpaceIndex;
@end

@implementation SLLabel
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (instancetype)init {
    if (self == [super init]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    self.labelType = LabelNormal;
    self.textAlignment = NSTextAlignmentLeft;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (NSMutableDictionary *)imageViewFrames {
    if (!_imageViewFrames) {
        _imageViewFrames = [NSMutableDictionary dictionary];
    }
    return _imageViewFrames;
}

- (NSMutableAttributedString *)attributeString {
    if (!_attributeString) {
        _attributeString = [[NSMutableAttributedString alloc]initWithString:self.text attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor}];
        self.imageSpaceIndex = self.text.length;
    }
    return _attributeString;
}

- (void)setLabelType:(LabelType)labelType {
    NSDictionary *config = [SLUIConfig share].labelConfig;
    NSString *typeKey = [NSString stringWithFormat:@"%ld", (long)labelType];
    NSDictionary *dic = config[typeKey];
    if (!dic) {
        self.font = [SLUtil fontSize:labelType];
        self.textColor = [SLUtil color:labelType];
    } else {
        self.font = dic[SLLabelFontSize];
        self.textColor = dic[SLLabelColor];
    }
}

- (CGRect)getContentRect {
    return [self textRectForBounds:self.frame limitedToNumberOfLines:self.numberOfLines];
}

- (void)addAttributeString:(NSString *)string font:(UIFont *)font color:(UIColor *)color {
    if ([string emptyString]) return;
    NSMutableAttributedString *stringAttributeM = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [self.attributeString appendAttributedString:stringAttributeM];
    self.imageSpaceIndex += string.length;
}

- (void)addAttributeImage:(UIImage *)image {
    [self addAttributeImage:image width:image.size.width height:image.size.height];
}

- (void)addAttributeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height {
    if (!image) return;
    [self.attributeString appendAttributedString:[self imageSpaceWithWidth:width heith:height]];
    NSString *key = [NSString stringWithFormat:@"%ld", self.imageSpaceIndex];
    if (!self.imageViewFrames[key]) {
        self.imageViewFrames[key] = @{kCoreTextImageKey:image}.copy;
    }
    self.imageSpaceIndex += 1;
}

- (void)reload {
    [self layoutIfNeeded];
}

- (void)drawRect:(CGRect)rect {
    CTFramesetterRef frameSetterRef =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributeString);
    CGPathRef pathRef = CGPathCreateWithRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), &CGAffineTransformIdentity);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), pathRef, nil);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    CGContextTranslateCTM(contextRef, 0, self.frame.size.height);
    CGContextScaleCTM(contextRef, 1, -1);
    CTFrameDraw(frameRef, contextRef);
    
    NSArray *lineAry = (__bridge NSArray*)CTFrameGetLines(frameRef);
    CGPoint pointAry[lineAry.count];
    memset(pointAry, 0, sizeof(pointAry));
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), pointAry);
    double heightAddup = 0;
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
            for (NSString *key in self.imageViewFrames) {
                NSInteger imageSpaceIndex = [key integerValue];
                if (imageSpaceIndex != runRange.location || imageSpaceIndex >= runRange.location + runRange.length) continue;
                if (!self.imageViewFrames[key]) continue;
                NSMutableDictionary *dicM = [self.imageViewFrames[key] mutableCopy];
                [dicM setValue:[NSValue valueWithCGRect:CGRectMake(startX, heightAddup, runWidth, runHeight)] forKey:kCoreTextImageFrameKey];
                self.imageViewFrames[key] = dicM.copy;
            }
            startX += runWidth;
        }
        heightAddup += runHeight;
    }
    self.lineHeight = heightAddup;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    if (self.imageViewFrames.allKeys.count <= 0) return;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[SLImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    for (NSString *key in self.imageViewFrames) {
        NSMutableDictionary *dicM = [self.imageViewFrames[key] mutableCopy];
        NSValue *frameValue = dicM[kCoreTextImageFrameKey];
        UIImage *image = dicM[kCoreTextImageKey];
        CGRect imageViewFrame = [frameValue CGRectValue];
        if (imageViewFrame.size.width <= 0) continue;
        SLImageView *imageView = [[SLImageView alloc] init];
        [imageView sl_setImage:image];
        imageView.frame = imageViewFrame;
        [self addSubview:imageView];
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
    [argDict setValue:@(width) forKey:SLCoreTextImageWidthPro];
    [argDict setValue:@(heigth) forKey:SLCoreTextImageHeightPro];
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callBacks, (__bridge void*)argDict);
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)spaceAttribut, CFRangeMake(0, 1), kCTRunDelegateAttributeName, runDelegate);
    return spaceAttribut;
}


@end
