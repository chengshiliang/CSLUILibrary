//
//  SLUtil.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLLabel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLUtil : NSObject
+ (UIFont *)fontSize:(LabelType)type;
+ (UIColor *)color:(LabelType)type;
@end

NS_ASSUME_NONNULL_END
