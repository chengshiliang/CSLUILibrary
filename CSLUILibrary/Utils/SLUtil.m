//
//  SLUtil.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import "SLUtil.h"
#import <CSLUILibrary/SLUIConsts.h>

@implementation SLUtil
+ (UIFont *)fontSize:(LabelType)type {
    switch (type) {
        case LabelH1:
            return SLH1LabelFont;
        case LabelH2:
            return SLH2LabelFont;
        case LabelH3:
            return SLH3LabelFont;
        case LabelH4:
            return SLH4LabelFont;
        case LabelH5:
            return SLH5LabelFont;
        case LabelH6:
            return SLH6LabelFont;
        case LabelBold:
            return SLBoldLabelFont;
        case LabelNormal:
            return SLNormalLabelFont;
        case LabelSelect:
            return SLSelectLabelFont;
        case LabelDisabel:
            return SLDisabelLabelFont;
        default:
            break;
    }
    return SLNormalLabelFont;
}

+ (UIColor *)color:(LabelType)type {
    switch (type) {
        case LabelH1:
            return SLH1LabelColor;
        case LabelH2:
            return SLH2LabelColor;
        case LabelH3:
            return SLH3LabelColor;
        case LabelH4:
            return SLH4LabelColor;
        case LabelH5:
            return SLH5LabelColor;
        case LabelH6:
            return SLH6LabelColor;
        case LabelBold:
            return SLBoldLabelColor;
        case LabelNormal:
            return SLNormalLabelColor;
        case LabelSelect:
            return SLSelectLabelColor;
        case LabelDisabel:
            return SLDisableLabelColor;
        default:
            break;
    }
    return SLNormalLabelColor;
}
@end
