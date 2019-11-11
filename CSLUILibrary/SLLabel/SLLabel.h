//
//  SLLabel.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LabelType){
    LabelH1 = 1,// h1
    LabelH2 = 2,// h2
    LabelH3 = 3,// h3
    LabelH4 = 4,// h4
    LabelH5 = 5,// h5
    LabelH6 = 6,// h6
    LabelBold = 7,// 加粗
    LabelNormal = 0,// 正常大小
    LabelSelect = 8,// 稍微暗点
    LabelDisabel = 9// 置灰
};

NS_ASSUME_NONNULL_BEGIN

@interface SLLabel : UILabel
@property (nonatomic, assign) double lineHeight;// 图文显示总高度
@property (nonatomic, assign) LabelType labelType;
@property (nonatomic, strong) NSMutableAttributedString *attributeString;
- (CGRect)getContentRect;
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
