//
//  SLToastConfig.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/10.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLToast.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLToastConfig : NSObject
@property (nonatomic, strong, readonly) SLToastManager *toastManager;
@property (nonatomic, strong, readonly) SLToastStyle *toastStyle;
+ (instancetype)share;
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
@end

NS_ASSUME_NONNULL_END
