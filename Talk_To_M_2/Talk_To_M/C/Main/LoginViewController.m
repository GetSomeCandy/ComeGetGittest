//
//  LoginViewController.m
//  chatWithDemo
//
//  Created by EaseMob on 15/1/4.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "LoginViewController.h"

//#import "EMError.h"


@interface LoginViewController ()<UITextFieldDelegate>


- (IBAction)registerBtn:(id)sender;
- (IBAction)loginBtn:(id)sender;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupForDismissKeyboard];
    
    _account.delegate = self;
}

- (IBAction)registerBtn:(id)sender
{
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        if ([self.account.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"用户名不支持中文"
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        [self showHudInView:self.view hint:@"正在注册..."];
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_account.text
                                                             password:_password.text
                                                       withCompletion:
         ^(NSString *username, NSString *password, EMError *error) {
             [self hideHud];
             
             if (!error) {
                 TTAlertNoTitle(@"注册成功,请登录");
             }else{
                 switch (error.errorCode) {
                     case EMErrorServerNotReachable:
                         TTAlertNoTitle(@"连接服务器失败!");
                         break;
                     case EMErrorServerDuplicatedAccount:
                         TTAlertNoTitle(@"您注册的用户已存在!");
                         break;
                     case EMErrorServerTimeout:
                         TTAlertNoTitle(@"连接服务器超时!");
                         break;
                     default:
                         TTAlertNoTitle(@"注册失败");
                         break;
                 }
             }
         } onQueue:nil];
    }
}

- (IBAction)loginBtn:(id)sender
{
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        if ([_account.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"用户名不支持中文"
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
#if !TARGET_IPHONE_SIMULATOR
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"填写推送消息时使用的昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *nameTextField = [alert textFieldAtIndex:0];
        nameTextField.text = self.usernameTextField.text;
        [alert show];
#elif TARGET_IPHONE_SIMULATOR
        [self loginWithUsername:_account.text password:_password.text];
#endif

    }
}
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:@"正在登录"];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        [self hideHud];
        if (loginInfo && !error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            EMError * error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
            if (!error) {
                error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            }
        }
        else
        {
            switch (error.errorCode) {
                case EMErrorServerNotReachable:
                    TTAlertNoTitle(@"连接服务器失败!");
                    break;
                case EMErrorServerAuthenticationFailure:
                    TTAlertNoTitle(error.description);
                    break;
                case EMErrorServerTimeout:
                    TTAlertNoTitle(@"连接服务器超时!");
                    break;
                default:
                    TTAlertNoTitle(@"登录失败");
                    break;
            }
        }
    } onQueue:nil];
}

- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = _account.text;
    NSString *password = _password.text;
    if (username.length == 0 || password.length == 0) {
        ret = YES;
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"请输入账号和密码"
                     customizationBlock:nil
                        completionBlock:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles: nil];
    }
    
    return ret;
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _account) {
        _password.text = @"";
    }
    return YES;
}


@end
