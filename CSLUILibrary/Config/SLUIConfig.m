//
//  SLUIConfig.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import "SLUIConfig.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLUIConst.h>
#import <CSLUILibrary/SLUtil.h>

@interface SLUIConfig()
@property (nonatomic, strong) NSMutableDictionary *labelConfigDicM;
@property (nonatomic, strong) NSMutableDictionary *alertConfigDicM;
@end

@implementation SLUIConfig

static SLUIConfig *instance;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SLUIConfig alloc]init];
        instance.labelConfigDicM = [NSMutableDictionary dictionary];
        instance.alertConfigDicM = [NSMutableDictionary dictionary];
    });
    return instance;
}

- (void)configAlert:(AlertType)type width:(CGFloat)width inset:(UIEdgeInsets)inset{
    NSNumber *contentWidth = width > 0 ? @(width) : (type == AlertView ? @(kScreenWidth * 0.85) : @(kScreenWidth * 0.95));
    NSString *contentInsets = NSStringFromUIEdgeInsets(inset);
    NSDictionary *dic = @{SLAlertWidth: contentWidth,SLAlertContentInset: contentInsets};
    [instance.alertConfigDicM setValue:dic forKey:[NSString stringWithFormat:@"%ld", (long)type]];
}

- (NSDictionary *)alertConfig {
    return [instance.alertConfigDicM copy];
}

- (void)configLabel:(LabelType)type font:(UIFont *_Nullable)fontSize color:(UIColor *_Nullable)color {
    UIFont *tempFont = fontSize;
    if (!tempFont) {
        tempFont = [SLUtil fontSize:type];
    }
    UIColor *tempColor = color;
    if (!color) {
        tempColor = [SLUtil color:type];
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
@end
