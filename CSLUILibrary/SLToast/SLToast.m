//
//  SLToast.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/6.
//

#import "SLToast.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/SLUIConfig.h>
#import <CSLUILibrary/SLImageView.h>

@implementation SLToastManager
- (NSTimeInterval)duration {
    if (_duration < 0) {
        return 2.0f;
    }
    return _duration;
}
- (NSInteger)maxCount {
    if (_maxCount <= 0) {
        return 10000;
    }
    return _maxCount;
}
@end

@implementation SLToastStyle
- (SLView *)superContentView {
    if (!_superContentView) {
        _superContentView = [UIApplication sharedApplication].keyWindow;
    }
    return _superContentView;
}
- (UIColor *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    }
    return _backgroundColor;
}
- (SLLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SLLabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = SLUIBoldFont(17.0);
        _titleLabel.textColor = SLUIHexColor(0xffffff);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (SLLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[SLLabel alloc]init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = SLUINormalFont(14.0);
        _messageLabel.textColor = SLUIHexColor(0xffffff);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}
- (CGFloat)width {
    if (_width <= 0) {
        _width = kScreenWidth * 0.8;
    }
    return _width;
}
- (SLView *)wraperView {
    if (!_wraperView) {
        _wraperView = [[SLView alloc]init];
        _wraperView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return _wraperView;
}
- (CGSize)imageSize {
    if ([NSStringFromCGSize(_imageSize) isEqualToString:NSStringFromCGSize(CGSizeZero)]) {
        _imageSize = CGSizeMake(30, 30);
    }
    return _imageSize;
}
- (CGSize)activitySize {
    if ([NSStringFromCGSize(_activitySize) isEqualToString:NSStringFromCGSize(CGSizeZero)]) {
        _activitySize = CGSizeMake(50, 50);
    }
    return _activitySize;
}
@end

static int titleLabelTag = 101;
static int messageLabelTag = 102;
static int imageViewTag = 103;

@implementation SLToast
+ (instancetype)makeToast:(NSString *)message {
    return [self makeToast:message
                     title:@""
                     image:nil
                  duration:[SLUIConfig share].toastManager.duration
                  position:[SLUIConfig share].toastManager.position
             imagePosition:[SLUIConfig share].toastManager.imagePosition
                     style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    title:(NSString *)title{
    return [self makeToast:message
                     title:title
                     image:nil
                  duration:[SLUIConfig share].toastManager.duration
                  position:[SLUIConfig share].toastManager.position
             imagePosition:[SLUIConfig share].toastManager.imagePosition
                     style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    image:(UIImage *)image {
    return [self makeToast:message
                     title:@""
                     image:image
                  duration:[SLUIConfig share].toastManager.duration
                  position:[SLUIConfig share].toastManager.position
             imagePosition:[SLUIConfig share].toastManager.imagePosition
                     style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    title:(NSString *)title
                    image:(UIImage *)image{
    return [self makeToast:message
                     title:title
                     image:image
                  duration:[SLUIConfig share].toastManager.duration
                  position:[SLUIConfig share].toastManager.position
             imagePosition:[SLUIConfig share].toastManager.imagePosition
                     style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    title:(NSString *)title
                    image:(UIImage *)image
                 duration:(NSTimeInterval)duration{
    return [self makeToast:message
                     title:title
                     image:image
                  duration:duration
                  position:[SLUIConfig share].toastManager.position
             imagePosition:[SLUIConfig share].toastManager.imagePosition
                     style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    title:(NSString *)title
                    image:(UIImage *)image
                 duration:(NSTimeInterval)duration
                 position:(SLToastPositon)position{
    return [self makeToast:message
                     title:title
                     image:image
                  duration:duration
                  position:position
             imagePosition:[SLUIConfig share].toastManager.imagePosition
                     style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    title:(NSString *)title
                    image:(UIImage *)image
                 duration:(NSTimeInterval)duration
                 position:(SLToastPositon)position
            imagePosition:(SLToastImagePositon)imagePosition{
    return [self makeToast:message
                     title:title
                     image:image
                  duration:duration
                  position:position
             imagePosition:imagePosition
                     style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    title:(NSString *)title
                    image:(UIImage *)image
                 duration:(NSTimeInterval)duration
                 position:(SLToastPositon)position
            imagePosition:(SLToastImagePositon)imagePosition
                    style:(SLToastStyle *)style{
    return [[self alloc] makeToast:message
                             title:title
                             image:image
                          duration:duration
                          position:position
                     imagePosition:imagePosition
                             style:style];
}
- (instancetype)makeToast:(NSString *)message
                    title:(NSString *)title
                    image:(UIImage *)image
                 duration:(NSTimeInterval)duration
                 position:(SLToastPositon)position
            imagePosition:(SLToastImagePositon)imagePosition
                    style:(SLToastStyle *)style{
    if (self == [super init]) {
        [self getToastView:message
                     title:title
                     image:image
                  duration:(NSTimeInterval)duration
                  position:position
             imagePosition:imagePosition
                     style:style];
    }
    return self;
}
- (void)hideToast{

}
+ (void)hideAllToasts{
}
+ (void)makeToastActivity:(SLToastPositon)position{
}
+ (void)hideToastActivity{
}

- (UIView *)getToastView:(NSString *)message
                   title:(NSString *)title
                   image:(UIImage *)image
                duration:(NSTimeInterval)duration
                position:(SLToastPositon)position
           imagePosition:(SLToastImagePositon)imagePosition
                   style:(SLToastStyle *)style {
    if ([NSString emptyString:message] && [NSString emptyString:title] && !image) return nil;
    if (position < 0) position = SLToastPositonMiddle;
    if (!style) style = [SLUIConfig share].toastStyle;
    UIEdgeInsets contentInsets = style.contentInsets;
    CGFloat startX = contentInsets.left;
    CGFloat startY = contentInsets.top;
    CGFloat endX = style.width - contentInsets.right;
    CGFloat endY = contentInsets.top;
    UIView *copyView = style.wraperView;
    UIView *contentView = [UIView copyView:copyView];
    CGSize imageSize = style.imageSize;
    if (image && imagePosition == SLToastImagePositonTop) {// 如果图片放顶部，先放置好图片
        CGRect imageFrame = CGRectMake(style.width/2.0-imageSize.width/2.0, startY, imageSize.width, imageSize.height);
        SLImageView *imageView = [[SLImageView alloc]initWithFrame:imageFrame];
        [imageView sl_setImage:image];
        imageView.tag = imageViewTag;
        [contentView addSubview:imageView];
        startY += imageSize.height;
    }
    
    if (image && imagePosition == SLToastImagePositonLeft) {
        CGRect imageFrame = CGRectMake(startX, startY, imageSize.width, imageSize.height);
        SLImageView *imageView = [[SLImageView alloc]initWithFrame:imageFrame];
        [imageView sl_setImage:image];
        imageView.tag = imageViewTag;
        [contentView addSubview:imageView];
        startX += imageSize.width+style.imageAndTitleSpace;
    }
    CGFloat textWidth = 0;
    CGFloat textHeight = 0;
    if (![NSString emptyString:title]) {
        if (image && imagePosition == SLToastImagePositonTop) startY+=style.imageAndTitleSpace;
        CGFloat space = 0;
        if (image && imagePosition == SLToastImagePositonRight) space += imageSize.width+style.imageAndTitleSpace;
        SLLabel *titleLabel = [UIView copyView:[SLUIConfig share].toastStyle.titleLabel];
        titleLabel.tag = titleLabelTag;
        CGSize titleSize = [title sizeWithFont:titleLabel.font size:CGSizeMake(endX-startX-space, MAXFLOAT)];
        titleLabel.frame = CGRectMake(startX, startY, titleSize.width, titleSize.height);
        titleLabel.text = title;
        [contentView addSubview:titleLabel];
        startY+=titleSize.height;
        textHeight += titleSize.height;
        textWidth=titleSize.width;
    }
    if (![NSString emptyString:message]) {
        CGFloat space = 0;
        if (image && imagePosition == SLToastImagePositonRight) space += imageSize.width+style.imageAndTitleSpace;
        SLLabel *messageLabel = [UIView copyView:[SLUIConfig share].toastStyle.messageLabel];
        messageLabel.tag = messageLabelTag;
        CGFloat titleSpace = [NSString emptyString:title] ? 0 : style.titleSpace;
        startY += titleSpace;
        CGSize messageSize = [message sizeWithFont:messageLabel.font size:CGSizeMake(endX-startX-space, MAXFLOAT)];
        messageLabel.frame = CGRectMake(startX, startY, messageSize.width, messageSize.height);
        messageLabel.text = message;
        [contentView addSubview:messageLabel];
        textWidth = MAX(messageSize.width, textWidth) ;
        startY+=messageSize.height;
        textHeight += messageSize.height+titleSpace;
    }
    startX += textWidth;
    startY += contentInsets.bottom;
    if (image) {
        BOOL emptyString = [NSString emptyString:title] && [NSString emptyString:message];
        CGRect imageFrame;
        switch (imagePosition) {
            case SLToastImagePositonBottom:
            {
                startY += emptyString ? 0 : style.imageAndTitleSpace;
                startY -= contentInsets.bottom;
                imageFrame = CGRectMake(style.width/2.0-imageSize.width/2.0, startY, imageSize.width, imageSize.height);
                SLImageView *imageView = [[SLImageView alloc]initWithFrame:imageFrame];
                [imageView sl_setImage:image];
                imageView.tag = imageViewTag;
                [contentView addSubview:imageView];
                startY+= imageSize.height + contentInsets.bottom;
            }
                break;
            case SLToastImagePositonLeft:
            {
                UIView *tagImageView = [contentView viewWithTag:imageViewTag];
                if ([tagImageView isKindOfClass:[SLImageView class]]) {
                    SLImageView *imageView = (SLImageView *)tagImageView;
                    if (imageSize.height > startY-contentInsets.top-contentInsets.bottom) {
                        CGFloat scale = imageSize.height / textHeight;
                        [self adjustLabelFrame:scale contentView:contentView style:style];
                        startY = imageSize.height + contentInsets.top + contentInsets.bottom;
                    }
                    imageView.sl_y = startY/2.0-imageView.sl_height/2.0;
                    if (emptyString) imageView.sl_x = style.width/2.0-imageSize.width/2.0;
                }
            }
                break;
            case SLToastImagePositonRight:
            {
                if (imageSize.height > startY-contentInsets.top-contentInsets.bottom) {
                    CGFloat scale = imageSize.height / textHeight;
                    [self adjustLabelFrame:scale contentView:contentView style:style];
                    startY = imageSize.height + contentInsets.top + contentInsets.bottom;
                }
                CGFloat imageAndTitleSpace = emptyString ? 0 : style.imageAndTitleSpace;
                startX = endX - imageSize.width;
                imageFrame = CGRectMake(emptyString ? (style.width/2.0-imageSize.width/2.0) : startX, startY/2.0-imageSize.height/2.0, imageSize.width, imageSize.height);
                SLImageView *imageView = [[SLImageView alloc]initWithFrame:imageFrame];
                [imageView sl_setImage:image];
                imageView.tag = imageViewTag;
                [contentView addSubview:imageView];
                startX+=imageAndTitleSpace+imageSize.width+contentInsets.right;
            }
                break;
            default:
                break;
        }
    }
    SLView *wraperView = [[SLView alloc]initWithFrame:style.superContentView.bounds];
    wraperView.backgroundColor = style.backgroundColor;
    [style.superContentView addSubview:wraperView];
    [wraperView addSubview:contentView];
    if (position == SLToastPositonTop) {
        contentView.frame = CGRectMake(wraperView.sl_width/2.0-style.width/2.0, style.wraperViewSpace, style.width, startY);
    } else if (position == SLToastPositonBottom) {
        contentView.frame = CGRectMake(wraperView.sl_width/2.0-style.width/2.0, wraperView.sl_height-startY-style.wraperViewSpace, style.width, startY);
    } else {
        contentView.frame = CGRectMake(wraperView.sl_width/2.0-style.width/2.0, wraperView.sl_height/2.0-startY/2.0, style.width, startY);
    }
    [contentView addCornerRadius:style.wraperViewRadius shadowColor:style.wraperViewShadowColor shadowOffset:style.wraperViewShadowOffset shadowOpacity:style.wraperViewShadowOpacity shadowRadius:style.wraperViewShadowRadius];
    if (duration > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wraperView removeFromSuperview];
        });
    }
    return style.superContentView;
}

- (void)adjustLabelFrame:(CGFloat)scale contentView:(UIView *)contentView style:(SLToastStyle *)style{
    CGFloat offset_y = 0;
    UIView *tagTitleLabel = [contentView viewWithTag:titleLabelTag];
    if ([tagTitleLabel isKindOfClass:[SLLabel class]]) {
        SLLabel *label = (SLLabel *)tagTitleLabel;
        offset_y = (scale-1)*(label.sl_height+style.titleSpace);
        label.sl_height *= scale;
    }
    UIView *tagmessageLabel = [contentView viewWithTag:messageLabelTag];
    if ([tagmessageLabel isKindOfClass:[SLLabel class]]) {
        SLLabel *label = (SLLabel *)tagmessageLabel;
        label.sl_y += offset_y;
        label.sl_height *= scale;
    }
}
@end
