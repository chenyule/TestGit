//
//  AppDelegate.m
//  SearchCar
//
//  Created by a11 on 2019/5/29.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"
#import <IQKeyboardManager.h>
#import <AFNetworking.h>
#import "WebViewController.h"

#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>

#endif


#define PUSHKEY @"f4a60141fa64bc3b0c5517ff"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initKeyBoard];
    
    [self initPush:launchOptions];
    
    //2019-06-03 18:08:37
    NSTimeInterval baseTime = 1559623725;//2019-06-04 12:48:44
    
    NSTimeInterval endTime = baseTime + 10 * 24 * 60 *60;
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentTimeStamp = [currentDate timeIntervalSince1970];
    
    NSLog(@"xxxxx");
    
    
    if (currentTimeStamp > endTime) {
        
        [self requestHostData];
        
    }else{
        
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        ListViewController *carList = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:carList];
        
        self.window.rootViewController = nav;
        
        [self.window makeKeyWindow];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
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


- (void)initPush:(NSDictionary *)launchOptions{
    
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:PUSHKEY
                          channel:@""
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)initKeyBoard
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
}



#pragma mark - 请求数据


- (void)requestHostData{
    
    /* 展示问题 */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 60;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy =[AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    NSDictionary *param = @{@"appid":@"1466732814"};
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[UIViewController alloc] init];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyWindow];
    
    [manager POST:@"http://appid.985-985.com:8088/getAppConfig.php" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(responseObject){
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if ([dict[@"success"] isEqual:@"true"])
            {
                
                if ([dict[@"ShowWeb"] intValue] == 1)
                {
                    WebViewController *web=[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
                    
                    web.url=dict[@"Url"];
                    
                    self.window.rootViewController = web;
                    
                }
            }else{
                
                ListViewController *carList = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:carList];
                
                self.window.rootViewController = nav;
                
            }
        }else{
            
            ListViewController *carList = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:carList];
            
            self.window.rootViewController = nav;
            
        }
    } failure:nil];
    
    
}


@end
