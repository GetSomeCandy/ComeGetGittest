//
//  EMChooseViewController.h
//  chatWithDemo
//
//  Created by EaseMob on 15/1/6.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol EMChooseViewDelegate ;

@interface EMChooseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    __weak id<EMChooseViewDelegate> _delegate;
}


@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (weak, nonatomic) id <EMChooseViewDelegate> delegate;
@property (strong, nonatomic) UILocalizedIndexedCollation * indexCollation; //搜索核心

/**
 *  是否多选，默认NO
 *
 *  初始化类之后设置
 */
@property (nonatomic) BOOL mulChoice;

/**
 *  默认是否处于编辑状态，默认NO
 *
 *  初始化类之后设置
 *  YES：点击cell呈选中状态
 *  NO：点击菜单栏“选择”，然后处于编辑状态
 */
@property (nonatomic) BOOL defaultEditing;

/**
 *  是否显示所有索引（A-#），默认NO
 *
 *  初始化类之后设置
 */
@property (nonatomic) BOOL showAllIndex;

/**
 *  获取每个元素比较的字符串，必须在[viewDidLoad]或者[viewDidLoadBlock]或者[viewControllerLoadDataSource:]调用之前设置
 */
@property (copy) NSString * (^objectComparisonStringBlock)(id object);

/**
 *  页面加载完成的回调
 */
@property (copy) void (^viewDidLoadBlock)(EMChooseViewController * controller);

/**
 *  获取数据源的回调 (也可通过实现代理方法中的[viewControllerLoadDataSource:])
 */
@property (copy) void (^loadDataSourceBlock)(EMChooseViewController * controller);

@property (copy) UITableViewCell * (^cellForRowAtIndexPath)(UITableView * tableView, NSIndexPath * indexPath);

@property (copy) CGFloat (^heightForRowAtIndexPathCompletion)(id object);

@property (copy) void (^didSelectRowAtIndexPathCompletion)(id object);


#pragma mark - 以下方法可作为继承类重写
#warning 继续写代码


@end
