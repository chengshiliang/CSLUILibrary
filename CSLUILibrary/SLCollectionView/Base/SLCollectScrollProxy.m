//
//  SLCollectScrollProxy.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/20.
//

#import "SLCollectScrollProxy.h"
#import <CSLUILibrary/SLCollectManager.h>

@implementation SLCollectScrollProxy
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    !self.collectManager.scrollCallback?:self.collectManager.scrollCallback(scrollView);
}
@end
