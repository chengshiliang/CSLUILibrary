//
//  SLCoreText.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLCoreText : SLLabel
@property (nonatomic, strong) NSMutableAttributedString *attributeString;
@property (nonatomic, copy) void(^lineHeightChange)(double lineHeight);
/**
 * 图文混排，插入文字获取图片等内容
 attributes: 自定义的富文本属性，如下划线等
 string: 兼容\n或\r或\r\n开头或结尾的字符串，对字符串中间包含\n或\r或\r\n的兼容性较差，慎用
 */
- (void)addAttributeString:(NSString *)string
                      font:(UIFont *)font
                     color:(UIColor *)color
                     click:(void(^ _Nullable)(NSString *string))clickBlock;
- (void)addAttributeString:(NSString *)string
                      font:(UIFont *)font
                     color:(UIColor *)color
                attributes:(NSDictionary * _Nullable)attributes
                     click:(void(^)(NSString *string))clickBlock;
/**
 * 图文混排，插入文字获取图片等内容
 * width、height 不传默认取图片的宽度和高度
 */
- (void)addAttributeImage:(UIImage *)image
                    click:(void(^ _Nullable)(UIImage *image))clickBlock;
- (void)addAttributeImage:(UIImage *)image
                    width:(CGFloat)width
                   height:(CGFloat)height
                    click:(void(^ _Nullable)(UIImage *image))clickBlock;

- (void)reload;
@end

NS_ASSUME_NONNULL_END
