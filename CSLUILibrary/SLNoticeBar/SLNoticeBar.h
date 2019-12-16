//
//  SLNoticeBar.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/16.
//

#import "SLView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLNoticeBar : SLView
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, assign) BOOL loop;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGFloat speed; // 计时器时间 speed/60.0,因此speed不能小于1
- (void)addToTargeView:(UIView *)view content:(NSString *)content;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
