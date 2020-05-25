//
//  SLPaintView.m
//  CSLUILibrary
//
//  Created by 程石亮(寿险总部人工智能研发团队AI平台领域AI应用平台组) on 2020/5/24.
//

#import "SLPaintView.h"
#import <CSLCommonLibrary/UIView+SLBase.h>

@interface SLPaintScrollView : UIScrollView

@end

@implementation SLPaintScrollView
- (BOOL)touchesShouldBegin:(NSSet *)touches
                 withEvent:(UIEvent *)event
             inContentView:(UIView *)view {
    if ([event allTouches].count == 1) {
        return YES;
    }
    return NO;
}
@end

@interface SLPaintPath : UIBezierPath
+ (instancetype)paintPathWithLineWidth:(CGFloat)lineWidth
                            startPoint:(CGPoint)startPoint;
@end

@implementation SLPaintPath
+ (instancetype)paintPathWithLineWidth:(CGFloat)lineWidth
                            startPoint:(CGPoint)startPoint {
    SLPaintPath * path = [[self alloc] init];
    path.lineWidth = lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    [path moveToPoint:startPoint];
    return path;
}
@end

@interface SLPaintShapeLayer : CAShapeLayer
+ (instancetype)shapeLayerWithLineColor:(UIColor *)lineColor
                              lineWidth:(CGFloat)lineWidth;
@end

