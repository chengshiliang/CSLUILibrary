//
//  SLContext.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/19.
//

#import "SLContext.h"

@implementation SLPresenter
@end

@implementation SLInteractor
@end

@implementation SLBaseView
- (void)dealloc {
    self.context = nil;
}
@end

@implementation SLContext
- (void)dealloc {
    NSLog(@"context being released");
}
@end
