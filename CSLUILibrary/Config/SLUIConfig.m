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
@end

@implementation SLUIConfig

static SLUIConfig *instance;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SLUIConfig alloc]init];
        instance.labelConfigDicM = [NSMutableDictionary dictionary];
    });
    return instance;
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

- (NSDictionary *)labelConfig {
    return [instance.labelConfigDicM copy];
}
@end
