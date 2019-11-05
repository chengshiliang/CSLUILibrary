//
//  SLPageControl.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import "SLPageControl.h"
#import <CSLUILibrary/SLImageView.h>
#import <CSLUILibrary/SLView.h>

#define DEFAULT_INDICATOR_WIDTH 6.0f
#define DEFAULT_INDICATOR_MARGIN 10.0f
#define DEFAULT_MIN_HEIGHT 36.0f

#define DEFAULT_INDICATOR_WIDTH_LARGE 7.0f
#define DEFAULT_INDICATOR_MARGIN_LARGE 9.0f
#define DEFAULT_MIN_HEIGHT_LARGE 36.0f

typedef NS_ENUM(NSUInteger, SLPageScrollImageType) {
    SLPageScrollImageTypeNormal = 1,
    SLPageScrollImageTypeCurrent,
    SLPageScrollImageTypeMask
};

typedef NS_ENUM(NSUInteger, SLPageScrollStyleDefaults) {
    SLPageScrollDefaultStyleClassic = 0,
    SLPageScrollDefaultStyleModern
};

@interface SLPageControl()
@property (strong, readonly, nonatomic) NSMutableDictionary *pageNames;
@property (strong, readonly, nonatomic) NSMutableDictionary *pageImages;
@property (strong, readonly, nonatomic) NSMutableDictionary *currentPageImages;
@property (strong, readonly, nonatomic) NSMutableDictionary *pageImageMasks;
@property (strong, readonly, nonatomic) NSMutableDictionary *cgImageMasks;
@property (strong, readwrite, nonatomic) NSArray *pageRects;
@property (nonatomic, strong) UIPageControl *accessibilityPageControl;
@end

@implementation SLPageControl
{
@private
    NSInteger            _displayedPage;
    CGFloat                _measuredIndicatorWidth;
    CGFloat                _measuredIndicatorHeight;
    CGImageRef            _pageImageMask;
}
@synthesize pageNames = _pageNames;
@synthesize pageImages = _pageImages;
@synthesize currentPageImages = _currentPageImages;
@synthesize pageImageMasks = _pageImageMasks;
@synthesize cgImageMasks = _cgImageMasks;

- (void)_initialize
{
    self.numberOfPages = 0;
    self.tapBehavior = SLPageControlTapBehaviorStep;
    self.backgroundColor = [UIColor clearColor];
    self.styleWithDefaults = SLPageScrollDefaultStyleModern;
    self.alignment = SLPageControlAlignmentCenter;
    self.isAccessibilityElement = YES;
    self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
    self.accessibilityPageControl = [[UIPageControl alloc] init];
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _initialize];
    }
    return self;
}

- (void)dealloc {
    if (_pageImageMask) {
        CGImageRelease(_pageImageMask);
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self _renderPages:context rect:rect];
}

