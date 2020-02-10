//
//  SLAlertConfig.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/10.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLAlertView.h>

UIKIT_EXTERN const NSString *_Nonnull const SLAlertWidth;
UIKIT_EXTERN const NSString *_Nonnull const SLAlertContentInset;

NS_ASSUME_NONNULL_BEGIN
@interface SLAlertConfig : NSObject
@property (nonatomic, readonly, copy) NSDictionary *alertConfig;
+ (instancetype)share;
/**
 全局配置SLAlertView
 * width: alertview的宽度
 * inset：内部视图的内边距
 */
- (void)configAlert:(AlertType)type width:(CGFloat)width inset:(UIEdgeInsets)inset;
@end

NS_ASSUME_NONNULL_END
