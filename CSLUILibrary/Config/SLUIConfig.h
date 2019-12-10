//
//  SLUIConfig.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLLabel.h>
#import <CSLUILibrary/SLAlertView.h>
#import <CSLUILibrary/SLToast.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLUIConfig : NSObject
@property (nonatomic, readonly, copy) NSDictionary *labelConfig;
@property (nonatomic, readonly, copy) NSDictionary *alertConfig;
@property (nonatomic, strong, readonly) SLToastManager *toastManager;
@property (nonatomic, strong, readonly) SLToastStyle *toastStyle;
+ (instancetype)share;
- (void)configLabel:(LabelType)type font:(UIFont * _Nullable)fontSize color:(UIColor * _Nullable)color;
/**
 全局配置SLAlertView
 * width: alertview的宽度
 * inset：内部视图的内边距
 */
- (void)configAlert:(AlertType)type width:(CGFloat)width inset:(UIEdgeInsets)inset;
/**
 全局配置SLToast
 * duration: toast时常
 * position: toast位置
 */
- (void)configToastDuration:(NSTimeInterval)duration position:(SLToastPositon)position;
/**
 全局配置SLToast的style
 * style: 样式
 */
- (void)configToastStyle:(SLToastStyle *)style;
/**
 * 自定义字体和颜色，type应不包含 LabelType 范围内的数字
 */
- (void)selfConfigLabel:(NSUInteger)type font:(UIFont * _Nullable)fontSize color:(UIColor * _Nullable)color;
@end

NS_ASSUME_NONNULL_END
