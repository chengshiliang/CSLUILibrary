//
//  SLUIConst.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN const NSString *const SLLabelFontSize;
UIKIT_EXTERN const NSString *const SLLabelColor;
UIKIT_EXTERN const NSString *const SLAlertWidth;
UIKIT_EXTERN const NSString *const SLAlertContentInset;
UIKIT_EXTERN const NSString *const SLAlertMessageInset;
typedef NS_ENUM(NSInteger, SLViewDirection) {
    Horizontal,// 横向
    Vertical,// 纵向
};
@interface SLUIConst : NSObject

@end

NS_ASSUME_NONNULL_END
