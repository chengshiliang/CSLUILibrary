//
//  NSObject+SLContext.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/19.
//

#import "NSObject+SLContext.h"
#import "SLContext.h"
#import <objc/runtime.h>

@implementation NSObject (SLContext)
@dynamic context;

- (void)setContext:(SLContext*)object {
    objc_setAssociatedObject(self, @selector(context), object, OBJC_ASSOCIATION_ASSIGN);
}

- (SLContext*)context {
    id curContext = objc_getAssociatedObject(self, @selector(context));
    if (curContext == nil && [self isKindOfClass:[UIView class]]) {
        
        UIView* view = (UIView*)self;
        
        UIView* sprView = view.superview;
        while (sprView != nil) {
            if (sprView.context != nil) {
                curContext = sprView.context;
                break;
            }
            sprView = sprView.superview;
        }
        
        if (curContext != nil) {
            [self setContext:curContext];
        }
    }
    
    return curContext;
}
@end
