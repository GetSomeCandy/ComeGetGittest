//
//  MainViewController.m
//  chatWithDemo
//
//  Created by EaseMob on 15/1/4.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "MainViewController.h"

#import "ChatListViewController.h"
#import "ContactsViewController.h"
#import "SettingViewController.h"
#import "ApplyViewController.h"

static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface MainViewController ()<UIAlertViewDelegate, IChatManagerDelegate>
{
    ChatListViewController * _chatListVC;
    ContactsViewController * _contactsVC;
    SettingViewController * _settingsVC;
    
    UIBarButtonItem * _addFriendItem;
}

@property (strong, nonatomic) NSDate * lastPlaySoundDate;

@end


@implementation MainViewController

- (void)dealloc
{
    [self unregisterNotifications];
}

- (void)viewDidLoad
{
     //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"会话";
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [self didUnreadMessagesCountChanged];
    
    [self registerNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    
    [self setupSubviews];
    
    self.selectedIndex = 0;
    
    UIButton * addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addButton addTarget:_contactsVC action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    _addFriendItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
}

- (void)setupSubviews
{
    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbarBackground"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed:@"tabbarSelectBg"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    
    _chatListVC = [[ChatListViewController alloc] init];
    [_chatListVC networkChanged:_connectionState];
    
    _chatListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"会话" image:[UIImage imageNamed:@"tabbar_chatsHL"] selectedImage:[UIImage imageNamed:@"tabbar_chats"]];
    
    [self unSelectedTapTabBarItems:_chatListVC.tabBarItem];
    [self selectedTapTabBarItems:_chatListVC.tabBarItem];
    
    _contactsVC = [[ContactsViewController alloc] initWithNibName:nil bundle:nil];
    _contactsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"通讯录" image:[UIImage imageNamed:@"tabbar_contactsHL"] selectedImage:[UIImage imageNamed:@"tabbar_contacts"]];
    [self unSelectedTapTabBarItems:_contactsVC.tabBarItem];
    [self selectedTapTabBarItems:_contactsVC.tabBarItem];
    
    _settingsVC = [[SettingViewController alloc] init];
    _settingsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"tabbar_settingHL"] selectedImage:[UIImage imageNamed:@"tabbar_setting"]];
    _settingsVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self unSelectedTapTabBarItems:_settingsVC.tabBarItem];
    [self selectedTapTabBarItems:_settingsVC.tabBarItem];
    
    self.viewControllers = @[_chatListVC, _contactsVC, _settingsVC];
    [self selectedTapTabBarItems:_chatListVC.tabBarItem];
    
//    NSLog(@"tabBar: %lf", self.tabBar.bounds.size.height);
    
}

#pragma mark - tabBar选中和未选中样式
- (void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}
- (void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor colorWithRed:0.393 green:0.553 blue:1.000 alpha:1.000], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
}

#pragma mark - 注册推送
- (void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - // 统计未读消息数
- (void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)setupUnreadMessageCount
{
    NSArray * conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation * conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", unreadCount];
        }
        else
        {
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    UIApplication * application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
//    [application setApplicationIconBadgeNumber:2];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0) {
        self.navigationItem.title = @"会话";
        self.navigationItem.rightBarButtonItem = nil;
    }
    else if (item.tag == 1)
    {
        self.navigationItem.title = @"通讯录";
        self.navigationItem.rightBarButtonItem = _addFriendItem;
    }
    else if (item.tag == 2)
    {
        self.navigationItem.title = @"设置";
        self.navigationItem.rightBarButtonItem = nil;
        [_settingsVC refreshConfig];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
                [[ApplyViewController shareController] clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            } onQueue:nil];
        }
    }
    else if (alertView.tag == 100)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else if (alertView.tag == 101)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

#pragma mark - IChatManagerDelegate 消息变化
- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [_chatListVC refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self setupUnreadMessageCount];
}

#pragma mark - 离线消息
- (void)didFinishedReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages
{
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    
    NSArray * igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString * str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    if (ret) {
        EMPushNotificationOptions * options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        
        do {
            if (options.noDisturbing) {
                NSDate * now = [NSDate date];
                NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:now];
                NSInteger hour = [components hour];
                NSUInteger startH = options.noDisturbingStartH;
                NSUInteger endH = options.noDisturbingEndH;
                if (startH > endH) {
                    endH += 24;
                }
                if (hour > startH && hour <= endH) {
                    ret = NO;
                    break;
                }
            }
        } while (0);
    }
    
    return ret;
}

