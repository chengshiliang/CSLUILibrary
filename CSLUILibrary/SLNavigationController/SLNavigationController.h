//
//  SLNavigationController.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLNavigationController : UINavigationController
- (void)sl_setTransluentNavBar;
- (void)sl_setBackgroundImage:(UIImage *)image;
- (void)sl_setBackgroundImage:(UIImage *)image barMetrics:(UIBarMetrics)barMetrics;
- (void)sl_setBackImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
