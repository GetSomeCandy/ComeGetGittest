//
//  UIViewController+DismissKeyBoard.m
//  chatWithDemo
//
//  Created by EaseMob on 15/1/13.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "UIViewController+DismissKeyBoard.h"

@implementation UIViewController (DismissKeyBoard)

- (void)setupForDismissKeyboard
{
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer * singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    
    __weak UIViewController * weakSelf = self;
    
    NSOperationQueue * mainQueue = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf.view addGestureRecognizer:singleTapGR];
    }];
    
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf.view removeGestureRecognizer:singleTapGR];
    }];
}

- (void)tapAnywhereToDismissKeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

@end
