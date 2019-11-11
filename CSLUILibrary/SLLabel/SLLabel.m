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
#import <CSLUILibrary/UIView+SLBase.h>

#define SLCoreTextImageWidthPro @"SLCoreTextImageWidthPro"
#define SLCoreTextImageHeightPro @"SLCoreTextImageHeightPro"

static NSString *kCoreTextContentKey = @"content";
static NSString *kCoreTextFrameKey = @"frame";
static NSString *kCoreTextClickKey = @"onClick";

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
@property (nonatomic, strong) NSMutableDictionary *coreTextFrames;
@property (nonatomic, assign) NSInteger contentSpaceIndex;
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
    self.userInteractionEnabled = YES;
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
    self.userInteractionEnabled = YES;
    [self.attributeString appendAttributedString:[self imageSpaceWithWidth:width heith:height]];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)self.contentSpaceIndex];
    if (!self.coreTextFrames[key]) {
        self.coreTextFrames[key] = @{kCoreTextContentKey:image, kCoreTextClickKey:clickBlock}.copy;
    }
    self.contentSpaceIndex += 1;
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
    }
    self.lineHeight = heightAddup;
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
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    if (self.lineHeight > 0.0) {
        self.sl_height = self.lineHeight;
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
    [argDict setValue:@(width) forKey:SLCoreTextImageWidthPro];
    [argDict setValue:@(heigth) forKey:SLCoreTextImageHeightPro];
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callBacks, (__bridge void*)argDict);
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)spaceAttribut, CFRangeMake(0, 1), kCTRunDelegateAttributeName, runDelegate);
    return spaceAttribut;
}


@end
