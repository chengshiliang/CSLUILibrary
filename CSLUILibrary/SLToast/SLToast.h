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
    SLToastPositonBottom = 2
};
typedef NS_ENUM (NSInteger, SLToastImagePositon) {
    SLToastImagePositonLeft = 0,
    SLToastImagePositonTop = 1,
    SLToastImagePositonBottom = 2,
    SLToastImagePositonRight = 3
};
@interface SLToastStyle : NSObject
@property (strong, nonatomic) SLView *superContentView;// 父容器。默认为windows
@property (strong, nonatomic) UIColor *backgroundColor;// toast背景色
@property (strong, nonatomic) SLLabel *titleLabel;// toast标题框
@property (strong, nonatomic) SLLabel *messageLabel;// toast信息框
@property (assign, nonatomic) CGFloat width;// toast 的宽度
@property (assign, nonatomic) UIEdgeInsets contentInsets;// toast 的内边距
@property (strong, nonatomic) SLView *wraperView;// toast的内容视图
@property (assign, nonatomic) CGFloat wraperViewSpace;// toast的内容视图到父容器的间距，SLToastPositonTop、SLToastPositonBottom对应的上、下两侧距离
@property (assign, nonatomic) CGFloat wraperViewRadius;// toast的内容视图倒角
@property (strong, nonatomic) UIColor *wraperViewShadowColor;// toast的内容视图的阴影颜色
@property (assign, nonatomic) CGSize wraperViewShadowOffset;// toast的内容视图的阴影偏移量
@property (assign, nonatomic) CGFloat wraperViewShadowOpacity;// toast的内容视图的阴影透明度
@property (assign, nonatomic) CGFloat wraperViewShadowRadius;// toast的内容视图的阴影倒角
@property (assign, nonatomic) CGSize imageSize;// toast图片大小
@property (assign, nonatomic) CGFloat imageAndTitleSpace;// 图片和文字的间隔
@property (assign, nonatomic) CGFloat titleSpace;// title 和 message的间隔
@property (assign, nonatomic) CGSize activitySize;// toast加载activity的大小
@end

@interface SLToastManager : NSObject
@property (nonatomic, assign) NSTimeInterval duration;// 默认两秒
@property (nonatomic, assign) SLToastPositon position;// 默认居中
@property (nonatomic, assign) SLToastImagePositon imagePosition;// 默认图片在左侧居中
@property (nonatomic, assign) NSInteger maxCount;// 默认为1
@end

#warning 图片要支持gif格式
@interface SLToast : NSObject
+ (instancetype)makeToast:(NSString *_Nullable)message;
+ (instancetype)makeToast:(NSString *_Nullable)message
                    title:(NSString *_Nullable)title;
+ (instancetype)makeToast:(NSString *_Nullable)message
                    image:(UIImage *_Nullable)image;
+ (instancetype)makeToast:(NSString *_Nullable)message
                    title:(NSString *_Nullable)title
                    image:(UIImage *_Nullable)image;
+ (instancetype)makeToast:(NSString *_Nullable)message
                    title:(NSString *_Nullable)title
                    image:(UIImage *_Nullable)image
                 duration:(NSTimeInterval)duration;
+ (instancetype)makeToast:(NSString *_Nullable)message
                    title:(NSString *_Nullable)title
                    image:(UIImage *_Nullable)image
                 duration:(NSTimeInterval)duration
                 position:(SLToastPositon)position;
+ (instancetype)makeToast:(NSString *_Nullable)message
                    title:(NSString *_Nullable)title
                    image:(UIImage *_Nullable)image
                 duration:(NSTimeInterval)duration
                 position:(SLToastPositon)position
            imagePosition:(SLToastImagePositon)imagePosition;
+ (instancetype)makeToast:(NSString *_Nullable)message
                    title:(NSString *_Nullable)title
                    image:(UIImage *_Nullable)image
                 duration:(NSTimeInterval)duration
                 position:(SLToastPositon)position
            imagePosition:(SLToastImagePositon)imagePosition
                    style:(SLToastStyle *_Nullable)style;
- (void)hideToast;
+ (void)hideAllToasts;
+ (void)makeToastActivity:(SLToastPositon)position;
+ (void)hideToastActivity;
@end

NS_ASSUME_NONNULL_END
