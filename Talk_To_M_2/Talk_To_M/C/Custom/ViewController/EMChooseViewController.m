//
//  EMChooseViewController.m
//  chatWithDemo
//
//  Created by EaseMob on 15/1/6.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "EMChooseViewController.h"

@interface EMChooseViewController ()

@end

@implementation EMChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"chooseEMCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

@end
