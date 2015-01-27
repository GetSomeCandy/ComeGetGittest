//
//  ApplyViewController.m
//  chatWithDemo
//
//  Created by EaseMob on 15/1/13.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "ApplyViewController.h"

@interface ApplyViewController ()

@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


+ (instancetype)shareController
{
    return nil;
}

- (void)addNewApply:(NSDictionary *)dictionary
{
    
}

- (void)loadDataSourceFromLocalDB
{
    
}

- (void)clear
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"ApplyCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"1";
    return cell;
}



@end
