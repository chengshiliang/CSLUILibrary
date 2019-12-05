//
//  SLAlertProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLAlertActionProtocol <NSObject>
@optional
- (UIColor *)actionTitleColor;
- (UIFont *)actionTitleFont;

@end

@protocol SLAlertLineProtocol <NSObject>
@optional
- (UIColor *)lineViewBackcolor;
- (BOOL)lineShow;
@end

@protocol SLAlertMessageProtocol <NSObject>
@optional
- (UIColor *)messageColor;
- (UIFont *)messageFont;
- (NSTextAlignment)messageTextAlignment;

@end

@protocol SLAlertTitleProtocol <NSObject>
@optional
- (UIColor *)titleColor;
- (UIFont *)titleFont;

@end

@protocol SLAlertProtocol <NSObject>

@end

NS_ASSUME_NONNULL_END