@implementation SLPaintShapeLayer
+ (instancetype)shapeLayerWithLineColor:(UIColor *)lineColor
                              lineWidth:(CGFloat)lineWidth{
    SLPaintShapeLayer *shapeLayer = [self layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.strokeColor = (lineColor?:[UIColor blackColor]).CGColor;
    shapeLayer.lineWidth = lineWidth;
    return shapeLayer;
}
@end

@interface SLPaintDrawerView : UIView
@property (nonatomic, assign)NSInteger lineWidth;
@property (nonatomic, strong)UIColor *lineColor;
@property (nonatomic, strong)SLPaintPath * path;
@property (nonatomic, strong)SLPaintShapeLayer * shapeLayer;
@property (nonatomic, strong)NSMutableArray<SLPaintShapeLayer *>* undoLines;// 撤销的线条数组
@property (nonatomic, strong)NSMutableArray<SLPaintShapeLayer *>* appearLines;// 可见的线条数组
- (void)clearScreen;// 清屏
- (void)undo;// 撤销
- (void)redo;// 恢复
@end

@implementation SLPaintDrawerView
- (NSMutableArray *)appearLines {
    if (!_appearLines) {
        _appearLines = [NSMutableArray array];
    }
    return _appearLines;
}
- (NSMutableArray *)undoLines {
    if (_undoLines == nil) {
        _undoLines = [NSMutableArray array];
    }
    return _undoLines;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (event.allTouches.count != 1) return;
    UITouch *touch = [touches anyObject];
    CGPoint startPoint = [touch locationInView:self];
    self.path = [SLPaintPath paintPathWithLineWidth:self.lineWidth startPoint:startPoint];
    self.shapeLayer = [SLPaintShapeLayer shapeLayerWithLineColor:self.lineColor lineWidth:self.lineWidth];
    self.shapeLayer.path = self.path.CGPath;
    [self.layer addSublayer:self.shapeLayer];
    [[self mutableArrayValueForKey:@"undoLines"] removeAllObjects];
    [[self mutableArrayValueForKey:@"appearLines"] addObject:self.shapeLayer];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:self];
    
    if ([event allTouches].count > 1){
        [self.superview touchesMoved:touches withEvent:event];
    }else if ([event allTouches].count == 1) {
        [self.path addLineToPoint:movePoint];
        self.shapeLayer.path = self.path.CGPath;
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count > 1) [self.superview touchesMoved:touches withEvent:event];
}
- (void)drawLine {//  画线
    [self.layer addSublayer:self.appearLines.lastObject];
}
- (void)clearScreen {// 清屏
    if (!self.appearLines.count) return;
    [self.appearLines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [[self mutableArrayValueForKey:@"appearLines"] removeAllObjects];
    [[self mutableArrayValueForKey:@"undoLines"] removeAllObjects];
}
- (void)undo {// 撤销
    if (!self.appearLines.count) return;
    [[self mutableArrayValueForKey:@"undoLines"] addObject:self.appearLines.lastObject];
    [self.appearLines.lastObject removeFromSuperlayer];
    [[self mutableArrayValueForKey:@"appearLines"] removeLastObject];
}
- (void)redo {// 恢复
    if (!self.undoLines.count) return;
    [[self mutableArrayValueForKey:@"appearLines"] addObject:self.undoLines.lastObject];
    [[self mutableArrayValueForKey:@"undoLines"] removeLastObject];
    [self drawLine];
}
@end

@interface SLPaintView()
@property (nonatomic, strong) SLPaintScrollView *paintScrollView;
@property (nonatomic, strong) SLPaintDrawerView *drawView;
@property (nonatomic, strong) UIColor *paintColor;
@end

@implementation SLPaintView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}
- (void)initialize {
    [self.drawView addObserver:self forKeyPath:@"appearLines" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.drawView addObserver:self forKeyPath:@"undoLines" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    self.paintScrollView = [[SLPaintScrollView alloc] initWithFrame:CGRectZero];
    [self.paintScrollView setUserInteractionEnabled:YES];
    [self.paintScrollView setScrollEnabled:YES];
    [self.paintScrollView setMultipleTouchEnabled:YES];
    [self.paintScrollView addSubview:self.drawView];
    [self.paintScrollView setContentSize:self.drawView.frame.size];
    [self.paintScrollView setDelaysContentTouches:NO];
    [self.paintScrollView setCanCancelContentTouches:NO];
    [self addSubview:self.paintScrollView];
    self.alpha = 0;
}
- (SLPaintDrawerView *)drawView {
    if (!_drawView) {
        _drawView = [[SLPaintDrawerView alloc] init];
        _drawView.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _drawView;
}
- (void)setLineWidth:(NSInteger)lineWidth {
    _lineWidth = lineWidth;
    self.drawView.lineWidth = lineWidth;
}
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.drawView.lineColor = lineColor;
}
- (void)layoutSubviews {
    self.paintScrollView.frame = self.bounds;
    self.drawView.frame = CGRectMake(0, 0, self.bounds.size.width*5.0, self.bounds.size.height*2.0);
    self.paintScrollView.contentSize = self.drawView.frame.size;
}
- (void)show {
    self.drawView.appearLines = [NSMutableArray arrayWithArray:self.appearLines];
    for (CALayer * layer in self.appearLines) {
        [self.drawView.layer addSublayer:layer];
    }
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                                    self.alpha = 1;
                                 }
                     completion:^(BOOL finished) {
        [self getImageRender];
    }];
}
- (void)eraser {// 橡皮擦
    self.lineWidth = 10;
    self.lineColor = self.paintColor;
}
- (void)clearScreen{// 清屏
    [self.drawView clearScreen];
}
- (void)undo {// 撤销
    [self.drawView undo];
}
- (void)redo {// 恢复
    [self.drawView redo];
}
- (void)dismiss{
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                                    self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (finished && self.linesChanged) {
                            self.linesChanged(self.drawView.appearLines, self.drawView.undoLines,self.num);
                         }
                         [self removeFromSuperview];
                         [self.drawView removeObserver:self forKeyPath:@"undoLines"];
                         [self.drawView removeObserver:self forKeyPath:@"appearLines"];
                     }];
}
- (void)getImageRender {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -self.bounds.size.height);
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.paintColor = [[UIColor alloc]initWithPatternImage:image];
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    !self.linesChanged?:self.linesChanged(self.drawView.appearLines, self.drawView.undoLines,self.num);
}
@end
