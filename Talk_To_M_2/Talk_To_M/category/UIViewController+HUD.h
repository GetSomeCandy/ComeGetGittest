//
//  UIViewController+HUD.h
//  chatWithDemo
//
//  Created by EaseMob on 15/1/13.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end
