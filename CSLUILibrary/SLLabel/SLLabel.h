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
/**
 图文混合类型的frame必须相对内容本身设置足够大，才会显示出来。内部会对多余的frame大小进行更新
 */

@interface SLLabel : UILabel
@property (nonatomic, assign) LabelType labelType;
- (CGRect)getContentRect;
@end

NS_ASSUME_NONNULL_END