#pragma mark - 收到消息回调
- (void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification  = message.isGroup ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {

#if !TARGET_IPHONE_SIMULATOR
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }
        else
        {
            [self playSoundAndVibration];
        }
        
#endif
    }
}

- (void)didReceiveCmdMessage:(EMMessage *)cmdMessage
{
    [self showHint:@"有透传消息"];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions * options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    
    //本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date];
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString * messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = @"[图片]";
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = @"[位置]";
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = @"[音频]";
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = @"[视频]";
            }
                break;

            default:
                break;
        }
        
        NSString * title = message.from;
        if (message.isGroup) {
            NSArray * groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup * group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else
    {
        notification.alertBody = @"您有一条新消息";
    }
    
    //去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    UIApplication * application = [UIApplication sharedApplication];
//    application.applicationIconBadgeNumber += 1;
    
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）
- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        /*
        NSString * hintText = @"";
        if (error.errorCode != EMErrorServerMaxRetryCountExceeded) {
            if (![[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled]) {
                hintText = @"你的账号登录失败，请重新登录";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:hintText
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil,
                                          nil];
                alertView.tag = 99;
                [alertView show];
            }
        }
        else
        {
            hintText = @"已达到最大登陆重试次数，请重新登陆";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:hintText
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil,
                                      nil];
            alertView.tag = 99;
            [alertView show];

        }
         */
        
        NSString * hintText = @"你的账号登录失败，正在重试中... \n点击 '登出' 按钮跳转到登录页面 \n点击 '继续等待' 按钮等待重连成功";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:@"继续等待"
                                                  otherButtonTitles:@"登出",
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_chatListVC isConnect:NO];
    }
}


#pragma mark - IChatManagerDelegate 好友请求
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive;
    if (!isAppActivity) {
        UILocalNotification * notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];// 设置推送时间
        notification.alertBody = [NSString stringWithFormat:@"%@ %@", username, @"添加你为好友"];
        notification.alertAction = @"打开";
        notification.timeZone = [NSTimeZone defaultTimeZone];// 设置时区
    }

#endif
    [_contactsVC reloadApplyView];
}

#pragma mark - 更新好友列表
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd
{
    [_contactsVC reloadDataSource];
}

- (void)didRemovedByBuddy:(NSString *)username
{
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:YES];
    [_chatListVC reloadDataSource];
    [_contactsVC reloadDataSource];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
    [_contactsVC reloadDataSource];
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString * message = [NSString stringWithFormat:@"你被'%@'无耻的拒绝了", username];
    TTAlertNoTitle(message);
}

- (void)didAcceptBuddySucceed:(NSString *)username
{
    [_contactsVC reloadDataSource];
}

#pragma mark - IChatManagerDelegate 群组变化
- (void)didReceiveGroupInvitationFrom:(NSString *)groupId inviter:(NSString *)username message:(NSString *)message error:(EMError *)error
{
    if (!error) {
        
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
    [_contactsVC reloadGroupView];
    
    }
}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId invitee:(NSString *)username reason:(NSString *)reason error:(EMError *)error
{
    NSString * message = [NSString stringWithFormat:@"你被'%@'无耻的拒绝了", username];
    TTAlertNoTitle(message);
}

- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId groupname:(NSString *)groupname error:(EMError *)error
{
    NSString * message = [NSString stringWithFormat:@"同意加入群组\'%@\'", groupname];
    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 登录状态变化
- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"你的账号已在其他地方登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,
                                  nil];
        alertView.tag = 100;
        [alertView show];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"你的账号已被从服务器端移除"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,
                                  nil];
        alertView.tag = 101;
        [alertView show];
        
    } onQueue:nil];
}

#pragma mark - 自动登录回调
- (void)willAutoReconnect
{
    [self hideHud];
    [self showHudInView:self.view hint:@"正在重连中..."];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error
{
    [self hideHud];
    if (error) {
        [self showHint:@"重连失败，稍候将继续重连"];
    }
    else
    {
        [self showHint:@"重连成功"];
    }
}



#pragma mark - 响铃
- (void)playSoundAndVibration
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringring & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    self.lastPlaySoundDate = [NSDate date];
    
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}

//自身实现的的方法
- (void)jumpToChatList
{
    if (_chatListVC) {
        [self.navigationController popToViewController:self animated:YES];
        [self setSelectedViewController:_chatListVC];
    }
}

- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (_contactsVC) {
        if (unreadCount > 0) {
            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", unreadCount];
        }
        else
        {
            _contactsVC.tabBarItem.badgeValue = nil;
        }
    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

@end
