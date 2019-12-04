//
//  SLAlertProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLAlertTitleLineProtocol <NSObject>

- (UIColor *)lineViewBackcolor;
- (CGFloat)lineViewLeftMargin;
- (CGFloat)lineViewRightMargin;

@end

@protocol SLAlertMessageProtocol <NSObject>

- (UIColor *)messageColor;
- (UIFont *)messageFont;

@end

@protocol SLAlertTitleProtocol <NSObject>

- (UIColor *)titleColor;
- (UIFont *)titleFont;

@end

@protocol SLAlertProtocol <NSObject>

@end

NS_ASSUME_NONNULL_END
