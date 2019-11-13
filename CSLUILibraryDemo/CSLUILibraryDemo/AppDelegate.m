//
//  AppDelegate.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/10/31.
//  Copyright © 2019 csl. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "YYFPSLabel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SLUIConfig share] configLabel:LabelH1 font:[UIFont boldSystemFontOfSize:36.0] color:nil];
    [SLImageDownLoader share].maxQueueCount = 10;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *homeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    
    SLTabBarController *tabBarVC = [[SLTabBarController alloc] init];
    [tabBarVC initViewControllers:@[homeVC] titles:@[@"home"] normalImages:@[[UIImage imageNamed:@"tabBar_home_normal"]] selectImages:@[[UIImage imageNamed:@"tabBar_home_press"]] navFlags:@[@(true)] layoutTabbar:^(SLTabbarButton * _Nonnull tabbar) {
        // 自定义选中文字颜色和未选中文字颜色,自定义SLTabbarButton 类的属性
        tabbar.showTitle = NO;
    }];
    [tabBarVC sl_setTbbarBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBar_bg"]]];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UILabel *_fpsLabel = [YYFPSLabel new];
        [_fpsLabel sizeToFit];
        _fpsLabel.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, 50, 20);
        [[UIApplication sharedApplication].keyWindow addSubview:_fpsLabel];
    });
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
