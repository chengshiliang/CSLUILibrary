//
//  SLAlertView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/4.
//

#import "SLAlertView.h"
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLUIConfig.h>
#import <CSLUILibrary/SLUIConst.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLLabel.h>
#import <CSLUILibrary/SLImageView.h>

@interface SLAlertView()<SLAlertTitleProtocol, SLAlertTitleLineProtocol, SLAlertMessageProtocol>
{
    UIEdgeInsets _contentInsets;
}
@property (nonatomic, assign) AlertType type;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) UIEdgeInsets messageInsets;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat originX;
@end

@implementation SLAlertView

- (instancetype)initWithType:(AlertType)type
                       title:(NSString *)title
                  titleModel:(id<SLAlertTitleProtocol> _Nullable)titleModel
              titleLineModel:(id<SLAlertTitleLineProtocol> _Nullable)titleLineModel
                     message:(NSString *)message
                messageModel:(id<SLAlertMessageProtocol> _Nullable)messageModel {
    if (self == [super init]) {
        self.type = type;
        NSDictionary *dic = [[SLUIConfig share].alertConfig valueForKey:[NSString stringWithFormat:@"%ld", type]];
        self.width = [[dic valueForKey:SLAlertWidth] floatValue];
        UIEdgeInsets contentInsets = UIEdgeInsetsFromString([dic valueForKey:SLAlertContentInset]);
        _contentInsets = contentInsets;
        self.originX = contentInsets.left;
        self.height = contentInsets.top;
        self.contentWidth = self.width - contentInsets.left-contentInsets.right;
        if (![NSString emptyString:title]) {
            SLLabel *titleLabel = [[SLLabel alloc]init];
            titleLabel.numberOfLines = 0;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            if (titleModel && [titleModel conformsToProtocol:@protocol(SLAlertTitleProtocol)]) {
                titleLabel.font = [titleModel titleFont];
                titleLabel.textColor = [titleModel titleColor];
            } else {
                titleLabel.font = [self titleFont];
                titleLabel.textColor = [self titleColor];
            }
            CGSize titleSize = [title sizeWithFont:titleLabel.font size:CGSizeMake(self.contentWidth, MAXFLOAT)];
            titleLabel.frame = CGRectMake(self.originX, self.height, self.contentWidth, ceil(titleSize.height));
            titleLabel.text = title;
            [self addSubview:titleLabel];
            self.height = CGRectGetMaxY(titleLabel.frame);
            self.height += contentInsets.top;
            SLView *titleLineView = [[SLView alloc]init];
            if (titleLineModel && [titleLineModel conformsToProtocol:@protocol(SLAlertTitleLineProtocol)]) {
                titleLineView.backgroundColor = [titleLineModel lineViewBackcolor];
                titleLineView.frame = CGRectMake([titleLineModel lineViewLeftMargin], self.height, self.width-[titleLineModel lineViewLeftMargin]-[titleLineModel lineViewRightMargin], 0.5);
            } else {
                titleLineView.backgroundColor = [self lineViewBackcolor];
                titleLineView.frame = CGRectMake([self lineViewLeftMargin], self.height, self.width-[self lineViewLeftMargin]-[self lineViewRightMargin], 0.5);
            }
            [self addSubview:titleLineView];
            self.height += titleLineView.frame.size.height;
        }
        self.messageInsets = UIEdgeInsetsFromString([dic valueForKey:SLAlertMessageInset]);
        if (![NSString emptyString:message]) {
            self.height += self.messageInsets.top;
            SLLabel *messageLabel = [[SLLabel alloc]init];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentLeft;
            if (messageModel && [messageModel conformsToProtocol:@protocol(SLAlertMessageProtocol)]) {
                messageLabel.font = [messageModel messageFont];
                messageLabel.textColor = [messageModel messageColor];
            } else {
                messageLabel.font = [self messageFont];
                messageLabel.textColor = [self messageColor];
            }
            CGSize messageSize = [message sizeWithFont:messageLabel.font size:CGSizeMake(self.contentWidth, MAXFLOAT)];
            messageLabel.frame = CGRectMake(self.originX+self.messageInsets.left, self.height, self.contentWidth-self.messageInsets.left-self.messageInsets.right, ceil(messageSize.height));
            messageLabel.text = title;
            [self addSubview:messageLabel];
            self.height += messageLabel.frame.size.height + self.messageInsets.bottom;
        }
        self.frame = CGRectMake(kScreenWidth/2.0-self.width/2.0, kScreenHeight/2.0-self.height/2.0, self.width, self.height);
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)show {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = SLUIHexAlphaColor(0xffffff, 0.3);
    [backView addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    CGFloat cornerRadius = MAX(0, MAX(_contentInsets.left, MAX(_contentInsets.bottom, MAX(_contentInsets.top, _contentInsets.right))));
    [self addCornerRadius:cornerRadius];
}

- (UIFont *)titleFont {
    return SLUIBoldFont(17.0);
}

- (UIColor *)titleColor {
    return SLUIHexColor(0x333333);
}

- (UIFont *)messageFont {
    return SLUINormalFont(14.0);
}

- (UIColor *)messageColor {
    return SLUIHexColor(0x666666);
}

- (UIColor *)lineViewBackcolor {
    return SLUIHexColor(0x000000);
}

- (CGFloat)lineViewLeftMargin {
    return 0;
}

- (CGFloat)lineViewRightMargin {
    return 0;
}
@end
