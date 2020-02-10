//
//  SLNoticeBar.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/16.
//

#import "SLNoticeBar.h"
#import <CSLUtils/NSString+Util.h>
#import <CSLUtils/UIView+SLBase.h>
#import <CSLUILibrary/SLImageView.h>
#import <CSLUtils/SLUIConsts.h>
#import <CSLCommonLibrary/SLTimer.h>

@interface SLNoticeBar()
{
    SLTimer *_timer;
}
@property (nonatomic, assign) CGFloat currentX;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation SLNoticeBar

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.loop = YES;
    self.speed = 10.0;
    self.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.textField = [[UITextField alloc]init];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.placeholder = @"";
    self.textField.enabled = NO;
    self.textField.clearButtonMode = UITextFieldViewModeNever;
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (void)show {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:self.textField];
    self.textField.text = self.content;
    CGFloat startX = 0;
    if (self.contentInset.left > 0) {
        SLView *leftView = [[SLView alloc]initWithFrame:CGRectMake(0, 0, self.contentInset.left, self.sl_height)];
        leftView.backgroundColor = self.backColor ? self.backColor : SLUIHexColor(0xFDFCEB);
        [self addSubview:leftView];
        startX += self.contentInset.left;
    }
    if (self.leftImage) {
        SLImageView *imageView = [[SLImageView alloc]initWithFrame:CGRectMake(startX, self.contentInset.top, self.sl_height-self.contentInset.top-self.contentInset.bottom, self.sl_height-self.contentInset.top-self.contentInset.bottom)];
        [imageView sl_setImage:self.leftImage];
        imageView.backgroundColor = self.backColor ? self.backColor : SLUIHexColor(0xFDFCEB);
        [self addSubview:imageView];
        startX += imageView.sl_width;
    }
    CGFloat endX = self.sl_width;
    if (self.contentInset.right > 0) {
        SLView *rightView = [[SLView alloc]initWithFrame:CGRectMake(endX-self.contentInset.right, 0, endX-self.contentInset.right, self.sl_height)];
        rightView.backgroundColor = self.backColor ? self.backColor : SLUIHexColor(0xFDFCEB);
        [self addSubview:rightView];
        endX -= self.contentInset.right;
    }
    if (self.rightView) {
        self.rightView.sl_x = endX-self.rightView.sl_width;
        self.rightView.sl_y = self.contentInset.top;
        self.rightView.sl_height = self.sl_height-self.contentInset.top-self.contentInset.bottom;
        [self addSubview:self.rightView];
        self.rightView.backgroundColor = self.backColor ? self.backColor : SLUIHexColor(0xFDFCEB);
        endX = self.rightView.sl_x;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    self.currentX = 0;
    self.textField.transform = CGAffineTransformMakeTranslation(self.currentX, 0);
    if ([NSString emptyString:self.textField.text]) {
        self.textField.frame = CGRectZero;
    } else {
        self.textField.textColor = self.textColor ? self.textColor: SLUIHexColor(0xF66F2D);
        self.textField.font = self.textFont ? self.textFont : SLUINormalFont(12.0);
        CGSize size = [self.textField.text sizeWithFont:self.textField.font size:CGSizeMake(MAXFLOAT, self.sl_height-self.contentInset.top-self.contentInset.bottom)];
        self.textField.frame = CGRectMake(startX, self.contentInset.top, size.width, self.sl_height-self.contentInset.top-self.contentInset.bottom);
        if (self.loop && size.width > endX-startX) {
            WeakSelf;
            self.speed = MAX(1.0, self.speed);
            _timer = [SLTimer sl_timerWithTimeInterval:self.speed/60.0 target:self userInfo:nil repeats:YES mode:NSRunLoopCommonModes callback:^(NSArray * _Nonnull array) {
                StrongSelf;
                if (strongSelf.textField.sl_width - strongSelf.currentX < endX-startX) {
                    strongSelf.currentX = 0;
                } else {
                    strongSelf.currentX += strongSelf.speed;
                }
                strongSelf.textField.transform = CGAffineTransformMakeTranslation(-strongSelf.currentX, 0);
            }];
        }
    }
    self.clipsToBounds = YES;
    self.backgroundColor = self.backColor ? self.backColor : SLUIHexColor(0xFDFCEB);
}

- (void)hide {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
