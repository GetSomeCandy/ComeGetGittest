//
//  BaseTableViewCell.m
//  Talk_To_M
//
//  Created by EaseMob on 15/1/26.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bottomLineView = [[UIView alloc] init];
        
        //淡黄绿色。。
        _bottomLineView.backgroundColor = [UIColor colorWithRed:207 / 255.0 green:210 / 155.0 blue:213 / 255.0 alpha:0.7];
        [self.contentView addSubview:_bottomLineView];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        //长按手势
        _headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:_headerLongPress];

    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10, 8, 34, 34);
    
    CGRect rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 10;
    self.textLabel.frame = rect;
    
    _bottomLineView.frame = CGRectMake(0, self.contentView.frame.size.height - 1, self.contentView.frame.size.width, 1);
}


#pragma mark - 长按手势触发操作，例如长按好友，弹出加入黑名单
- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellImageViewLongPressAtIndexPath:)]) {
            [_delegate cellImageViewLongPressAtIndexPath:self.indexPath];
        }
    }
}

@end
