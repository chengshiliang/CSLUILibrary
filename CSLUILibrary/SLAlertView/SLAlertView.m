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
#import <CSLUILibrary/SLTabbarView.h>
#import <CSLUILibrary/SLTabbarButton.h>
#import <Masonry/Masonry.h>

static NSString *const actionCallbackKey = @"kSLAlertActionCallbackKey";
static NSString *const actionType = @"kSLAlertActionTypeKey";
static NSString *const actionButton = @"kSLAlertActionKey";

@interface SLAlertView()
{
    __weak UIView *_backView;
}
@property (nonatomic, assign) AlertType type;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, strong) NSMutableArray<SLTabbarButton *> *actions;
@property (nonatomic, strong) NSMutableArray<SLView *> *lineViews;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) SLTabbarView *buttonView;// 按钮容器视图
@end

@implementation SLAlertView

- (instancetype)initWithType:(AlertType)type
                       title:(NSString *)title
                  titleModel:(id<SLAlertTitleProtocol> _Nullable)titleModel
              titleLineModel:(id<SLAlertLineProtocol> _Nullable)titleLineModel
                     message:(NSString *)message
                messageModel:(id<SLAlertMessageProtocol> _Nullable)messageModel {
    if (self == [super init]) {
        self.type = type;
        self.actions = [NSMutableArray array];
        self.lineViews = [NSMutableArray array];
        NSDictionary *dic = [[SLUIConfig share].alertConfig valueForKey:[NSString stringWithFormat:@"%ld", type]];
        self.width = [[dic valueForKey:SLAlertWidth] floatValue];
        UIEdgeInsets contentInsets = UIEdgeInsetsFromString([dic valueForKey:SLAlertContentInset]);
        self.originX = contentInsets.left;
        self.height = contentInsets.top;
        if (![NSString emptyString:title]) {
            SLLabel *titleLabel = [[SLLabel alloc]init];
            titleLabel.numberOfLines = 0;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            if (titleModel && [titleModel conformsToProtocol:@protocol(SLAlertTitleProtocol)]) {
                titleLabel.font = [titleModel titleFont];
            } else {
                titleLabel.font = [self titleFont];
            }
            if (titleModel && [titleModel conformsToProtocol:@protocol(SLAlertTitleProtocol)]) {
                titleLabel.textColor = [titleModel titleColor];
            } else {
                titleLabel.textColor = [self titleColor];
            }
            CGSize titleSize = [title sizeWithFont:self.titleLabel.font size:CGSizeMake(self.width - contentInsets.left-contentInsets.right, MAXFLOAT)];
            titleLabel.frame = CGRectMake(self.originX, contentInsets.top, self.width - contentInsets.left-contentInsets.right, titleSize.height);
            [self addSubview:titleLabel];
            self.height += titleSize.height;
            self.titleLabel = titleLabel;
            self.title = title;
            SLView *titleLineView = [[SLView alloc]init];
            if (titleLineModel && [titleLineModel conformsToProtocol:@protocol(SLAlertLineProtocol)]) {
                titleLineView.backgroundColor = [titleLineModel lineViewBackcolor];
            } else {
                titleLineView.backgroundColor = [self lineViewBackcolor];
            }
            if (titleLineModel && [titleLineModel conformsToProtocol:@protocol(SLAlertLineProtocol)]) {
                titleLineView.hidden = ![titleLineModel lineShow];
            } else {
                titleLineView.hidden = ![self titleLineShow];
            }
            titleLineView.frame = CGRectMake(0, self.height, self.width, 0.5);
            [self addSubview:titleLineView];
            self.height += titleLineView.frame.size.height;
        }
        if (![NSString emptyString:message]) {
            self.height += 5;
            SLLabel *messageLabel = [[SLLabel alloc]init];
            messageLabel.numberOfLines = 0;
            if (messageModel && [messageModel conformsToProtocol:@protocol(SLAlertMessageProtocol)]) {
                messageLabel.textAlignment = [messageModel messageTextAlignment];
            } else {
                messageLabel.textAlignment = [self messageTextAlignment];
            }
            if (messageModel && [messageModel conformsToProtocol:@protocol(SLAlertMessageProtocol)]) {
                messageLabel.font = [messageModel messageFont];
            } else {
                messageLabel.font = [self messageFont];
            }
            if (messageModel && [messageModel conformsToProtocol:@protocol(SLAlertMessageProtocol)]) {
                messageLabel.textColor = [messageModel messageColor];
            } else {
                messageLabel.textColor = [self messageColor];
            }
            CGSize messageSize = [message sizeWithFont:messageLabel.font size:CGSizeMake(self.width - contentInsets.left-contentInsets.right, MAXFLOAT)];
            messageLabel.frame = CGRectMake(self.originX, self.height, self.width - contentInsets.left-contentInsets.right, messageSize.height);
            [self addSubview:messageLabel];
            self.messageLabel = messageLabel;
            self.message = message;
            self.height += messageLabel.frame.size.height;
        }
        self.height += contentInsets.bottom;
        self.height = MAX(30, self.height);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.messageLabel.text = message;
}

- (void)addActionWithTitle:(NSString *)title
                      type:(AlertActionType)type
                 lineModel:(id<SLAlertLineProtocol>)lineModel
               actionModel:(id<SLAlertActionProtocol>)actionModel
                  callback:(void(^)(void))callback {
    if ([NSString emptyString:title]) return;
    if (!self.buttonView) {
        self.buttonView = [[SLTabbarView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 44)];
        [self addSubview:self.buttonView];
        self.buttonView.canRepeatClick = YES;
        self.height += 44;
    }
    
    SLView *lineView = [[SLView alloc]init];
    if (lineModel && [lineModel conformsToProtocol:@protocol(SLAlertLineProtocol)]) {
        lineView.backgroundColor = [lineModel lineViewBackcolor];
    } else {
        lineView.backgroundColor = [self lineViewBackcolor];
    }
    if (lineModel && [lineModel conformsToProtocol:@protocol(SLAlertLineProtocol)]) {
        lineView.hidden = ![lineModel lineShow];
    } else {
        lineView.hidden = ![self otherLineShow];
    }
    [self addSubview:lineView];
    [self.lineViews addObject:lineView];
    for (int i = 0; i < self.lineViews.count; i ++) {
        SLView *view = self.lineViews[i];
        view.frame = CGRectMake(0, CGRectGetMinY(self.buttonView.frame)+44*i, self.buttonView.frame.size.width, 0.5);
    }
    if (self.actions.count == 1) {
        SLView *view = self.lineViews[1];
        view.frame = CGRectMake(CGRectGetMidX(self.buttonView.frame), CGRectGetMinY(self.buttonView.frame), 0.5, self.buttonView.frame.size.height);
    }
    UIColor *titleColor;
    if (actionModel && [actionModel conformsToProtocol:@protocol(SLAlertActionProtocol)]) {
        titleColor = [actionModel actionTitleColor];
    } else {
        if (type == AlertActionCancel) {
            titleColor = [self cancelTitleColor];
        } else if (type == AlertActionDefault) {
            titleColor = [self defaultTitleColor];
        } else {
            titleColor = [self destructiveTitleColor];
        }
    }
    UIColor *titleFont;
    if (actionModel && [actionModel conformsToProtocol:@protocol(SLAlertActionProtocol)]) {
        titleFont = [actionModel actionTitleFont];
    } else {
        if (type == AlertActionCancel) {
            titleFont = [self cancelTitleFont];
        } else if (type == AlertActionDefault) {
            titleFont = [self defaultTitleFont];
        } else {
            titleFont = [self destructiveTitleFont];
        }
    }
    SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
    [tabbarBt setTitle:title forState:UIControlStateNormal];
    [tabbarBt setTitleColor:titleColor forState:UIControlStateNormal];
    tabbarBt.titleLabel.font = titleFont;
    NSDictionary *dic = @{actionType: @(type),actionButton: tabbarBt, actionCallbackKey: callback};
    [self.actions addObject:dic];
    NSMutableArray *normalArray = [NSMutableArray array];
    NSMutableArray *cancelArray = [NSMutableArray array];
    for (NSDictionary *dic in self.actions) {
        if ([dic[actionType] integerValue] == 0) {
            [cancelArray addObject:dic];
        } else {
            [normalArray addObject:dic];
        }
    }
    if (self.actions.count <= 2) {
        self.actions = [cancelArray arrayByAddingObjectsFromArray:normalArray].mutableCopy;
    } else {
        self.actions = [normalArray arrayByAddingObjectsFromArray:cancelArray].mutableCopy;
    }
    CGFloat plusHeight = 0;
    if (self.actions.count == 3) {
        plusHeight = 88;
    } else if (self.actions.count > 3) {
        plusHeight = 44;
    }
    CGRect frame = self.buttonView.frame;
    frame.size.height += plusHeight;
    self.buttonView.frame = frame;
    self.buttonView.direction = plusHeight > 0 ? Vertical : Horizontal;
    self.height += plusHeight;
    [self layoutButtons];
}

- (void)layoutButtons {
    WeakSelf;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dic in self.actions) {
        [arrayM addObject:dic[actionButton]];
    }
    [self.buttonView initButtons:[NSArray arrayWithArray:arrayM] configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeOnlyTitle;
    }];
    self.buttonView.clickSLTabbarIndex = ^(SLTabbarButton * _Nonnull button, NSInteger index) {
        StrongSelf;
        NSDictionary *dic = strongSelf.actions[index];
        void(^callback)(void) = [dic[actionCallbackKey] copy];
        if (callback) callback();
        [strongSelf hide];
    };
    [self.buttonView setNeedsLayout];
    [self.buttonView layoutIfNeeded];
}

- (void)show {
    self.frame = CGRectMake(kScreenWidth/2.0-self.width/2.0, kScreenHeight/2.0-self.height/2.0, self.width, self.height);
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [backView addSubview:self];
    _backView = backView;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    [self addCornerRadius:10];
    self.clipsToBounds = YES;
}

- (void)hide {
    [_backView removeFromSuperview];
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

- (NSTextAlignment)messageTextAlignment {
    return NSTextAlignmentCenter;
}

- (UIColor *)lineViewBackcolor {
    return SLUIHexColor(0xe0e0e0);
}

- (BOOL)titleLineShow {
    return NO;
}

- (BOOL)otherLineShow {
    return YES;
}

- (UIColor *)cancelTitleColor {
    return SLUIHexColor(0x007aff);
}

- (UIFont *)cancelTitleFont {
    return SLUIBoldFont(17.0);
}

- (UIColor *)defaultTitleColor {
    return SLUIHexColor(0x007aff);
}

- (UIFont *)defaultTitleFont {
    return SLUINormalFont(17.0);
}

- (UIColor *)destructiveTitleColor {
    return SLUIHexColor(0xff0000);
}

- (UIFont *)destructiveTitleFont {
    return SLUINormalFont(17.0);
}

@end
