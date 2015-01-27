//
//  NSString+Valid.m
//  chatWithDemo
//
//  Created by EaseMob on 15/1/13.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)

- (BOOL)isChinese
{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

@end
