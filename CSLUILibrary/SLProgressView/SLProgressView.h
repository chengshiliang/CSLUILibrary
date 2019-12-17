//
//  SLProgressView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/17.
//

#import "SLView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLProgressView : SLView
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *trackerColor;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *trackerImage;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) BOOL corners;
@property (nonatomic, assign, getter=currentProgress) CGFloat progress; // 0~1

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
