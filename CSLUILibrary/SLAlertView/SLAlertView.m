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
#import <Masonry/Masonry.h>

@implementation SLAlertAction

- (UIColor *)titleColor {
    if (_titleColor) {
        return _titleColor;
    }
    if (self.actionType == AlertActionCancel) {
        return [self cancelTitleColor];
    } else if (self.actionType == AlertActionDestructive) {
        return [self destructiveTitleColor];
    } else {
        return [self defaultTitleColor];
    }
}

- (UIFont *)titleFont {
    if (_titleFont) {
        return _titleFont;
    }
    if (self.actionType == AlertActionCancel) {
        return [self cancelTitleFont];
    } else if (self.actionType == AlertActionDestructive) {
        return [self destructiveTitleFont];
    } else {
        return [self defaultTitleFont];
    }
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

@interface SLAlertView()
@property (nonatomic, strong) NSMutableArray<SLAlertAction *> *actions;
@property (nonatomic, strong) NSMutableArray<SLView *> *lineViews;
@property (nonatomic, assign) AlertType type;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGFloat originX;
@end

@implementation SLAlertView

- (instancetype)initWithType:(AlertType)type
                       title:(NSString *)title
                     message:(NSString *)message {
    if (self == [super init]) {
        self.type = type;
        self.actions = [NSMutableArray array];
        self.lineViews = [NSMutableArray array];
        NSDictionary *dic = [[SLUIConfig share].alertConfig valueForKey:[NSString stringWithFormat:@"%ld", (long)type]];
        self.width = [dic[SLAlertWidth] floatValue];
        self.width = self.width > 1 ? self.width : kScreenWidth * 0.85;
        UIEdgeInsets contentInsets = [NSString emptyString:dic[SLAlertContentInset]] ? UIEdgeInsetsMake(20, 16, 20, 16) : UIEdgeInsetsFromString(dic[SLAlertContentInset]);
        self.contentInsets = contentInsets;
        self.originX = contentInsets.left;
        self.height = contentInsets.top;
        self.contentWidth = self.width-contentInsets.left-contentInsets.right;
        if (![NSString emptyString:title]) {
            SLLabel *titleLabel = [[SLLabel alloc]init];
            titleLabel.numberOfLines = 0;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [self titleFont];
            titleLabel.textColor = [self titleColor];
            CGSize titleSize = [title sizeWithFont:self.titleLabel.font size:CGSizeMake(self.contentWidth, MAXFLOAT)];
            titleLabel.frame = CGRectMake(self.originX, contentInsets.top, self.contentWidth, titleSize.height);
            titleLabel.text = title;
            [self addSubview:titleLabel];
            self.height += titleSize.height;
            self.titleLabel = titleLabel;
            self.titleLineView = [[SLView alloc]init];
            self.titleLineView.backgroundColor = [self lineViewBackcolor];
            self.titleLineView.hidden = ![self titleLineShow];
            self.titleLineView.frame = CGRectMake(0, self.height, self.width, 0.5);
            [self addSubview:self.titleLineView];
            self.height += self.titleLineView.frame.size.height;
        }
        if (![NSString emptyString:message]) {
            self.height += 5;
            SLLabel *messageLabel = [[SLLabel alloc]init];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = [self messageTextAlignment];
            messageLabel.font = [self messageFont];
            messageLabel.textColor = [self messageColor];
            CGSize messageSize = [message sizeWithFont:messageLabel.font size:CGSizeMake(self.contentWidth, MAXFLOAT)];
            messageLabel.frame = CGRectMake(self.originX, self.height, self.contentWidth, messageSize.height);
            messageLabel.text = message;
            [self addSubview:messageLabel];
            self.messageLabel = messageLabel;
            self.height += messageLabel.frame.size.height;
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addActionWithTitle:(NSString *)title
                      type:(AlertActionType)type
                  callback:(void(^)(void))callback; {
    if ([NSString emptyString:title]) return;
    if (!self.buttonView) {
        self.buttonView = [[SLTabbarView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 44)];
        [self addSubview:self.buttonView];
        self.buttonView.canRepeatClick = YES;
        self.height += 44;
    }
    
    SLView *lineView = [[SLView alloc]init];
    lineView.backgroundColor = [self lineViewBackcolor];
    lineView.hidden = ![self otherLineShow];
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
    SLAlertAction *action = [[SLAlertAction alloc]init];
    action.actionType = type;
    SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
    [tabbarBt setTitle:title forState:UIControlStateNormal];
    [tabbarBt setTitleColor:[action titleColor] forState:UIControlStateNormal];
    tabbarBt.titleLabel.font = [action titleFont];
    action.button = tabbarBt;
    action.callback = [callback copy];
    [self.actions addObject:action];
    NSMutableArray *normalArray = [NSMutableArray array];
    NSMutableArray *cancelArray = [NSMutableArray array];
    for (SLAlertAction *action in self.actions) {
        if (action.actionType) {
            [cancelArray addObject:action];
        } else {
            [normalArray addObject:action];
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

- (void)addCustomView:(UIView *)customView
            alignment:(AlertContentViewAlignmentType)alignmentType {
    if (!customView) return;
    if (self.actions.count > 0) {
        for (int i = 0; i < self.lineViews.count; i ++) {
            SLView *view = self.lineViews[i];
            CGRect lineFrame = view.frame;
            lineFrame.origin.y += customView.frame.origin.y + customView.frame.size.height;
            view.frame = lineFrame;
        }
        CGRect frame = self.buttonView.frame;
        frame.origin.y += customView.frame.origin.y + customView.frame.size.height;
        self.buttonView.frame = frame;
        [self layoutButtons];
        self.height -= frame.size.height;
    }
    CGFloat viewRealWidth = customView.frame.size.width > self.contentWidth ? self.contentWidth : customView.frame.size.width;
    CGFloat viewRealHeight = customView.frame.size.height * viewRealWidth * 1.0/ customView.frame.size.width;
    self.height += customView.frame.origin.y;
    if (alignmentType == AlertContentViewAlignmentLeft) {
        customView.frame = CGRectMake(self.originX, self.height, viewRealWidth, viewRealHeight);
    } else if (alignmentType == AlertContentViewAlignmentRight) {
        customView.frame = CGRectMake(self.width-viewRealWidth-self.originX, self.height, viewRealWidth, viewRealHeight);
    } else {
        customView.frame = CGRectMake(self.width*1.0/2-viewRealWidth*1.0/2, self.height, viewRealWidth, viewRealHeight);
    }
    self.height += customView.frame.size.height;
    [self addSubview:customView];
    if (self.actions.count > 0) {
        self.height += self.buttonView.frame.size.height;
    }
}

- (void)layoutButtons {
    WeakSelf;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (SLAlertAction *action in self.actions) {
        [arrayM addObject:action.button];
    }
    [self.buttonView initButtons:[NSArray arrayWithArray:arrayM] configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeOnlyTitle;
    }];
    self.buttonView.clickSLTabbarIndex = ^(SLTabbarButton * _Nonnull button, NSInteger index) {
        StrongSelf;
        SLAlertAction *action = strongSelf.actions[index];
        void(^callback)(void) = [action.callback copy];
        if (callback && strongSelf.backView) {
            callback();
            [strongSelf hide];
        }
    };
    [self.buttonView setNeedsLayout];
    [self.buttonView layoutIfNeeded];
}

- (void)show {
    if (self.actions.count > 0) {
        for (int i = 0; i < self.lineViews.count; i ++) {
            SLView *view = self.lineViews[i];
            CGRect lineFrame = view.frame;
            lineFrame.origin.y += self.contentInsets.bottom;
            view.frame = lineFrame;
        }
        CGRect frame = self.buttonView.frame;
        frame.origin.y += self.contentInsets.bottom;
        self.buttonView.frame = frame;
        [self layoutButtons];
    }
    self.height += self.contentInsets.bottom;
    self.height = MAX(30, self.height);
    self.frame = CGRectMake(kScreenWidth/2.0-self.width/2.0, kScreenHeight/2.0-self.height/2.0, self.width, self.height);
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [backView addSubview:self];
    self.backView = backView;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    [self addCornerRadius:10];
    self.clipsToBounds = YES;
}

- (void)hide {
    [self.backView removeFromSuperview];
}

- (NSArray<SLView *> *)lineViewArray {
    return [self.lineViews copy];
}

- (NSArray<SLAlertAction *> *)actionArray {
    return [self.actions copy];
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

@end
