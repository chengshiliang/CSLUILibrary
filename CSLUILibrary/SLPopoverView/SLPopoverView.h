//
//  SLPopoverView.h
//  Embark
//
//  Created by Oliver Rickard on 20/08/2012.
//
//

#import "SLView.h"
#import <CSLUILibrary/SLTabbarButton.h>

@interface SLPopoverAction : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^handler)(SLPopoverAction *action);

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(SLPopoverAction *action))handler;

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(SLPopoverAction *action))handler;
@end

@interface SLPopoverView : SLView
@property (nonatomic, copy) void(^selectBlock)(SLPopoverView *popoverView, NSInteger index);
@property (nonatomic, assign) CGFloat arrowWH; // 箭头大小
@property (nonatomic, assign) CGFloat spaceHorizontal;// popover 横向间距
@property (nonatomic, assign) CGFloat spaceVertical; // popover 和指定视图或者指定位置之间的距离
@property (nonatomic, assign) UIEdgeInsets contentInset; // 内容内边距
@property (nonatomic, assign) CGFloat itemHeight; // 每一行高度
@property (nonatomic, assign) CGFloat imageTitleSpace;// 图片和文字之间的间距
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong, readonly) UIView *backView;

- (void)showToView:(UIView *)pointView withActions:(NSArray<SLPopoverAction *> *)actions;

- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<SLPopoverAction *> *)actions;

- (void)hide;
@end
