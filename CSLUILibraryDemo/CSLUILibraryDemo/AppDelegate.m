//
//  AppDelegate.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/10/31.
//  Copyright © 2019 csl. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SLUIConfig share] configLabel:LabelH1 font:[UIFont boldSystemFontOfSize:36.0] color:nil];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *homeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    
    SLTabBarController *tabBarVC = [[SLTabBarController alloc] init];
    [tabBarVC initViewControllers:@[homeVC] titles:@[@"home"] normalImages:@[[UIImage imageNamed:@"3.jpg"]] selectImages:@[[UIImage imageNamed:@"3.jpg"]] layoutTabbar:^(SLTabbarButton * _Nonnull tabbarBt) {
        [tabbarBt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [tabbarBt setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        tabbarBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [tabbarBt.titleLabel setFrame:CGRectMake(0, 0, tabbarBt.bounds.size.width, tabbarBt.bounds.size.height-30)];
        [tabbarBt.imageView setFrame:CGRectMake((tabbarBt.bounds.size.width-30)/2, tabbarBt.bounds.size.height-30, 30, 30)];
    }];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
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
