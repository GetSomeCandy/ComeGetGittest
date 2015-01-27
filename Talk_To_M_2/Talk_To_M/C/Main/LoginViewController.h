//
//  LoginViewController.h
//  chatWithDemo
//
//  Created by EaseMob on 15/1/4.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController :BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
