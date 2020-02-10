//
//  SLLableConfig.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/10.
//

#import "SLLableConfig.h"
#import <CSLCommonLibrary/SLUIConsts.h>

const NSString *const SLLabelFontSize = @"fontSize";
const NSString *const SLLabelColor = @"color";

@interface SLLableConfig()
@property (nonatomic, strong) NSMutableDictionary *labelConfigDicM;
@end
@implementation SLLableConfig
static SLLableConfig *instance;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SLLableConfig alloc]init];
        instance.labelConfigDicM = [NSMutableDictionary dictionary];
    });
    return instance;
}
- (void)configLabel:(LabelType)type font:(UIFont *_Nullable)fontSize color:(UIColor *_Nullable)color {
    UIFont *tempFont = fontSize;
    if (!tempFont) {
        tempFont = [SLLableConfig fontSize:type];
    }
    UIColor *tempColor = color;
    if (!color) {
        tempColor = [SLLableConfig color:type];
    }
    NSDictionary *dic = @{SLLabelFontSize: tempFont,SLLabelColor: tempColor};
    [instance.labelConfigDicM setValue:dic forKey:[NSString stringWithFormat:@"%ld", (long)type]];
}

- (void)selfConfigLabel:(NSUInteger)type font:(UIFont *)fontSize color:(UIColor *)color {
    if (type <= 9) {
        [self configLabel:type font:fontSize color:color];
        return;
    }
    NSAssert(fontSize, @"you should set font size not null");
    NSAssert(color, @"you should set color not null");
    NSDictionary *dic = @{SLLabelFontSize: fontSize,SLLabelColor: color};
    [instance.labelConfigDicM setValue:dic forKey:[NSString stringWithFormat:@"%ld", (long)type]];
}

- (NSDictionary *)labelConfig {
    return [instance.labelConfigDicM copy];
}

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