- (void)_renderPages:(CGContextRef)context rect:(CGRect)rect {
    NSMutableArray *pageRects = [NSMutableArray arrayWithCapacity:self.numberOfPages];
    if (_numberOfPages < 2 && _hidesForSinglePage) {
        return;
    }
    
    CGFloat left = [self _leftOffset];
    
    CGFloat xOffset = left;
    CGFloat yOffset = 0.0f;
    UIColor *fillColor = nil;
    UIImage *image = nil;
    CGImageRef maskingImage = nil;
    CGSize maskSize = CGSizeZero;
    
    for (NSInteger i = 0; i < _numberOfPages; i++) {
        NSNumber *indexNumber = @(i);
        
        if (i == _displayedPage) {
            fillColor = _currentPageIndicatorTintColor ? _currentPageIndicatorTintColor : [UIColor whiteColor];
            image = _currentPageImages[indexNumber];
            if (nil == image) {
                image = _currentIndicatorImage;
            }
        } else {
            fillColor = _pageIndicatorTintColor ? _pageIndicatorTintColor : [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
            image = _pageImages[indexNumber];
            if (nil == image) {
                image = _indicatorImage;
            }
        }
        
        // If no finished images have been set, try a masking image
        if (nil == image) {
            maskingImage = (__bridge CGImageRef)_cgImageMasks[indexNumber];
            UIImage *originalImage = _pageImageMasks[indexNumber];
            maskSize = originalImage.size;
            
            // If no per page mask is set, try for a global page mask!
            if (nil == maskingImage) {
                maskingImage = _pageImageMask;
                maskSize = _indicatorMaskImage.size;
            }
        }
        
        [fillColor set];
        CGRect indicatorRect;
        if (image) {
            yOffset = [self _topOffsetForHeight:image.size.height rect:rect];
            CGFloat centeredXOffset = xOffset + floorf((_measuredIndicatorWidth - image.size.width) / 2.0f);
            [image drawAtPoint:CGPointMake(centeredXOffset, yOffset)];
            indicatorRect = CGRectMake(centeredXOffset, yOffset, image.size.width, image.size.height);
        } else if (maskingImage) {
            yOffset = [self _topOffsetForHeight:maskSize.height rect:rect];
            CGFloat centeredXOffset = xOffset + floorf((_measuredIndicatorWidth - maskSize.width) / 2.0f);
            indicatorRect = CGRectMake(centeredXOffset, yOffset, maskSize.width, maskSize.height);
            CGContextDrawImage(context, indicatorRect, maskingImage);
        } else {
            yOffset = [self _topOffsetForHeight:_indicatorDiameter rect:rect];
            CGFloat centeredXOffset = xOffset + floorf((_measuredIndicatorWidth - _indicatorDiameter) / 2.0f);
            indicatorRect = CGRectMake(centeredXOffset, yOffset, _indicatorDiameter, _indicatorDiameter);
            CGContextFillEllipseInRect(context, indicatorRect);
        }
        
        [pageRects addObject:[NSValue valueWithCGRect:indicatorRect]];
        maskingImage = NULL;
        xOffset += _measuredIndicatorWidth + _indicatorMargin;
    }
    
    self.pageRects = pageRects;
    
}

- (CGFloat)_leftOffset
{
    CGRect rect = self.bounds;
    CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat left = 0.0f;
    switch (_alignment) {
        case SLPageControlAlignmentCenter:
            left = ceilf(CGRectGetMidX(rect) - (size.width / 2.0f));
            break;
        case SLPageControlAlignmentRight:
            left = CGRectGetMaxX(rect) - size.width;
            break;
        default:
            break;
    }
    
    return left;
}

- (CGFloat)_topOffsetForHeight:(CGFloat)height rect:(CGRect)rect {
    return CGRectGetMaxY(rect) - height;
}

- (void)updateCurrentPageDisplay
{
    _displayedPage = _currentPage;
    [self setNeedsDisplay];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    CGFloat marginSpace = MAX(0, pageCount - 1) * _indicatorMargin;
    CGFloat indicatorSpace = pageCount * _measuredIndicatorWidth;
    CGSize size = CGSizeMake(marginSpace + indicatorSpace, _measuredIndicatorHeight);
    return size;
}

- (CGRect)rectForPageIndicator:(NSInteger)pageIndex
{
    if (pageIndex < 0 || pageIndex >= _numberOfPages) {
        return CGRectZero;
    }
    
    CGFloat left = [self _leftOffset];
    CGSize size = [self sizeForNumberOfPages:pageIndex + 1];
    CGRect rect = CGRectMake(left + size.width - _measuredIndicatorWidth, 0, _measuredIndicatorWidth, _measuredIndicatorWidth);
    return rect;
}

- (void)_setImage:(UIImage *)image forPage:(NSInteger)pageIndex type:(SLPageScrollImageType)type
{
    if (pageIndex < 0 || pageIndex >= _numberOfPages) {
        return;
    }
    
    NSMutableDictionary *dictionary = nil;
    switch (type) {
        case SLPageScrollImageTypeCurrent:
            dictionary = self.currentPageImages;
            break;
        case SLPageScrollImageTypeNormal:
            dictionary = self.pageImages;
            break;
        case SLPageScrollImageTypeMask:
            dictionary = self.pageImageMasks;
            break;
        default:
            break;
    }
    
    if (image) {
        dictionary[@(pageIndex)] = image;
    } else {
        [dictionary removeObjectForKey:@(pageIndex)];
    }
}

- (void)setImage:(UIImage *)image forPage:(NSInteger)pageIndex
{
    [self _setImage:image forPage:pageIndex type:SLPageScrollImageTypeNormal];
    [self _updateMeasuredIndicatorSizes];
}

- (void)setCurrentImage:(UIImage *)image forPage:(NSInteger)pageIndex
{
    [self _setImage:image forPage:pageIndex type:SLPageScrollImageTypeCurrent];;
    [self _updateMeasuredIndicatorSizes];
}

- (void)setImageMask:(UIImage *)image forPage:(NSInteger)pageIndex {
    [self _setImage:image forPage:pageIndex type:SLPageScrollImageTypeMask];
    
    if (nil == image) {
        [self.cgImageMasks removeObjectForKey:@(pageIndex)];
        return;
    }
    
    CGImageRef maskImage = [self createMaskForImage:image];
    
    if (maskImage) {
        self.cgImageMasks[@(pageIndex)] = (__bridge id)maskImage;
        CGImageRelease(maskImage);
        [self _updateMeasuredIndicatorSizeWithSize:image.size];
        [self setNeedsDisplay];
    }
}

- (id)_imageForPage:(NSInteger)pageIndex type:(SLPageScrollImageType)type
{
    if (pageIndex < 0 || pageIndex >= _numberOfPages) {
        return nil;
    }
    
    NSDictionary *dictionary = nil;
    switch (type) {
        case SLPageScrollImageTypeCurrent:
            dictionary = _currentPageImages;
            break;
        case SLPageScrollImageTypeNormal:
            dictionary = _pageImages;
            break;
        case SLPageScrollImageTypeMask:
            dictionary = _pageImageMasks;
            break;
        default:
            break;
    }
    
    return dictionary[@(pageIndex)];
}

- (UIImage *)imageForPage:(NSInteger)pageIndex
{
    return [self _imageForPage:pageIndex type:SLPageScrollImageTypeNormal];
}

- (UIImage *)currentImageForPage:(NSInteger)pageIndex
{
    return [self _imageForPage:pageIndex type:SLPageScrollImageTypeCurrent];
}

- (UIImage *)imageMaskForPage:(NSInteger)pageIndex
{
    return [self _imageForPage:pageIndex type:SLPageScrollImageTypeMask];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize sizeThatFits = [self sizeForNumberOfPages:self.numberOfPages];
    sizeThatFits.height = MAX(sizeThatFits.height, _minHeight);
    return sizeThatFits;
}

- (CGSize)intrinsicContentSize
{
    if (_numberOfPages < 1 || (_numberOfPages < 2 && _hidesForSinglePage)) {
        return CGSizeMake(UIViewNoIntrinsicMetric, 0.0f);
    }
    CGSize intrinsicContentSize = CGSizeMake(UIViewNoIntrinsicMetric, MAX(_measuredIndicatorHeight, _minHeight));
    return intrinsicContentSize;
}

- (void)updatePageNumberForScrollView:(UIScrollView *)scrollView
{
    NSInteger page = (int)floorf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.currentPage = page;
}

- (void)setScrollViewContentOffsetForCurrentPage:(UIScrollView *)scrollView animated:(BOOL)animated
{
    CGPoint offset = scrollView.contentOffset;
    offset.x = scrollView.bounds.size.width * self.currentPage;
    [scrollView setContentOffset:offset animated:animated];
}

- (void)setStyleWithDefaults:(SLPageScrollStyleDefaults)defaultStyle
{
    switch (defaultStyle) {
        case SLPageScrollDefaultStyleModern:
            self.indicatorDiameter = DEFAULT_INDICATOR_WIDTH_LARGE;
            self.indicatorMargin = DEFAULT_INDICATOR_MARGIN_LARGE;
            self.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
            self.minHeight = DEFAULT_MIN_HEIGHT_LARGE;
            break;
        case SLPageScrollDefaultStyleClassic:
        default:
            self.indicatorDiameter = DEFAULT_INDICATOR_WIDTH;
            self.indicatorMargin = DEFAULT_INDICATOR_MARGIN;
            self.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
            self.minHeight = DEFAULT_MIN_HEIGHT;
            break;
    }
}

#pragma mark -

- (CGImageRef)createMaskForImage:(UIImage *)image CF_RETURNS_RETAINED
{
    size_t pixelsWide = image.size.width * image.scale;
    size_t pixelsHigh = image.size.height * image.scale;
    size_t bitmapBytesPerRow = (pixelsWide * 1);
    CGContextRef context = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, CGImageGetBitsPerComponent(image.CGImage), bitmapBytesPerRow, NULL, (CGBitmapInfo)kCGImageAlphaOnly);
    CGContextTranslateCTM(context, 0.f, pixelsHigh);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGContextDrawImage(context, CGRectMake(0, 0, pixelsWide, pixelsHigh), image.CGImage);
    CGImageRef maskImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    return maskImage;
}

