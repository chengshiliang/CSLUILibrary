//
//  SLUIConfig.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLLabel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLUIConfig : NSObject
@property (nonatomic, readonly, copy) NSDictionary *labelConfig;
+ (instancetype)share;
- (void)configLabel:(LabelType)type font:(UIFont * _Nullable)fontSize color:(UIColor * _Nullable)color;
@end

NS_ASSUME_NONNULL_END
