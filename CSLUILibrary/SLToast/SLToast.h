//
//  SLToast.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/6.
//

#import "SLView.h"
#import <CSLUILibrary/SLLabel.h>
#import <CSLUILibrary/SLImageView.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger, SLToastPositon) {
    SLToastPositonMiddle = 0,
    SLToastPositonTop = 1,
    SLToastPositonBottom = 2,
    SLToastPositonOther
};

@interface SLToastStyle : NSObject
@property (strong, nonatomic) UIColor *backgroundColor;// toast背景色
@property (strong, nonatomic) SLLabel *titleLabel;// toast标题框
@property (strong, nonatomic) SLLabel *messageLabel;// toast信息框
@property (assign, nonatomic) CGFloat width;// toast 的宽度
@property (assign, nonatomic) UIEdgeInsets contentInsets;// toast 的内边距
@property (assign, nonatomic) SLView *contentView;// toast的内容视图
@property (assign, nonatomic) CGSize imageSize;// toast图片大小
@property (assign, nonatomic) CGSize activitySize;// toast加载activity的大小
@end

@interface SLToastManager : NSObject
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) SLToastPositon position;
@property (nonatomic, assign) NSInteger maxCount;
@end

@interface SLToast : SLView
+ (instancetype)makeToast:(NSString *)message;
+ (instancetype)makeToast:(NSString *)message
            title:(NSString *)title;
+ (instancetype)makeToast:(NSString *)message
            image:(UIImage *)image;
+ (instancetype)makeToast:(NSString *)message
            title:(NSString *)title
            image:(UIImage *)image;
+ (instancetype)makeToast:(NSString *)message
            title:(NSString *)title
            image:(UIImage *)image
         duration:(NSTimeInterval)duration;
+ (instancetype)makeToast:(NSString *)message
            title:(NSString *)title
            image:(UIImage *)image
         duration:(NSTimeInterval)duration
         position:(SLToastPositon)position;
+ (instancetype)makeToast:(NSString *)message
            title:(NSString *)title
            image:(UIImage *)image
         duration:(NSTimeInterval)duration
         position:(SLToastPositon)position
            style:(SLToastStyle *)style;
- (void)hideToast;
+ (void)hideAllToasts;
+ (void)makeToastActivity:(SLToastPositon)position;
+ (void)hideToastActivity;
@end

NS_ASSUME_NONNULL_END
