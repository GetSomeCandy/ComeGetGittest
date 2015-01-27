//
//  ChatListViewController.m
//  chatWithDemo
//
//  Created by EaseMob on 15/1/13.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "ChatListViewController.h"

@interface ChatListViewController ()


@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UITableView * tableView;


@end

@implementation ChatListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)refreshDataSource
{
    
}

- (void)isConnect:(BOOL)isConnect
{
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        
    }
}

- (void)reloadDataSource
{
    
}

@end
