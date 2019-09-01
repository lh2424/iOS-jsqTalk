//
//  ViewController.m
//  jsq
//
//  Created by liang hong on 2019/8/23.
//  Copyright © 2019年 liang hong. All rights reserved.
//

#import "ViewController.h"
#import "TalkToViewController.h"
#import "NormalTableViewCell.h"
#import "UIClassCss.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    UITableView *tabelview;
    NSArray *tableArray;
    
    UITextField *fieldMyId,*fieldOtherId;
    UIButton *lognButton,*sendButton;
}
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    tableArray = [[SaveShareObject shareSaveShareObject] getTalkIndexList];
    [tabelview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"首页";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(actionLeftViewController)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_audio_open"] style:UIBarButtonItemStylePlain target:self action:@selector(actionRightController)];
    
    fieldMyId = [UIClassCss UITextFieldCss0:CGRectMake(0,kNavigationBarH, 4*kScreenwidth/5, HEIGHLINE) :@"我的登录id" :@"输入不超过4字节的数字"];
    fieldMyId.delegate = self;
    [self.view addSubview:fieldMyId];
    
    lognButton = [UIClassCss UIButtonCss0:CGRectMake(CGRectGetMaxX(fieldMyId.frame) ,kNavigationBarH,kScreenwidth/5-1 , HEIGHLINE) :@"登录"];
    [lognButton addTarget:self action:@selector(lognAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lognButton];
    
    UILabel *descriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(fieldMyId.frame), kScreenwidth, HEIGHLINE)];
    descriptLabel.text = @"请输入4字节范围的数";
    descriptLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:descriptLabel];
    
    fieldOtherId = [UIClassCss UITextFieldCss0:CGRectMake(0,CGRectGetMaxY(descriptLabel.frame)+1, 4*kScreenwidth/5, HEIGHLINE) :@"对方登录id" :@"输入不超过4字节的数字"];
    fieldOtherId.delegate = self;
    [self.view addSubview:fieldOtherId];
    
    sendButton = [UIClassCss UIButtonCss0:CGRectMake(CGRectGetMaxX(fieldOtherId.frame) ,CGRectGetMaxY(descriptLabel.frame)+1,kScreenwidth/5-1 , HEIGHLINE) :@"发送"];
    [sendButton addTarget:self action:@selector(sendMsgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    tabelview = [UIClassCss UITableCss0:CGRectMake(0, CGRectGetMaxY(fieldOtherId.frame), kScreenwidth, kScreenHight-CGRectGetMaxY(fieldOtherId.frame))];
    tabelview.delegate = self;
    tabelview.dataSource = self;
    [self.view addSubview:tabelview];
    
    UILongPressGestureRecognizer *longPress =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
    //长按代理
    longPress.delegate = self;
    longPress.minimumPressDuration = 1.5;
    //将长按手势添加到需要实现长按操作的视图里
    [tabelview addGestureRecognizer:longPress];
    
    //关键收到消息的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackReadDataNotice:) name:CALLBACKREADDATA object:nil];
    //
    NSDictionary *dict = [[SaveShareObject shareSaveShareObject] getLognData];
    if (dict !=nil) {
        [[SaveShareObject shareSaveShareObject] initlognData:dict];
        
        [[TalkCoreObject shareInstance] lognSocketWith:[dict objectForKey:@"socketId"]];
        
        fieldMyId.text = [dict objectForKey:@"socketText"];
        
        [fieldMyId setEnabled:NO];
        [lognButton setEnabled:NO];
    }
}

-(void)callBackReadDataNotice:(NSNotification *)note
{
    //如果在当前页面就处理数据刷新
    if ([self isViewSelf])
    {
        NSString *readString = (NSString *)note.object;
        [self operationReadData:readString];
        
        tableArray = [[SaveShareObject shareSaveShareObject] getTalkIndexList];
        [tabelview reloadData];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.keyInputView.hidden = NO;
    return YES;
}

-(void)actionLeftViewController
{
    [[TalkCoreObject shareInstance] exitSocket];
    [[SaveShareObject shareSaveShareObject] moveLognData];
    [fieldMyId setEnabled:YES];
    [lognButton setEnabled:YES];
    [ConvertValue showUIAlertViewWithString:@"退出登录成功"];
}

-(void)actionRightController
{
    //做一个声音开关功能
}

-(void)lognAction
{
    if ([ConvertValue isNULL:fieldMyId.text]) {
        [ConvertValue showUIAlertViewWithString:@"请输入您的登录编码"];
        return;
    }
    //数字转4字节流的字串
    NSString *socketId = [[TalkCoreObject shareInstance] stringFromInt:[fieldMyId.text intValue]];
    //登录,socketId不为空就算是业务逻辑登录
    [[TalkCoreObject shareInstance] lognSocketWith:socketId];
    //保存好昵称和头像链接
    NSString *tempNickName = [NSString stringWithFormat:@"登录id:%@",fieldMyId.text];
    NSDictionary *dict = @{@"socketId":socketId,@"socketText":fieldMyId.text,@"nickName":tempNickName,@"urlHead":@"http://thirdwx.qlogo.cn/mmopen/vi_32/Ir8CaJMYTUKIandPtzuDItZ2vwFamQg9w7rNC2JIFb7J92AIlwmTUglSXJSqCxKLyCxCCamkEjYgMwjGeNcibKA/132"};
    [[SaveShareObject shareSaveShareObject] initlognData:dict];
    
    [fieldMyId setEnabled:NO];
    [lognButton setEnabled:NO];
    
    [ConvertValue showUIAlertViewWithString:@"登录成功"];
}

-(void)sendMsgAction
{
    if ([ConvertValue isNULL:fieldOtherId.text]) {
        [ConvertValue showUIAlertViewWithString:@"请输入对方的登录编码"];
        return;
    }
    
    TalkToViewController *tempVC = [[TalkToViewController alloc] init];
    tempVC.reciveId = [[TalkCoreObject shareInstance] stringFromInt:[fieldOtherId.text intValue]];
    [self.navigationController pushViewController:tempVC animated:YES];
}

- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gestureRecognizer locationInView:tabelview];
        NSIndexPath *indexPath = [tabelview indexPathForRowAtPoint:point];
        if(indexPath == nil)
        {
            return;
        }
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"是否删除该聊天对话" message:@"" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确定删除",nil];
        alert.tag = indexPath.row;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSMutableArray *tempMuArray = [[NSMutableArray alloc] initWithArray:tableArray];
        [tempMuArray removeObjectAtIndex:alertView.tag];
        
        [[SaveShareObject shareSaveShareObject] setTalkIndexList:tempMuArray];
        tableArray = tempMuArray;
        [tabelview reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_INDEX;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *talkDict = tableArray[indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[NormalTableViewCell alloc] initNormalListWithStyleDict:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell reloadCellWithDict:talkDict];
    return cell;
}

#pragma mark - 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([ConvertValue isNULL:[[TalkCoreObject shareInstance] socketId]])
    {
        [ConvertValue showUIAlertViewWithString:@"请先设置登录编码"];
        return;
    }

    NSDictionary *dict = tableArray[indexPath.row];
    NSString *remind = [dict objectForKey:@"remind"];
    if (![ConvertValue isNULL:remind]) {
        NSMutableDictionary *tempMuDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [tempMuDict removeObjectForKey:@"remind"];
        [[SaveShareObject shareSaveShareObject] upDataTalkIndexList:tempMuDict];
        [tableView reloadData];
    }

    NSString *reciveId =[dict objectForKey:@"talkId"];
    if ([reciveId isEqualToString:[[SaveShareObject shareSaveShareObject] socketId]])
    {
        reciveId =[dict objectForKey:@"reciveId"];
    }
    
    TalkToViewController *tempVC = [[TalkToViewController alloc] init];
    tempVC.reciveId = reciveId;
    [self.navigationController pushViewController:tempVC animated:YES];
}

@end
