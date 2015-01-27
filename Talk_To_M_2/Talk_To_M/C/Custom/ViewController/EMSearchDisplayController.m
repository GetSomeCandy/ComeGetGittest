//
//  EMSearchDisplayController.m
//  Talk_To_M
//
//  Created by EaseMob on 15/1/26.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "EMSearchDisplayController.h"
#import "BaseTableViewCell.h"

@implementation EMSearchDisplayController

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController
{
    self = [super initWithSearchBar:searchBar contentsController:viewController];
    if (self) {
        _resultSource = [NSMutableArray array];
        _editingStyle = UITableViewCellEditingStyleDelete;
        
        self.searchResultsDataSource = self;
        self.searchResultsDelegate = self;
        self.searchResultsTitle = @"搜索结果";
    }
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellForRowAtIndexPathCompletion) {
        return _cellForRowAtIndexPathCompletion(tableView, indexPath);
    }
    else
    {
        static NSString * CellIdentifier = @"ContactListCell";
        BaseTableViewCell * cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
}

@end
