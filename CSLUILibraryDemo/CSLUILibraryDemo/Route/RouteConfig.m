//
//  RouteConfig.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2020/3/17.
//  Copyright © 2020 csl. All rights reserved.
//

#import "RouteConfig.h"
#import "AlertController.h"

@implementation Route

- (id<SLCatchVCProtocol>)produce {
    return [RouteConfig new];
}

@end

@implementation RouteConfig
- (UIViewController *)getTargetVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"alert"];
}
@end