- (void)_updateMeasuredIndicatorSizeWithSize:(CGSize)size
{
    _measuredIndicatorWidth = MAX(_measuredIndicatorWidth, size.width);
    _measuredIndicatorHeight = MAX(_measuredIndicatorHeight, size.height);
}

- (void)_updateMeasuredIndicatorSizes
{
    _measuredIndicatorWidth = _indicatorDiameter;
    _measuredIndicatorHeight = _indicatorDiameter;
    
    // If we're only using images, ignore the _indicatorDiameter
    if ( (self.indicatorImage || self.indicatorMaskImage) && self.currentIndicatorImage )
    {
        _measuredIndicatorWidth = 0;
        _measuredIndicatorHeight = 0;
    }
    
    if (self.indicatorImage) {
        [self _updateMeasuredIndicatorSizeWithSize:self.indicatorImage.size];
    }
    
    if (self.currentIndicatorImage) {
        [self _updateMeasuredIndicatorSizeWithSize:self.currentIndicatorImage.size];
    }
    
    if (self.indicatorMaskImage) {
        [self _updateMeasuredIndicatorSizeWithSize:self.indicatorMaskImage.size];
    }
    
    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self invalidateIntrinsicContentSize];
    }
}


#pragma mark - Tap Gesture
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (SLPageControlTapBehaviorJump == self.tapBehavior) {
        
        __block NSInteger tappedIndicatorIndex = NSNotFound;
        
        [self.pageRects enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger index, BOOL *stop) {
            CGRect indicatorRect = [value CGRectValue];
            
            if (CGRectContainsPoint(indicatorRect, point)) {
                tappedIndicatorIndex = index;
                *stop = YES;
            }
        }];
        
        if (NSNotFound != tappedIndicatorIndex) {
            [self setCurrentPage:tappedIndicatorIndex sendEvent:YES canDefer:YES];
            return;
        }
    }
    
    CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat left = [self _leftOffset];
    CGFloat middle = left + (size.width / 2.0f);
    if (point.x < middle) {
        [self setCurrentPage:self.currentPage - 1 sendEvent:YES canDefer:YES];
    } else {
        [self setCurrentPage:self.currentPage + 1 sendEvent:YES canDefer:YES];
    }
    
}

