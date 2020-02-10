//
//  SLAlertConfig.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/10.
//

#import "SLAlertConfig.h"
#import <CSLCommonLibrary/SLUtil.h>
#import <CSLCommonLibrary/SLUIConsts.h>

const NSString *const SLAlertWidth = @"alertWidth";
const NSString *const SLAlertContentInset = @"alertContentInset";

@interface SLAlertConfig()
@property (nonatomic, strong) NSMutableDictionary *alertConfigDicM;
@end

@implementation SLAlertConfig
static SLAlertConfig *instance;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SLAlertConfig alloc]init];
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
@end
