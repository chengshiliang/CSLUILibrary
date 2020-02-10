//
//  SLAlertView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/4.
//

#import "SLAlertView.h"
#import <CSLCommonLibrary/NSString+Util.h>
#import <CSLCommonLibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLAlertConfig.h>
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLUILibrary/SLImageView.h>
#import <CSLUILibrary/SLLabel.h>

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
@property (nonatomic, strong) NSMutableArray<SLAlertAction *> *cancelActions;
@property (nonatomic, strong) NSMutableArray<SLAlertAction *> *actions;
@property (nonatomic, strong) NSMutableArray<SLView *> *lineViews;
@property (nonatomic, strong) SLTabbarView *buttonView;// 按钮容器视图
@property (nonatomic, assign) AlertType type;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGFloat originX;
@end

@implementation SLAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.actions = [NSMutableArray array];
        self.lineViews = [NSMutableArray array];
        self.cancelActions = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addAlertWithType:(AlertType)type
                   title:(NSString *)title
                 message:(NSString *)message {
    self.type = type;
    [self.actions removeAllObjects];
    [self.lineViews removeAllObjects];
    [self.cancelActions removeAllObjects];
    NSDictionary *dic = [[SLAlertConfig share].alertConfig valueForKey:[NSString stringWithFormat:@"%ld", (long)type]];
    self.width = [dic[SLAlertWidth] floatValue];
    self.width = self.width > 1 ? self.width : (type == AlertView ? kScreenWidth * 0.85 : kScreenWidth * 0.95);
    UIEdgeInsets contentInsets = [NSString emptyString:dic[SLAlertContentInset]] ? UIEdgeInsetsMake(20, 16, 20, 16) : UIEdgeInsetsFromString(dic[SLAlertContentInset]);
    self.contentInsets = contentInsets;
    self.originX = contentInsets.left;
    self.height = contentInsets.top;
    self.contentWidth = self.width-contentInsets.left-contentInsets.right;
    if (![NSString emptyString:title]) {
        SLLabel *titleLabel = (SLLabel *)[UIView copyView:self.titleLabel];
        CGSize titleSize = [title sizeWithFont:self.titleLabel.font size:CGSizeMake(self.contentWidth, MAXFLOAT)];
        titleLabel.frame = CGRectMake(self.originX, contentInsets.top, self.contentWidth, titleSize.height);
        titleLabel.text = title;
        [self addSubview:titleLabel];
        self.height += titleSize.height;
        self.titleLineView = [[SLView alloc]init];
        self.titleLineView.backgroundColor = [self lineViewBackcolor];
        self.titleLineView.hidden = ![self titleLineShow];
        self.titleLineView.frame = CGRectMake(0, self.height, self.width, 0.5);
        [self addSubview:self.titleLineView];
        self.height += self.titleLineView.sl_height;
    }
    if (![NSString emptyString:message]) {
        self.height += 5;
        SLLabel *messageLabel = (SLLabel *)[UIView copyView:self.messageLabel];
        CGSize messageSize = [message sizeWithFont:messageLabel.font size:CGSizeMake(self.contentWidth, MAXFLOAT)];
        messageLabel.frame = CGRectMake(self.originX, self.height, self.contentWidth, messageSize.height);
        messageLabel.text = message;
        [self addSubview:messageLabel];
        self.height += messageLabel.sl_height;
    }
}

