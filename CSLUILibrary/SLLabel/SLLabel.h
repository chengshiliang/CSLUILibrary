//
//  SLLabel.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
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
@interface SLLabel : UILabel
@property (nonatomic, assign) LabelType labelType;
- (CGRect)getContentRect;
@end

NS_ASSUME_NONNULL_END
