//
//  SLScrollView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "SLScrollView.h"
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLCommonLibrary/UIView+SLBase.h>

@implementation SLScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (instancetype)init {
    if (self == [super init]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    if (@available(iOS 11, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.clipsToBounds = YES;
}

#pragma 事件传递和响应的一些笔记
#pragma mark 扩大scrollView的滑动范围
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    self.sl_y += self.superview.sl_y-self.sl_y;
//    self.sl_x += self.superview.sl_x-self.sl_x;
//    self.sl_width += self.superview.sl_width-self.sl_width;
//    self.sl_height += self.superview.sl_height-self.sl_height;
//    if (CGRectContainsPoint(self.frame, point)) {
//        return YES;
//    }
//    return [super pointInside:point withEvent:event];
//}


#pragma mark 传递scrollview的子view的事件到scrollview的上一层view
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"EOCScrollView touchBegan");
//    [self.nextResponder touchesBegan:touches withEvent:event];
//}

#pragma mark 手势已经识别，通过这个方法的返回值，看是否响应
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    return YES;
//}

#pragma mark 互斥用的：otherGestureRecognizer它要响应，需要gestureRecognizer响应失败，才可以，gestureRecognizer的优先级最高
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

#pragma mark 两个手势是否共存（一起响应），A手势和B手势，只要这两个手势有一个手势的这个代理方法返回的YES，那么就是共存
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//    return NO;
//
//}

#pragma mark 手势支不支持touch
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    return YES;
//}

#pragma mark pointInside以及hitTest找到了view，然后如果view或者它的superView有手势事件，都会响应
#pragma mark 默认情况下，如果手势识别出来了，会cancel掉view 的touch事件
#pragma mark tapGesture.delaysTouchesBegan = NO;   //如果为YES，阻止touch方法的识别
#pragma mark tapGesture.cancelsTouchesInView = NO;

#pragma mark  self.delaysContentTouches = NO; // 滑动scrolleview的子view不会触发scrollview的滑动
#pragma mark     self.canCancelContentTouches = NO; // 滑动scrolleview的子view不会触发scrollview的滑动

/**
 1、iOS有哪些事件
 2、触摸事件的整体流程（runloop相关、事件传递和响应）
 3、事件传递流程：hitTest、pointInside来找到这个view
 4、hitTest方法里的实现
 5、事件响应：UIResponder这个类，因为每个view都有一个nextResponder的对象，这样子就串联了一个响应链
 6、有了上面的响应链，然后就会进行touch四个方法的传递响应，你可以不写super touchbegin/moved/cancel/end来阻止这个传递流程
 7、手势和hitTest、pointInside的关联；手势种类的识别；手势和touch事件的关系
 分析一下button被点击的时候，进行响应，背后发生了什么事情
 */

@end
