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
 */
- (void)addAttributeString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;
/**
 * 图文混排，插入文字获取图片等内容
 * width、height 不传默认取图片的宽度和高度
 */
- (void)addAttributeImage:(UIImage *)image;
- (void)addAttributeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height;

- (void)reload;
@end

NS_ASSUME_NONNULL_END
