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

+ (NSString *)fiterName:(FilterType)type {
    switch (type) {
        case OriginImage:
            return @"OriginImage";
        case CIPhotoEffectMono:
            return @"CIPhotoEffectMono";
        case CIPhotoEffectChrome:
            return @"CIPhotoEffectChrome";
        case CIPhotoEffectFade:
            return @"CIPhotoEffectFade";
        case CIPhotoEffectInstant:
            return @"CIPhotoEffectInstant";
        case CIPhotoEffectNoir:
            return @"CIPhotoEffectNoir";
        case CIPhotoEffectProcess:
            return @"CIPhotoEffectProcess";
        case CIPhotoEffectTonal:
            return @"CIPhotoEffectTonal";
        case CIPhotoEffectTransfer:
            return @"CIPhotoEffectTransfer";
        case CISRGBToneCurveToLinear:
            return @"CISRGBToneCurveToLinear";
        case CIVignetteEffect:
            return @"CIVignetteEffect";
        default:
            break;
    }
}

+ (BOOL)bangsScreen {
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom;
        if (bottomSafeInset > 0) {
            return YES;
        }
    }
    return NO;
}

+ (void)runInMain:(void (^) ())block
{
    if ([[NSThread currentThread] isMainThread]) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (void)runBackground:(void (^) ())block
{
    if ([[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_global_queue(0, 0), block);
    }else {
        block();
    }
}
@end
