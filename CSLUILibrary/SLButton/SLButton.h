//
//  SLButton.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLButton : UIButton
@property (nonatomic, assign) NSTimeInterval eventInterval;
- (void)onTouch:(NSObject *)target event:(UIControlEvents)event change:(void(^)(SLButton *button))changeBlock;
@end

NS_ASSUME_NONNULL_END
