//
//  AppDelegate.m
//  chatWithDemo
//
//  Created by EaseMob on 15/1/4.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "MobClick.h"
//#import "ApplyViewController.h"

@interface AppDelegate ()<EMChatManagerPushNotificationDelegate, IChatManagerDelegate, EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    NSArray * arr = NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSUserDomainMask, NO);
//    NSLog(@"%@", arr[0]);
    
    
    
    _connectionState = eEMConnectionConnected;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(78, 188, 211, 1)];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(245, 245, 245, 1), NSForegroundColorAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    
    //Umeng
    NSString * bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if ([bundleID isEqualToString:@"com.easemob.enterprise.demo.ui"]) {
        [MobClick startWithAppkey:@"5389bb7f56240ba94208ac97" reportPolicy:BATCH channelId:Nil];
    
#if DEBUG
        [MobClick setLogEnabled:YES];
#else
        [MobClick setLogEnabled:NO];
#endif
    }
    [self registerRemoteNotification];
    
    NSString * apnsCertName = nil;
#if DEBUG
    apnsCertName = @"chatwithu_dev";
#else
    apnsCertName = @"chatdemoui";
#endif
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"easemob-demo#chatdemoui" apnsCertName:apnsCertName];
    
#if DEBUG
    [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
#endif
    [[[EaseMob sharedInstance] chatManager] setIsAutoFetchBuddyList:YES];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //以下一行代码的方法里实现了自动登录，异步登录，需要监听[didLoginWithInfo: error:]
    //demo中此监听方法在MainViewController中
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [self loginStateChange:nil];
    [self.window makeKeyAndVisible];
    
    return YES;
    
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory=[paths objectAtIndex:0];
    //    NSLog(@"docu: %@", documentsDirectory);
    
    //    LoginViewController * loginVC = [[LoginViewController alloc] init];
    //
    //    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    //    self.window.rootViewController = nav;
    
    //    自己写的
    
    //    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    //    self.window.rootViewController = nav;
    
    //    在AppDelegate中注册SDK
    //    NSString * apnsCertName = @"chatwithu";
    //    [[EaseMob sharedInstance] registerSDKWithAppKey:@"half#chatwithu" apnsCertName:apnsCertName];
    //    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //    [self.window makeKeyAndVisible];
    //    return YES;
    
}

#pragma mark - 登录状态改变
- (void)loginStateChange:(NSNotification *)notification
{
    UINavigationController * nav = nil;
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {
        //        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        if (_mainController == nil) {
            _mainController = [[MainViewController alloc] init];
            [_mainController networkChanged:_connectionState];
            nav = [[UINavigationController alloc] initWithRootViewController:_mainController];
        }
        else
        {
            nav = _mainController.navigationController;
        }
    }
    else
    {
        _mainController = nil;
        LoginViewController * loginController = [[LoginViewController alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        loginController.navigationItem.title = @"环信Demo";
    }
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        nav.navigationBar.barStyle = UIBarStyleDefault;
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleBar"] forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar.layer setMasksToBounds:YES];
    }
    self.window.rootViewController = nav;
    
    [nav setNavigationBarHidden:YES];
    [nav setNavigationBarHidden:NO];
    
}



//配置apns相关函数（需要在真机上运行）
//自定义方法
- (void)registerRemoteNotification
{
#if !TARGET_IPHONE_SIMULATOR
    
    UIApplication * application = [UIApplication sharedApplication];
    
    //iOS8 注册apns
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
#endif
}

//系统方法
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

//系统方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

//系统方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

//系统方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    
}

#pragma mark - IChatManagerDelegate 收到好友请求添加
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    if (!username) {
        return;
    }
    if (!message) {
        message = [NSString stringWithFormat:@"%@ 添加你为好友", username];
    }
    //    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{
    //                                                                                @"title":username,
    //                                                                                @"username":username,
    //                                                                                @"applyMessage":message,
    //                                                                                @"applyStyle":[NSNumber numberWithInteger:0]
    //                                                                                }];
    //
    if (_mainController) {
        [_mainController setupUntreatedApplyCount];
    }
}

#pragma mark - IChatManagerDelegate 群组变化
- (void)didReceiveGroupInvitationFrom:(NSString *)groupId inviter:(NSString *)username message:(NSString *)message error:(EMError *)error
{
    if (!groupId || !username) {
        return;
    }
    NSString * groupName = groupId;
    if (!message || message.length == 0) {
        message = [NSString stringWithFormat:@"%@ 邀请你加入群组\'%@\'", username, groupName];
    }
    //    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupName, @"groupId":groupId, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:1]}];
    //    [[ApplyViewController shareController] addNewApply:dic];
    
    if (_mainController) {
        [_mainController setupUntreatedApplyCount];
    }
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId groupname:(NSString *)groupname applyUsername:(NSString *)username reason:(NSString *)reason error:(EMError *)error
{
    if (!groupId || !username) {
        return;
    }
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:@"%@ 申请加入群组\'%@\'", username, groupname];
    }
    else
    {
        reason = [NSString stringWithFormat:@"%@ 申请加入群组\'%@\'：%@", username, groupname, reason];
    }
    if (error) {
        NSString *message = [NSString stringWithFormat:@"发送申请失败:%@\n原因：%@", reason, error.description];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        //        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:2]}];
        //        [[ApplyViewController shareController] addNewApply:dic];
        if (_mainController) {
            [_mainController setupUntreatedApplyCount];
        }
    }
}

- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId groupname:(NSString *)groupname reason:(NSString *)reason error:(EMError *)error
{
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:@"被拒绝加入群组\'%@\'", groupname];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"申请提示" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    NSString * tmpStr = group.groupSubject;
    NSString * str;
    if (!tmpStr || tmpStr.length == 0) {
        NSArray * groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup * obj in groupArray) {
            if ([obj.groupId isEqualToString:group.groupId]) {
                tmpStr = obj.groupSubject;
                break;
            }
        }
    }
    if (reason == eGroupLeaveReason_BeRemoved) {
        str = [NSString stringWithFormat:@"你被从群组\'%@\'中踢出", tmpStr];
    }
    if (str.length > 0) {
        TTAlertNoTitle(str);
    }
}

#pragma mark - IChatManagerDelegate
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_mainController networkChanged:connectionState];
}

#pragma mark - EMChatManagerPushNotificationDelegate
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        TTAlertNoTitle(@"消息推送与设备绑定失败");
    }
}


@end
