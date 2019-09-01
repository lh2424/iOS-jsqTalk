//
//  BaseViewController.h
//  Immortal_liang
//
//  Created by 广东省深圳市 on 15/10/15.
//  Copyright © 2015年 YQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic,retain)UIView *keyInputView;

-(BOOL)isViewSelf;
-(void)operationReadData:(NSString *)readString;
-(void)operationWriteData:(NSString *)writeString;
@end
