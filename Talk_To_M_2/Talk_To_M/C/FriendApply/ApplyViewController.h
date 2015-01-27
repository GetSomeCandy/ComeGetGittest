//
//  ApplyViewController.h
//  chatWithDemo
//
//  Created by EaseMob on 15/1/13.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ApplyStyleFriend = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;

@interface ApplyViewController : UITableViewController

@property (strong, nonatomic, readonly)NSMutableArray * dataSource;

+ (instancetype)shareController;

- (void)addNewApply:(NSDictionary *)dictionary;

- (void)loadDataSourceFromLocalDB;

- (void)clear;

@end
