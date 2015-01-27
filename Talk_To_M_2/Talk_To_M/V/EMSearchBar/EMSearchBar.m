//
//  EMSearchBar.m
//  Talk_To_M
//
//  Created by EaseMob on 15/1/26.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "EMSearchBar.h"

@implementation EMSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (UIView * subView in self.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subView removeFromSuperview];
            }
            
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField * textField = (UITextField *)subView;
                [textField setBorderStyle:UITextBorderStyleNone];
                textField.background = nil;
                textField.frame = CGRectMake(8, 8, self.bounds.size.width - 2 * 8, self.bounds.size.height - 2 * 8);
                textField.layer.cornerRadius = 6;
                textField.clipsToBounds = YES;
                textField.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    return self;
}

//取消按钮 title是自定义文字
- (void)setCancelButtonTitle:(NSString *)title
{
    for(UIView * searchbuttons in self.subviews)
    {
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton * cancleBtn = (UIButton *)searchbuttons;
            [cancleBtn setTitle:title forState:UIControlStateNormal];
            break;
        }
        
    }
}

@end
