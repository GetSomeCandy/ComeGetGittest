//
//  ChatListViewController.h
//  chatWithDemo
//
//  Created by EaseMob on 15/1/13.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "BaseViewController.h"

@interface ChatListViewController : BaseViewController

- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)reloadDataSource;

@end
