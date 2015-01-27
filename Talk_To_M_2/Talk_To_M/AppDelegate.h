//
//  AppDelegate.h
//  Talk_To_M
//
//  Created by EaseMob on 15/1/16.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>
{
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController * mainController;

@end

