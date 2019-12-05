//
//  SLTabbarView.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/21.
//

#import "SLTabbarView.h"
#import <CSLUILibrary/SLTabbarButton.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLCommonLibrary/UIControl+Events.h>

static int buttonTag = 100;

@interface SLTabbarView()
@property (nonatomic, copy) NSArray<SLTabbarButton *> *buttons;
@property(nonatomic, strong) SLTabbarButton *selectBarButton;
@property(nonatomic, assign) NSInteger currentSelectIndex;
@end

@implementation SLTabbarView

- (void)initButtons:(NSArray<SLTabbarButton *> *)buttons configTabbarButton:(void (^)(SLTabbarButton * _Nonnull))configTabbarButtonBlock {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.buttons = buttons.copy;
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
        if (configTabbarButtonBlock) configTabbarButtonBlock(button);
        [self addSubview:button];
    }
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
                    h = self.frame.size.height * 1.0 / self.buttons.count;
                } else {
                    h = 0;
                }
            } else {
                h = tabbarBtPercent*1.0*self.frame.size.height/totalPercent;
            }
            [tabbarBt setFrame:CGRectMake(0, y, self.frame.size.width, h)];
            tabbarBt.offsetXY = y;
            tempHeight += h;
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
                w = self.frame.size.width * 1.0 / self.buttons.count;
            } else {
                w = 0;
            }
        } else {
            w = tabbarBtPercent*1.0*self.frame.size.width/totalPercent;
        }
        [tabbarBt setFrame:CGRectMake(x, 0, w, self.frame.size.height)];
        tabbarBt.offsetXY = x;
        tempWidth += w;
    }
    if (self.clickSLTabbarIndex) self.clickSLTabbarIndex(self.selectBarButton ,self.selectBarButton.tag - buttonTag);
}

@end
