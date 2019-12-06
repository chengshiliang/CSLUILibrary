//
//  SLToast.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/6.
//

#import "SLToast.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLUIConfig.h>

@implementation SLToastManager
- (NSTimeInterval)duration {
    if (_duration <= 0) {
        return 2.0f;
    }
    return _duration;
}
- (SLToastPositon)position {
    return _position;
}
- (NSInteger)maxCount {
    if (_maxCount <= 0) {
        return 10000;
    }
    return _maxCount;
}
@end

@implementation SLToastStyle
- (UIColor *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _backgroundColor;
}
- (SLLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SLLabel alloc]init];
        _titleLabel.font = SLUINormalFont(17.0);
        _titleLabel.textColor = SLUIHexColor(0xffffff);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (SLLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[SLLabel alloc]init];
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
- (UIEdgeInsets)contentInsets {
    if ([NSStringFromUIEdgeInsets(_contentInsets) isEqualToString:NSStringFromUIEdgeInsets(UIEdgeInsetsZero)]) {
        _contentInsets = UIEdgeInsetsMake(10, 8, 10, 8);
    }
    return _contentInsets;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[SLView alloc]init];
        [_contentView addCornerRadius:5.0f shadowColor:SLUIHexColor(0x000000) shadowOffset:CGSizeZero shadowOpacity:0.5 shadowRadius:5.0f];
    }
    return _contentView;
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

@implementation SLToast
+ (instancetype)makeToast:(NSString *)message {
    return [self makeToast:message title:@"" image:nil duration:[SLUIConfig share].toastManager.duration position:[SLUIConfig share].toastManager.position style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    title:(NSString *)title{
    return [self makeToast:message title:title image:nil duration:[SLUIConfig share].toastManager.duration position:[SLUIConfig share].toastManager.position style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    image:(UIImage *)image {
    return [self makeToast:message title:@"" image:image duration:[SLUIConfig share].toastManager.duration position:[SLUIConfig share].toastManager.position style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    title:(NSString *)title
                    image:(UIImage *)image{
    return [self makeToast:message title:title image:image duration:[SLUIConfig share].toastManager.duration position:[SLUIConfig share].toastManager.position style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
                    title:(NSString *)title
                    image:(UIImage *)image
                 duration:(NSTimeInterval)duration{
    return [self makeToast:message title:title image:image duration:duration position:[SLUIConfig share].toastManager.position style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
            title:(NSString *)title
            image:(UIImage *)image
         duration:(NSTimeInterval)duration
         position:(SLToastPositon)position{
    return [self makeToast:message title:title image:image duration:duration position:position style:[SLUIConfig share].toastStyle];
}
+ (instancetype)makeToast:(NSString *)message
            title:(NSString *)title
            image:(UIImage *)image
         duration:(NSTimeInterval)duration
         position:(SLToastPositon)position
            style:(SLToastStyle *)style{
    
    return nil;
}
- (void)hideToast{
}
+ (void)hideAllToasts{
}
+ (void)makeToastActivity:(SLToastPositon)position{
}
+ (void)hideToastActivity{
}
@end
