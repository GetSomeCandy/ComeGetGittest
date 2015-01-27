//
//  BaseTableViewCell.h
//  Talk_To_M
//
//  Created by EaseMob on 15/1/26.
//  Copyright (c) 2015年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableCellDelegate <NSObject>

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BaseTableViewCell : UITableViewCell
{
    UILongPressGestureRecognizer * _headerLongPress;
}

@property (weak, nonatomic) id <BaseTableCellDelegate> delegate;

@property (strong, nonatomic)NSIndexPath * indexPath;

@property (strong, nonatomic)UIView * bottomLineView;

@end
