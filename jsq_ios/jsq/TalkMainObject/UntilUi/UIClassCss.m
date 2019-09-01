//
//  UIClassCss.m
//  Immortal_liang
//
//  Created by yes on 2017/5/2.
//  Copyright © 2017年 ideal. All rights reserved.
//

#import "UIClassCss.h"

@implementation UIClassCss

+(UITableView *)UITableCss0:(CGRect)frame
{
    UITableView *tempTable = [[UITableView alloc] initWithFrame:frame];
    [tempTable setShowsHorizontalScrollIndicator:NO];
    [tempTable setShowsVerticalScrollIndicator:NO];
    tempTable.backgroundColor = [UIColor whiteColor];
    tempTable.tableFooterView = [[UIView alloc] init];
    if ([tempTable respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tempTable setSeparatorInset:UIEdgeInsetsZero];
    }
//    if ([tempTable respondsToSelector:@selector(setLayoutMargins:)])
//    {
//        [tempTable setLayoutMargins:UIEdgeInsetsZero];
//    }
    return tempTable;
}

+(UIButton *)UIButtonCss0:(CGRect)frame :(NSString *)text
{
    UIButton *tempButton = [[UIButton alloc] initWithFrame:frame];
    [tempButton setBackgroundColor:[UIColor blueColor]];
    tempButton.showsTouchWhenHighlighted = YES;
    [tempButton setTitle:text forState:UIControlStateNormal];
    [tempButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    tempButton.layer.cornerRadius = 3;
    return tempButton;
}

//UITextField
+(UITextField *)UITextFieldCss0:(CGRect)frame :(NSString *)leftText :(NSString *)text
{
    UITextField *field = [[UITextField alloc] initWithFrame:frame];
    field.borderStyle=UITextBorderStyleNone;
    field.textAlignment=NSTextAlignmentCenter;
    field.backgroundColor=[UIColor whiteColor];
    field.placeholder=text;
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    field.font=[UIFont systemFontOfSize:14];
    field.keyboardType=UIKeyboardTypeNumberPad;
    
    UILabel *tempL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/4, frame.size.height)];
    tempL.text = leftText;
    tempL.textColor = [UIColor blackColor];
    tempL.textAlignment = NSTextAlignmentCenter;
    tempL.adjustsFontSizeToFitWidth = YES;
    field.leftView = tempL;
    
    field.leftViewMode = UITextFieldViewModeAlways;
    field.layer.borderWidth = 0.5;
    return field;
}
@end
