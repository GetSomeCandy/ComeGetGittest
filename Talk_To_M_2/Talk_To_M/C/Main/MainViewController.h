//
//  MainViewController.h
//  chatWithDemo
//
//  Created by EaseMob on 15/1/4.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "BaseViewController.h"
#import "EaseMob.h"

@interface MainViewController : UITabBarController
{
    EMConnectionState _connectionState;
}

- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)networkChanged:(EMConnectionState)connectionState;

@end