- (void)addActionWithTitle:(NSString *)title
                      type:(AlertActionType)type
           constructAction:(void(^)(SLTabbarButton *button))constructActionBlock
                  callback:(void(^)(void))callback; {
    if ([NSString emptyString:title]) return;
    int actionHeight = self.type == AlertSheet ? ceil(44* kScreenWidth*1.0 / 320) : 44;
    BOOL isActionCancel = self.type == AlertSheet && type == AlertActionCancel;// 是actionsheet类型的取消按钮
    if (isActionCancel) {
        SLAlertAction *action = [[SLAlertAction alloc]init];
        action.actionType = type;
        SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
        [tabbarBt setTitle:title forState:UIControlStateNormal];
        [tabbarBt setTitleColor:[action titleColor] forState:UIControlStateNormal];
        tabbarBt.titleLabel.font = [action titleFont];
        action.button = tabbarBt;
        action.callback = [callback copy];
        [self.cancelActions addObject:action];
        return;
    }
    if (!self.buttonView) {
        self.buttonView = [[SLTabbarView alloc]initWithFrame:CGRectMake(0, self.height, self.width, actionHeight)];
        [self addSubview:self.buttonView];
        self.buttonView.canRepeatClick = YES;
        self.height += actionHeight;
    }
    
    SLView *lineView = [[SLView alloc]init];
    lineView.backgroundColor = [self lineViewBackcolor];
    lineView.hidden = ![self otherLineShow];
    [self addSubview:lineView];
    [self.lineViews addObject:lineView];
    for (int i = 0; i < self.lineViews.count; i ++) {
        SLView *view = self.lineViews[i];
        view.frame = CGRectMake(0, CGRectGetMinY(self.buttonView.frame)+actionHeight*i, self.buttonView.sl_width, 0.5);
    }
    if (self.actions.count == 1 && self.type == AlertView) {
        SLView *view = self.lineViews[1];
        view.frame = CGRectMake(CGRectGetMidX(self.buttonView.frame), CGRectGetMinY(self.buttonView.frame), 0.5, self.buttonView.sl_height);
    }
    SLAlertAction *action = [[SLAlertAction alloc]init];
    action.actionType = type;
    SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
    [tabbarBt setTitle:title forState:UIControlStateNormal];
    [tabbarBt setTitleColor:[action titleColor] forState:UIControlStateNormal];
    tabbarBt.titleLabel.font = [action titleFont];
    action.button = tabbarBt;
    action.callback = [callback copy];
    action.constructActionBlock = [constructActionBlock copy];
    [self.actions addObject:action];
    NSMutableArray *normalArray = [NSMutableArray array];
    NSMutableArray *cancelArray = [NSMutableArray array];
    for (SLAlertAction *action in self.actions) {
        if (action.actionType == AlertActionCancel) {
            [cancelArray addObject:action];
        } else {
            [normalArray addObject:action];
        }
    }
    if (self.type == AlertView) {
        if (self.actions.count <= 2) {
            self.actions = [cancelArray arrayByAddingObjectsFromArray:normalArray].mutableCopy;
        } else {
            self.actions = [normalArray arrayByAddingObjectsFromArray:cancelArray].mutableCopy;
        }
    } else {
        self.actions = [normalArray arrayByAddingObjectsFromArray:cancelArray].mutableCopy;
    }
    CGFloat plusHeight = 0;
    if (self.type == AlertView) {
        if (self.actions.count == 3) {
            plusHeight = actionHeight*2;
        } else if (self.actions.count > 3) {
            plusHeight = actionHeight;
        }
    } else {
        if (self.actions.count > 1) {
            plusHeight = actionHeight;
        }
    }
    self.buttonView.sl_height = self.buttonView.sl_height + plusHeight;
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
            view.sl_y = view.sl_y + customView.sl_y + customView.sl_height;
        }
        self.buttonView.sl_y = self.buttonView.sl_y + customView.sl_y + customView.sl_height;
        [self layoutButtons];
        self.height -= self.buttonView.sl_height;
    }
    CGFloat viewRealWidth = customView.sl_width> self.contentWidth ? self.contentWidth : customView.sl_width;
    CGFloat viewRealHeight = customView.sl_height * viewRealWidth * 1.0/ customView.sl_width;
    self.height += customView.sl_y;
    if (alignmentType == AlertContentViewAlignmentLeft) {
        customView.frame = CGRectMake(self.originX, self.height, viewRealWidth, viewRealHeight);
    } else if (alignmentType == AlertContentViewAlignmentRight) {
        customView.frame = CGRectMake(self.width-viewRealWidth-self.originX, self.height, viewRealWidth, viewRealHeight);
    } else {
        customView.frame = CGRectMake(self.width*1.0/2-viewRealWidth*1.0/2, self.height, viewRealWidth, viewRealHeight);
    }
    self.height += customView.sl_height;
    [self addSubview:customView];
    if (self.actions.count > 0) {
        self.height += self.buttonView.sl_height;
    }
}

