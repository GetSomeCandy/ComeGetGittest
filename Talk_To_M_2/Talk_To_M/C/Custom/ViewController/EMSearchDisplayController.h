//
//  EMSearchDisplayController.h
//  Talk_To_M
//
//  Created by EaseMob on 15/1/26.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMSearchDisplayController : UISearchDisplayController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray * resultSource;

//编辑cell时显示的风格，默认为UITableViewCellEditingStyleDelete；会将值付给[tableView:editingStyleForRowAtIndexPath:]
@property (nonatomic) UITableViewCellEditingStyle editingStyle;

@property (copy) UITableViewCell * (^cellForRowAtIndexPathCompletion)(UITableView * tableView, NSIndexPath * indexPath);

@property (copy) BOOL (^canEditRowAtIndexPath)(UITableView * tableView, NSIndexPath * indexPath);
@property (copy) CGFloat (^heightForRowAtIndexPathCompletion)(UITableView * tableView, NSIndexPath * indexPath);
@property (copy) void (^didSelectRowAtIndexPathCompletion)(UITableView * tableView, NSIndexPath * indexPath);
@property (copy) void (^didDeselectRowAtIndexPathCompletion)(UITableView * tableView, NSIndexPath * indexPath);

@end
