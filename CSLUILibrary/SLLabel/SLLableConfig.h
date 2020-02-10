//
//  SLLableConfig.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/10.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLLabel.h>

UIKIT_EXTERN const NSString *_Nonnull const SLLabelFontSize;
UIKIT_EXTERN const NSString *_Nonnull const SLLabelColor;

NS_ASSUME_NONNULL_BEGIN
@interface SLLableConfig : NSObject
@property (nonatomic, readonly, copy) NSDictionary *labelConfig;
+ (instancetype)share;
- (void)configLabel:(LabelType)type font:(UIFont * _Nullable)fontSize color:(UIColor * _Nullable)color;
/**
 * 自定义字体和颜色，type应不包含 LabelType 范围内的数字
 */
- (void)selfConfigLabel:(NSUInteger)type font:(UIFont * _Nullable)fontSize color:(UIColor * _Nullable)color;
+ (UIFont *)fontSize:(LabelType)type;
+ (UIColor *)color:(LabelType)type;
@end

NS_ASSUME_NONNULL_END