- (void)layoutButtons {
    WeakSelf;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (SLAlertAction *action in self.actions) {
        [arrayM addObject:action.button];
    }
    [self.buttonView initButtons:[NSArray arrayWithArray:arrayM] configTabbarButton:^(SLTabbarButton * _Nonnull button, NSInteger index) {
        StrongSelf;
        SLAlertAction *action = strongSelf.actions[index];
        if (action.constructActionBlock) {
            action.constructActionBlock(button);
        } else {
            button.tabbarButtonType = SLButtonTypeOnlyTitle;
        }
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
            view.sl_y = view.sl_y + self.contentInsets.bottom;
        }
        self.buttonView.sl_y = self.contentInsets.bottom + self.buttonView.sl_y;
        [self layoutButtons];
    }
    self.height += self.contentInsets.bottom;
    self.height = MAX(30, self.height);
    if (self.type == AlertView) {
        self.frame = CGRectMake(kScreenWidth/2.0-self.width/2.0, kScreenHeight/2.0-self.height/2.0, self.width, self.height);
    } else {
        self.frame = CGRectMake(kScreenWidth/2.0-self.width/2.0, kScreenHeight-self.height-10, self.width, self.height);
    }
    SLView *backView = [[SLView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [backView addSubview:self];
    self.backView = backView;
    if (self.cancelActions.count > 0) {
        int actionHeight = ceil(44* kScreenWidth*1.0 / 320);
        CGFloat cancelButtonViewHeight = 10 + self.cancelActions.count*actionHeight;
        SLTabbarView *cancelButonView = [[SLTabbarView alloc]initWithFrame:CGRectMake((kScreenWidth-self.width)/2.0, kScreenHeight - cancelButtonViewHeight, self.width, self.cancelActions.count*actionHeight)];
        cancelButonView.canRepeatClick = YES;
        cancelButonView.backgroundColor = SLUIHexColor(0xffffff);
        cancelButonView.direction = Vertical;
        [self.backView addSubview:cancelButonView];
        self.sl_y = self.sl_y - cancelButtonViewHeight;
        NSMutableArray *arrayM = [NSMutableArray array];
        for (SLAlertAction *action in self.cancelActions) {
            [arrayM addObject:action.button];
        }
        [cancelButonView initButtons:[NSArray arrayWithArray:arrayM] configTabbarButton:^(SLTabbarButton * _Nonnull button, NSInteger index) {
            button.tabbarButtonType = SLButtonTypeOnlyTitle;
        }];
        WeakSelf;
        cancelButonView.clickSLTabbarIndex = ^(SLTabbarButton * _Nonnull button, NSInteger index) {
            StrongSelf;
            SLAlertAction *action = strongSelf.cancelActions[index];
            void(^callback)(void) = [action.callback copy];
            if (callback && strongSelf.backView) {
                callback();
                [strongSelf hide];
            }
        };
        [cancelButonView setNeedsLayout];
        [cancelButonView layoutIfNeeded];
        [cancelButonView addCornerRadius:10];
        if (self.cancelActions.count > 1) {
            for (int i = 1; i < self.cancelActions.count; i ++) {
                SLView *lineView = [[SLView alloc]initWithFrame:CGRectMake(0, actionHeight*i, self.width, 0.5)];
                lineView.backgroundColor = [self lineViewBackcolor];
                lineView.hidden = ![self otherLineShow];
                [cancelButonView addSubview:lineView];
                [self.lineViews addObject:lineView];
            }
        }
    }
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
    return [[self.actions arrayByAddingObjectsFromArray:self.cancelActions] copy];
}

- (SLLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SLLabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [self titleFont];
        _titleLabel.textColor = [self titleColor];
    }
    return _titleLabel;
}

- (SLLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[SLLabel alloc]init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = [self messageTextAlignment];
        _messageLabel.font = [self messageFont];
        _messageLabel.textColor = [self messageColor];
    }
    return _messageLabel;
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
