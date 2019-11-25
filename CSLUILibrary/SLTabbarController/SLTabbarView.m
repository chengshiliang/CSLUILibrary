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
                if (strongSelf.selectBarButton == currentBt) {
                    return;
                }
                strongSelf.currentSelectIndex = currentBt.tag;
                strongSelf.selectBarButton.selected = NO;
                strongSelf.selectBarButton = currentBt;
                strongSelf.selectBarButton.selected = YES;
                if (strongSelf.clickSLTabbarIndex) strongSelf.clickSLTabbarIndex(currentBt.tag - buttonTag);
            }
        }];
        if (button.tag == self.currentSelectIndex) {
            self.selectBarButton = button;
            self.selectBarButton.selected = YES;
            if (self.clickSLTabbarIndex) self.clickSLTabbarIndex(button.tag - buttonTag);
        } else {
            button.selected = NO;
        }
        if (configTabbarButtonBlock) configTabbarButtonBlock(button);
        [self addSubview:button];
    }
}

- (NSInteger)currentIndex {
    return self.currentSelectIndex;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.buttons.count <= 0) return;
    CGFloat width = self.frame.size.width*1.0/self.buttons.count;
    for (int i = 0; i < self.buttons.count; i++){
        SLTabbarButton *tabbarBt = self.buttons[i];
        [tabbarBt setFrame:CGRectMake(i*width, 0, width, self.frame.size.height)];
    }
}

@end
