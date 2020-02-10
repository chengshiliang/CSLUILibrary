//
//  SLLabel.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import <UIKit/UIKit.h>
#import <CSLUtils/SLUIConst.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLLabel : UILabel
@property (nonatomic, assign) LabelType labelType;
- (CGRect)getContentRect;
@end

NS_ASSUME_NONNULL_END
