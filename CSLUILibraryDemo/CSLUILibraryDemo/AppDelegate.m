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
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SLUIConfig share] configLabel:LabelH1 font:[UIFont boldSystemFontOfSize:36.0] color:nil];
    [[SLUIConfig share]configAlert:AlertView width:0 inset:UIEdgeInsetsMake(20, 16, 20, 16)];
    [[SLUIConfig share]configAlert:AlertSheet width:0 inset:UIEdgeInsetsMake(20, 16, 20, 16)];
    
    SLToastStyle *style = [SLUIConfig share].toastStyle;
    style.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    style.titleLabel.textColor = SLUIHexColor(0xffffff);
    style.titleLabel.font = SLUIBoldFont(17.0);
    style.messageLabel.textColor = SLUIHexColor(0xffffff);
    style.messageLabel.font = SLUINormalFont(17.0);
    style.width = kScreenWidth * 0.8;
    style.contentInsets = UIEdgeInsetsMake(20, 16, 20, 16);
    style.wraperView.backgroundColor = SLUIHexAlphaColor(0x585858, 0.9);;
    style.wraperViewSpace = 20.f;
    style.wraperViewRadius = 5.0f;
//    style.wraperViewShadowRadius = 5.0f;
//    style.wraperViewShadowColor = SLUIHexColor(0x000000);
//    style.wraperViewShadowOpacity = 0.5;
    style.imageSize = CGSizeMake(60, 60);
    style.imageAndTitleSpace = 10;
    style.titleSpace = 8;
    style.activitySize = CGSizeMake(100, 100);
    [[SLUIConfig share]configToastStyle:style];
    [SLImageDownLoader share].maxQueueCount = 10;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *homeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    
    SLTabBarController *tabBarVC = [[SLTabBarController alloc] init];
    [tabBarVC initViewControllers:@[homeVC] titles:@[@"home"] normalImages:@[[UIImage imageNamed:@"tabBar_home_normal"]] selectImages:@[[UIImage imageNamed:@"tabBar_home_press"]] navFlags:@[@(true)] layoutTabbar:^(SLTabbarView * _Nonnull tabbarView) {
        
    } configTabbarButton:^(SLTabbarButton * _Nonnull barButton,NSInteger index) {
        // 自定义选中文字颜色和未选中文字颜色,自定义SLTabbarButton 类的属性
        barButton.tabbarButtonType = SLButtonTypeOnlyImage;
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

//在应用处于后台，且后台任务下载完成时回调
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    NSURLSession *session = [SLDownloadManager sharedManager].session;
    NSLog(@"Rejoining session with identifier %@ %@", identifier, session);
    if ([[SLDownloadManager sharedManager].sessionCompleteHandle objectForKey:identifier]) {
       NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
    }
    [[SLDownloadManager sharedManager].sessionCompleteHandle setObject:completionHandler forKey:identifier];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(applyForMoreTime) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)applyForMoreTime {
    //如果系统给的剩余时间小于60秒 就终止当前的后台任务，再重新初始化一个后台任务，重新让系统分配时间，这样一直循环下去，保持APP在后台一直处于active状态。
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 10) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
            self.bgTask = UIBackgroundTaskInvalid;
        }];
    }
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
