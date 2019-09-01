//
//  BaseViewController.m
//  Immortal_liang
//
//  Created by 广东省深圳市 on 15/10/15.
//  Copyright © 2015年 YQ. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController()
{
    
}
@end
@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",[self class]);
        
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.keyInputView = [[UIView alloc] initWithFrame:self.view.frame];
    self.keyInputView.hidden = YES;
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.keyInputView addGestureRecognizer:pan];
    [[UIApplication sharedApplication].keyWindow addSubview:self.keyInputView];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    self.keyInputView.hidden = YES;
    [self.view endEditing:YES];
    self.view.frame = CGRectMake(0, 0, kScreenwidth, kScreenHight);
}

-(BOOL)isViewSelf
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count >= 1 && [viewControllers objectAtIndex:viewControllers.count-1] == self)
    {
        return YES;
    }
    return NO;
}

-(void)operationReadData:(NSString *)readString
{
    //生成存储的dict
    NSDictionary *talkDict = [[SaveShareObject shareSaveShareObject] buildReceveMessgeFrame:readString];
        
    //具体对话列表里增加数据
    NSString *tempReceveId = [talkDict objectForKey:@"talkId"];
    [[SaveShareObject shareSaveShareObject] addTalkIndexList:talkDict :tempReceveId];
    
    [[SaveShareObject shareSaveShareObject] upDataTalkIndexList:talkDict];
    
    //弹出头部聊天框
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        NSDate *now=[NSDate new];
        notification.fireDate=now;//多少秒后通知
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        notification.soundName= UILocalNotificationDefaultSoundName;
        notification.alertBody=[talkDict objectForKey:@"showTalkText"];//提示信息 弹出提示框
        notification.alertAction = @"消息";  //提示框按钮
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    //播放声音
    [ConvertValue voicePlay:@"notify" :@"wav"];
}

-(void)operationWriteData:(NSString *)writeString
{
    //解析成字典
    NSDictionary *talkFrameDict = [[SaveShareObject shareSaveShareObject] buildSendMessgeFrame:writeString];

    //存储进聊天详情列表,存储键值是对方的id
    [[SaveShareObject shareSaveShareObject] addTalkIndexList:talkFrameDict :[talkFrameDict objectForKey:@"reciveId"]];
    
    //更新聊天主列表
    NSMutableDictionary *tempMuDict = [[NSMutableDictionary alloc] initWithDictionary:talkFrameDict];
    [[SaveShareObject shareSaveShareObject] upDataTalkIndexList:tempMuDict];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
