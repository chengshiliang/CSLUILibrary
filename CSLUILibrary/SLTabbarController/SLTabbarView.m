//
//  SLTabbarView.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/21.
//

#import "SLTabbarView.h"
#import <CSLUILibrary/SLTabbarButton.h>
#import <CSLUtils/SLUIConsts.h>
#import <CSLCommonLibrary/UIControl+Events.h>
#import <CSLUtils/UIView+SLBase.h>

static int buttonTag = 100;

@interface SLTabbarView()
@property (nonatomic, copy) NSArray<SLTabbarButton *> *buttons;
@property (nonatomic, copy) NSArray<SLView *> *lineViews;
@property(nonatomic, strong) SLTabbarButton *selectBarButton;
@property(nonatomic, assign) NSInteger currentSelectIndex;
@end

@implementation SLTabbarView

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = SLUIHexColor(0x999999);
    }
    return _lineColor;
}

- (void)initButtons:(NSArray<SLTabbarButton *> *)buttons configTabbarButton:(void (^)(SLTabbarButton * button, NSInteger index))configTabbarButtonBlock {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.buttons = buttons.copy;
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:buttons.count - 1];
    for (int i = 0; i < buttons.count; i++){
        SLTabbarButton *button = buttons[i];
        button.tag = buttonTag+i;
        if (self.currentSelectIndex == 0) {
            self.currentSelectIndex = buttonTag;
        }
        WeakSelf;
        [button onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl *control) {
            StrongSelf;
            if ([control isKindOfClass:[SLTabbarButton class]]) {
                SLTabbarButton *currentBt = (SLTabbarButton *)control;
                if (strongSelf.selectBarButton == currentBt && !strongSelf.canRepeatClick) {
                    return;
                }
                strongSelf.currentSelectIndex = currentBt.tag;
                strongSelf.selectBarButton.selected = NO;
                strongSelf.selectBarButton = currentBt;
                strongSelf.selectBarButton.selected = YES;
                if (strongSelf.clickSLTabbarIndex) strongSelf.clickSLTabbarIndex(currentBt ,currentBt.tag - buttonTag);
            }
        }];
        if (button.tag == self.currentSelectIndex) {
            self.selectBarButton = button;
            self.selectBarButton.selected = YES;
        } else {
            button.selected = NO;
        }
        if (configTabbarButtonBlock) configTabbarButtonBlock(button, i);
        [self addSubview:button];
        if (i == buttons.count - 1 || !self.needLineView) continue;
        SLView *lineView = [[SLView alloc]init];
        lineView.backgroundColor = self.lineColor;
        [arrayM addObject:lineView];
        [self addSubview:lineView];
    }
    self.lineViews = arrayM;
}

- (NSInteger)currentIndex {
    return self.currentSelectIndex-buttonTag;
}

- (SLTabbarButton *)selectButton {
    return self.selectBarButton;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    if (self.currentIndex == index + buttonTag) return;
    SLTabbarButton *btn = self.buttons[index];
    self.currentSelectIndex = buttonTag + index;
    self.selectBarButton.selected = NO;
    self.selectBarButton = btn;
    self.selectBarButton.selected = YES;
    if (self.clickSLTabbarIndex) self.clickSLTabbarIndex(btn ,index);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.buttons.count <= 0) return;
    CGFloat totalPercent = 0;
    for (int i = 0; i < self.buttons.count; i++){
        SLTabbarButton *tabbarBt = self.buttons[i];
        totalPercent += MAX(0, tabbarBt.percent);
    }
    if (self.direction == Vertical) {
        CGFloat tempHeight = 0;
        for (int i = 0; i < self.buttons.count; i++){
            SLTabbarButton *tabbarBt = self.buttons[i];
            CGFloat y = tempHeight;
            CGFloat h;
            CGFloat tabbarBtPercent = MAX(tabbarBt.percent, 0);
            if (tabbarBtPercent == 0) {
                if (totalPercent <= 0) {
                    h = self.sl_height * 1.0 / self.buttons.count;
                } else {
                    h = 0;
                }
            } else {
                h = tabbarBtPercent*1.0*self.sl_height/totalPercent;
            }
            [tabbarBt setFrame:CGRectMake(0, y, self.sl_width, h)];
            tabbarBt.offsetXY = y;
            tempHeight += h;
            if (i < self.buttons.count - 1 && self.needLineView) {
                SLView *lineView = self.lineViews[i];
                lineView.frame = CGRectMake(self.lineMargin, y+h-0.5, self.sl_width-2*self.lineMargin, 0.5);
            }
        }
        return;
    }
    CGFloat tempWidth = 0;
    for (int i = 0; i < self.buttons.count; i++){
        SLTabbarButton *tabbarBt = self.buttons[i];
        CGFloat x = tempWidth;
        CGFloat w;
        CGFloat tabbarBtPercent = MAX(tabbarBt.percent, 0);
        if (tabbarBtPercent == 0) {
            if (totalPercent <= 0) {
                w = self.sl_width * 1.0 / self.buttons.count;
            } else {
                w = 0;
            }
        } else {
            w = tabbarBtPercent*1.0*self.sl_width/totalPercent;
        }
        [tabbarBt setFrame:CGRectMake(x, 0, w, self.sl_height)];
        tabbarBt.offsetXY = x;
        tempWidth += w;
        if (i < self.buttons.count - 1 && self.needLineView) {
            SLView *lineView = self.lineViews[i];
            lineView.frame = CGRectMake(x+w-0.5, self.lineMargin, 0.5, self.sl_height-2*self.lineMargin);
        }
    }
    if (self.clickSLTabbarIndex && !self.canRepeatClick) self.clickSLTabbarIndex(self.selectBarButton ,self.selectBarButton.tag - buttonTag);
}

@end
