//
//  TalkToViewController.m
//  Immortal_liang
//
//  Created by liang hong on 2019/2/6.
//  Copyright © 2019年 ideal. All rights reserved.
//

#import "TalkToViewController.h"
#import "TalkViewTableViewCell.h"

@interface TalkToViewController ()<PullDelegate,UITextViewDelegate>
{
    NSArray *talkDataArray;
    UITableView *tabelview;
    
    UITextView *talkInputText;
    UIButton *editTalkButton;
}
@end

@implementation TalkToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"交谈";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackReadDataNotice:) name:CALLBACKREADDATA object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackWriteDataNotice:) name:CALLBACKWRITEDATA object:nil];

    tabelview = [UIClassCss UITableCss0:CGRectMake(0, kNavigationBarH, kScreenwidth, kScreenHight -kNavigationBarH-CELLMOSTHEIGHT)];
    tabelview.separatorStyle = UITableViewCellEditingStyleNone;
    tabelview.delegate = self;
    tabelview.dataSource = self;
    tabelview.pullDelegate = self;
    tabelview.canPullDown = YES;
    [self.view addSubview:tabelview];
    
    UIView *footTalkView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHight- CELLMOSTHEIGHT, kScreenwidth, CELLMOSTHEIGHT)];
    [self.view addSubview:footTalkView];
    
    talkInputText = [[UITextView alloc] initWithFrame:CGRectMake(BORDERLINE, 0.1*CELLMOSTHEIGHT, kScreenwidth-0.8*CELLMOSTHEIGHT-3*BORDERLINE, 0.8*CELLMOSTHEIGHT)];
    talkInputText.font = [UIFont systemFontOfSize:16];
    talkInputText.textColor = [UIColor blackColor];
    talkInputText.layer.borderWidth = 1.0;
    talkInputText.layer.cornerRadius = 2;
    talkInputText.layer.borderColor = [[UIColor brownColor] CGColor];
    talkInputText.backgroundColor = [UIColor clearColor];
    [footTalkView addSubview:talkInputText];
    
    talkInputText.returnKeyType = UIReturnKeySend;//UIReturnKeySend;
    talkInputText.delegate = self;
    
    editTalkButton = [UIClassCss UIButtonCss0:CGRectMake(CGRectGetMaxX(talkInputText.frame),0.1*CELLMOSTHEIGHT ,kScreenwidth - CGRectGetMaxX(talkInputText.frame), 0.8*CELLMOSTHEIGHT) :@"发送"];
    [editTalkButton addTarget:self action:@selector(sendMsgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footTalkView addSubview:editTalkButton];

    [self performSelector:@selector(reloadTalkViewList) withObject:nil afterDelay:0.1];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyHeight = keyboardRect.size.height;
    self.keyInputView.hidden = NO;

    CGRect tempFrame = self.view.frame;
    tempFrame.origin.y = - keyHeight;
    self.view.frame = tempFrame;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //点击键盘return键,修改了return为发送
    if ([text isEqualToString:@"\n"])
    {
        [self.view endEditing:YES];
        self.view.frame = CGRectMake(0, 0, kScreenwidth, kScreenHight);
        [self sendMsgAction];
        return NO; //点击键盘return键后不允许再输入
    }
    return YES; //允许继续输入
}

//接收成功后收到消息
-(void)callBackReadDataNotice:(NSNotification *)note
{
    //不在当前页面不需要刷新
    if ([self isViewSelf])
    {
        NSString *readString = (NSString *)note.object;
        [self operationReadData:readString];
    }
    [self reloadTalkViewList];
}

//发送成功后收到消息
-(void)callBackWriteDataNotice:(NSNotification *)note
{
    //不在当前页面不需要刷新
    if ([self isViewSelf])
    {
        NSString *writeString = (NSString *)note.object;
        [self operationWriteData:writeString];
        talkInputText.text = @"";
        [self reloadTalkViewList];
    }
}

//发送消息
- (IBAction)sendMsgButtonAction:(id)sender {
    [self sendMsgAction];
}

-(void)sendMsgAction
{
    if ([ConvertValue isNULL:talkInputText.text]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"不能空发消息" message:@"" delegate:nil  cancelButtonTitle:@"确定"  otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    
    if (talkInputText.text.length > 2000) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"输入的内容不能超过2000字" message:@"" delegate:nil  cancelButtonTitle:@"确定"  otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    
    NSString *writeString = [[SaveShareObject shareSaveShareObject] assembleMessgeString:self.reciveId :talkInputText.text];
    [[TalkCoreObject shareInstance] sendMessageWithText:self.reciveId :writeString];
}

//刷新界面并存储缓存
-(void)reloadTalkViewList
{
    NSArray *tempArray = [[SaveShareObject shareSaveShareObject] getDataFromKeyWorld:self.reciveId];
    
    if (tempArray.count > 20)
    {
        NSMutableArray *tempMuArray = [[NSMutableArray alloc] init];
        for (int i = (int)tempArray.count - 20; i < tempArray.count; i ++) {
            NSDictionary *dict = [tempArray objectAtIndex:i];
            [tempMuArray addObject:dict];
        }
        talkDataArray = tempMuArray;
    }
    else
    {
        talkDataArray = tempArray;
    }
    
    if (talkDataArray.count > 0)
    {
        [tabelview reloadData];
        NSIndexPath* path = [NSIndexPath indexPathForRow: talkDataArray.count - 1 inSection:0];
        [tabelview scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return talkDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *talkDict = talkDataArray[indexPath.row];
    CGFloat talkCellHeight = [[talkDict objectForKey:@"talkCellHeight"] floatValue];
    return talkCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempTalkData = talkDataArray[indexPath.row];
    
    static NSString *CellIdentifier = @"TalkViewTableViewCell";
    TalkViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[TalkViewTableViewCell alloc] initWithSocketData];
    }
    [cell reloadTalkDeailListViews:tempTalkData];
    return cell;
}

#pragma mark - 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark UIScrollView PullDelegate
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state
{
    if (state == PullDownLoadState)
    {
        UITableView *tableView = (UITableView *)scrollView;
        [tableView stopLoadWithState:state];
        
        NSArray *tempArray = [[SaveShareObject shareSaveShareObject] getDataFromKeyWorld:self.reciveId];
        if (tempArray.count - talkDataArray.count > 20)
        {
            NSMutableArray *tempMuArray = [[NSMutableArray alloc] init];
            for (int i = (int)tempArray.count -(int)talkDataArray.count- 20; i < tempArray.count; i ++)
            {
                NSDictionary *dict = [tempArray objectAtIndex:i];
                [tempMuArray addObject:dict];
            }
            talkDataArray = tempMuArray;
        }
        else
        {
            talkDataArray = tempArray;
        }
        
        [tableView reloadData];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