#pragma mark - Accessors

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setIndicatorDiameter:(CGFloat)indicatorDiameter
{
    if (indicatorDiameter == _indicatorDiameter) {
        return;
    }
    
    _indicatorDiameter = indicatorDiameter;
    
    // Absolute minimum height of the control is the indicator diameter
    if (_minHeight < indicatorDiameter) {
        self.minHeight = indicatorDiameter;
    }
    
    [self _updateMeasuredIndicatorSizes];
    [self setNeedsDisplay];
}

- (void)setIndicatorMargin:(CGFloat)indicatorMargin
{
    if (indicatorMargin == _indicatorMargin) {
        return;
    }
    
    _indicatorMargin = indicatorMargin;
    [self setNeedsDisplay];
}

- (void)setMinHeight:(CGFloat)minHeight
{
    if (minHeight == _minHeight) {
        return;
    }
    
    // Absolute minimum height of the control is the indicator diameter
    if (minHeight < _indicatorDiameter) {
        minHeight = _indicatorDiameter;
    }
    
    _minHeight = minHeight;
    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self invalidateIntrinsicContentSize];
    }
    [self setNeedsLayout];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    if (numberOfPages == _numberOfPages) {
        return;
    }
    
    self.accessibilityPageControl.numberOfPages = numberOfPages;
    
    _numberOfPages = MAX(0, numberOfPages);
    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self invalidateIntrinsicContentSize];
    }
    [self updateAccessibilityValue];
    [self setNeedsDisplay];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [self setCurrentPage:currentPage sendEvent:NO canDefer:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage sendEvent:(BOOL)sendEvent canDefer:(BOOL)defer
{
    _currentPage = MIN(MAX(0, currentPage), _numberOfPages - 1);
    self.accessibilityPageControl.currentPage = self.currentPage;
    
    [self updateAccessibilityValue];
    
    if (NO == self.defersCurrentPageDisplay || NO == defer) {
        _displayedPage = _currentPage;
        [self setNeedsDisplay];
    }
    
    if (sendEvent) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setCurrentIndicatorImage:(UIImage *)currentIndicatorImage
{
    if ([currentIndicatorImage isEqual:_currentIndicatorImage]) {
        return;
    }
    
    _currentIndicatorImage = currentIndicatorImage;
    [self _updateMeasuredIndicatorSizes];
    [self setNeedsDisplay];
}

- (void)setIndicatorImage:(UIImage *)indicatorImage
{
    if ([indicatorImage isEqual:_indicatorImage]) {
        return;
    }
    
    _indicatorImage = indicatorImage;
    [self _updateMeasuredIndicatorSizes];
    [self setNeedsDisplay];
}

- (void)setindicatorMaskImage:(UIImage *)indicatorMaskImage
{
    if ([indicatorMaskImage isEqual:_indicatorMaskImage]) {
        return;
    }
    
    _indicatorMaskImage = indicatorMaskImage;
    
    if (_pageImageMask) {
        CGImageRelease(_pageImageMask);
    }
    
    _pageImageMask = [self createMaskForImage:_indicatorMaskImage];
    
    [self _updateMeasuredIndicatorSizes];
    [self setNeedsDisplay];
}

- (NSMutableDictionary *)pageNames
{
    if (nil != _pageNames) {
        return _pageNames;
    }
    
    _pageNames = [[NSMutableDictionary alloc] init];
    return _pageNames;
}

- (NSMutableDictionary *)pageImages
{
    if (nil != _pageImages) {
        return _pageImages;
    }
    
    _pageImages = [[NSMutableDictionary alloc] init];
    return _pageImages;
}

- (NSMutableDictionary *)currentPageImages
{
    if (nil != _currentPageImages) {
        return _currentPageImages;
    }
    
    _currentPageImages = [[NSMutableDictionary alloc] init];
    return _currentPageImages;
}

- (NSMutableDictionary *)pageImageMasks
{
    if (nil != _pageImageMasks) {
        return _pageImageMasks;
    }
    
    _pageImageMasks = [[NSMutableDictionary alloc] init];
    return _pageImageMasks;
}

- (NSMutableDictionary *)cgImageMasks
{
    if (nil != _cgImageMasks) {
        return _cgImageMasks;
    }
    
    _cgImageMasks = [[NSMutableDictionary alloc] init];
    return _cgImageMasks;
}

#pragma mark - UIAccessibility

- (void)setName:(NSString *)name forPage:(NSInteger)pageIndex
{
    if (pageIndex < 0 || pageIndex >= _numberOfPages) {
        return;
    }
    
    self.pageNames[@(pageIndex)] = name;
    
}

- (NSString *)nameForPage:(NSInteger)pageIndex
{
    if (pageIndex < 0 || pageIndex >= _numberOfPages) {
        return nil;
    }
    
    return self.pageNames[@(pageIndex)];
}

- (void)updateAccessibilityValue
{
    NSString *pageName = [self nameForPage:self.currentPage];
    NSString *accessibilityValue = self.accessibilityPageControl.accessibilityValue;
    
    if (pageName) {
        self.accessibilityValue = [NSString stringWithFormat:@"%@ - %@", pageName, accessibilityValue];
    } else {
        self.accessibilityValue = accessibilityValue;
    }
}

@end
