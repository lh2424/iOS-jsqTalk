//
//  SaveShareObject.m
//  BaseCase
//
//  Created by liang hong on 2019/4/12.
//  Copyright © 2019年 lxjr. All rights reserved.
//

#import "SaveShareObject.h"

#define TALKLOGNDATA @"TalkLognDataSaveShareObject"

#define TALKMAINLIEST @"TalkIndexListSaveShareObject"

static SaveShareObject *savediction = nil;

@implementation SaveShareObject

+(id)shareSaveShareObject
{
    if (savediction == nil)
    {
        savediction= [[SaveShareObject alloc] init];
    }
    return savediction;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    //只会执行一次
    dispatch_once(&onceToken,^{
        savediction = [super allocWithZone:zone];
    });
    return savediction;
}

-(void)initlognData:(NSDictionary *)dict
{
    [[SaveShareObject shareSaveShareObject] setSocketId:[dict objectForKey:@"socketId"]];
    [[SaveShareObject shareSaveShareObject] setNickName:[dict objectForKey:@"nickName"]];
    [[SaveShareObject shareSaveShareObject] setUrlHead:[dict objectForKey:@"urlHead"]];

    [self setLognData:dict];
}

#pragma 获取登录数据
-(NSDictionary *)getLognData
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:TALKLOGNDATA];
}

#pragma 保存登录数据
-(void)setLognData:(NSDictionary *)dict
{
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:TALKLOGNDATA];
}

#pragma 获取登录数据
-(void)moveLognData
{
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:TALKLOGNDATA];
}

-(NSDictionary *)buildSendMessgeFrame:(NSString *)tempStr
{
    NSDictionary *talkDict = [self changeMessageData:tempStr];

    NSString *talkText = [talkDict objectForKey:@"showTalkText"];
    //文字解析成dict
    CGFloat maxWith = kScreenwidth-3*BORDERLINE-50;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGRect tempRectW = [talkText boundingRectWithSize:CGSizeMake(0,UNITEHEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
    
    CGFloat talkTextWith,talkTextHeight,talkCellHeight;
    CGFloat pointX = BORDERLINE;
    
    if (tempRectW.size.width+2*UNITEHEIGHT < maxWith &&![talkText containsString:@"\n"]&&![talkText containsString:@"\r"])
    {
        talkTextWith = tempRectW.size.width+2*UNITEHEIGHT;
        talkTextHeight = 2*UNITEHEIGHT;
        talkCellHeight = 50+2*BORDERLINE;
        pointX = kScreenwidth - 2*BORDERLINE-50 - talkTextWith;
    }
    else
    {
        CGRect tempRectH = [talkText boundingRectWithSize:CGSizeMake(maxWith,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, maxWith, 0)];
        textView.text = talkText;
        textView.font = [UIFont systemFontOfSize:16];
        [textView sizeToFit];
        talkTextWith = maxWith;
        talkTextHeight = tempRectH.size.height+2*UNITEHEIGHT;
        talkCellHeight = UNITEHEIGHT+BORDERLINE+textView.frame.size.height;
    }
    
    CGRect talkFrame = CGRectMake(pointX, 0, talkTextWith, talkTextHeight);
    NSDictionary *talkDiction = @{
                                  @"talkId":[talkDict objectForKey:@"talkId"],
                                  @"reciveId":[talkDict objectForKey:@"reciveId"],
                                  @"showName":[talkDict objectForKey:@"showName"],
                                  @"showImageUrl":[talkDict objectForKey:@"showImageUrl"],
                                  @"showImageBack":@"right_chat_bg",
                                  @"showTalkText":talkText,
                                  @"talkFrameX":[NSString stringWithFormat:@"%f",talkFrame.origin.x],
                                  @"talkFrameY":[NSString stringWithFormat:@"%f",talkFrame.origin.y],
                                  @"talkFrameW":[NSString stringWithFormat:@"%f",talkFrame.size.width],
                                  @"talkFrameH":[NSString stringWithFormat:@"%f",talkFrame.size.height],
                                  @"timeNumber":[NSString stringWithFormat:@"%ld",time(NULL)],
                                  @"talkCellHeight":[NSString stringWithFormat:@"%f",talkCellHeight]};
    return talkDiction;
}

-(NSDictionary *)buildReceveMessgeFrame:(NSString *)tempStr
{
    //文字解析成dict
    NSDictionary *talkDict = [self changeMessageData:tempStr];

    //解析内容计算UI的大小
    NSString *talkText = [talkDict objectForKey:@"showTalkText"];
    NSLog(@"收到消息内容:%@",talkText);
    
    CGFloat maxWith = kScreenwidth-3*BORDERLINE-50;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGRect tempRectW = [talkText boundingRectWithSize:CGSizeMake(0,UNITEHEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
    
    CGFloat talkTextWith,talkTextHeight,talkCellHeight;
    CGFloat pointX = BORDERLINE;
    
    if (tempRectW.size.width+2*UNITEHEIGHT < maxWith)
    {
        talkTextWith = tempRectW.size.width+2*UNITEHEIGHT;
        talkTextHeight = 2*UNITEHEIGHT;
        talkCellHeight = 50+2*BORDERLINE;
        pointX = kScreenwidth - 2*BORDERLINE-50 - talkTextWith;
    }
    else
    {
        CGRect tempRectH = [talkText boundingRectWithSize:CGSizeMake(maxWith,0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
        talkTextWith = maxWith;
        talkTextHeight = tempRectH.size.height+2*UNITEHEIGHT;
        talkCellHeight = UNITEHEIGHT+BORDERLINE+talkTextHeight;
    }
    CGRect talkFrame = CGRectMake(pointX, 0, talkTextWith, talkTextHeight);
    
    NSDictionary *talkDiction = @{
                                  @"talkId":[talkDict objectForKey:@"talkId"],
                                  @"reciveId":[talkDict objectForKey:@"reciveId"],
                                  @"showName":[talkDict objectForKey:@"showName"],
                                  @"showImageUrl":[talkDict objectForKey:@"showImageUrl"],
                                  @"showImageBack":@"right_chat_bg",
                                  @"showTalkText":talkText,
                                  @"talkFrameX":[NSString stringWithFormat:@"%f",talkFrame.origin.x],
                                  @"talkFrameY":[NSString stringWithFormat:@"%f",talkFrame.origin.y],
                                  @"talkFrameW":[NSString stringWithFormat:@"%f",talkFrame.size.width],
                                  @"talkFrameH":[NSString stringWithFormat:@"%f",talkFrame.size.height],
                                  @"timeNumber":[NSString stringWithFormat:@"%ld",time(NULL)],
                                  @"talkCellHeight":[NSString stringWithFormat:@"%f",talkCellHeight]};
    return talkDiction;
}

#pragma 组装text成dict的string类型,过滤掉一些非法或复杂的内容都在这里处理
-(NSString *)assembleMessgeString:(NSString *)reciveId :(NSString *)talkText
{
    NSString *jsonStr = talkText;
    
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"(\')" withString:@"\\\\'" options:NSRegularExpressionSearch range:NSMakeRange(0, jsonStr.length)];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"(\n)" withString:@"\\\\n" options:NSRegularExpressionSearch range:NSMakeRange(0, jsonStr.length)];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"(\r)" withString:@"\\\\r" options:NSRegularExpressionSearch range:NSMakeRange(0, jsonStr.length)];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"(\t)" withString:@"\\\\t" options:NSRegularExpressionSearch range:NSMakeRange(0, jsonStr.length)];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"(\f)" withString:@"\\\\f" options:NSRegularExpressionSearch range:NSMakeRange(0, jsonStr.length)];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"(\b)" withString:@"\\\\b" options:NSRegularExpressionSearch range:NSMakeRange(0, jsonStr.length)];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"(\v)" withString:@"\\\\v" options:NSRegularExpressionSearch range:NSMakeRange(0, jsonStr.length)];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"(\\\\)" withString:@"\\\\\\\\" options:NSRegularExpressionSearch range:NSMakeRange(0, jsonStr.length)];
    //talkId
    NSDictionary *infoDict = @{@"talkId":[[SaveShareObject shareSaveShareObject] socketId],@"showName":[[SaveShareObject shareSaveShareObject] nickName],@"showImageUrl":[[SaveShareObject shareSaveShareObject] urlHead],@"showTalkText":jsonStr,@"remind":@"1",@"reciveId":reciveId};
    //remind设置为1表示未读信息,可以根据情况改变

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict options:0 error:0];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return dataStr;
}

#pragma 解析组装的string为dict
-(NSDictionary *)changeMessageData:(NSString *)talkText
{
    NSData *jsonData = [talkText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dict;
}

#pragma 获取
-(NSArray *)getDataFromKeyWorld:(NSString *)keyWorld
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyWorld];
}

#pragma 获取主聊天列表
-(NSArray *)getTalkIndexList
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:TALKMAINLIEST];
}

#pragma 增加
-(void)addTalkIndexList:(NSDictionary *)dict :(NSString *)keyWorld
{
    NSArray *tempArray = [[SaveShareObject shareSaveShareObject] getDataFromKeyWorld:keyWorld];
    NSMutableArray *tempDataArray = nil;
    if (tempArray.count > 0)
    {
        tempDataArray = [[NSMutableArray alloc] initWithArray:tempArray];
    }
    else
    {
        tempDataArray= [[NSMutableArray alloc] init];
    }
    [tempDataArray addObject:dict];
    [[NSUserDefaults standardUserDefaults] setObject:tempDataArray forKey:keyWorld];
}

#pragma 修改聊天主列表
-(void)setTalkIndexList:(NSArray *)array
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:TALKMAINLIEST];
}

#pragma 只用于聊天主列表更新
-(void)upDataTalkIndexList:(NSDictionary *)dict
{
    NSString *newIntoId = [dict objectForKey:@"talkId"];
    //如果是saveId == 自己,主列表存档的键值就得换成对方的id来进行比对
    if ([newIntoId isEqualToString:[[SaveShareObject shareSaveShareObject] socketId]])
    {
        newIntoId = [dict objectForKey:@"reciveId"];
    }
    
    NSArray *tempArray = [[SaveShareObject shareSaveShareObject] getTalkIndexList];
    NSMutableArray *tempMuArray = nil;
    if (tempArray.count > 0)
    {
        tempMuArray = [[NSMutableArray alloc] initWithArray:tempArray];
        int indexNum = -1;
        for (int i = 0; i < tempArray.count ; i ++)
        {
            NSDictionary *talkDict = [tempArray objectAtIndex:i];
            NSString *saveId = [talkDict objectForKey:@"talkId"];
            if ([saveId isEqualToString:[[SaveShareObject shareSaveShareObject] socketId]])
            {
                saveId = [talkDict objectForKey:@"reciveId"];
            }
            //如果是一样的就增加
            if ([newIntoId isEqualToString:saveId])
            {
                if ([[dict objectForKey:@"talkId"] isEqualToString:[[SaveShareObject shareSaveShareObject] socketId]])
                {
                    NSMutableDictionary *tempMuDict = [[NSMutableDictionary alloc] initWithDictionary:talkDict];
                    [tempMuDict setObject:[dict objectForKey:@"showTalkText"] forKey:@"showTalkText"];
                    [tempMuArray setObject:tempMuDict atIndexedSubscript:i];
                }
                else
                {
                    [tempMuArray setObject:dict atIndexedSubscript:i];
                }
                indexNum = i;
                break;
            }
        }
        if (indexNum == -1) {
            [tempMuArray addObject:dict];
        }
    }
    else
    {
        tempMuArray = [[NSMutableArray alloc] init];
        [tempMuArray addObject:dict];
    }
    [self setTalkIndexList:tempMuArray];
}
@end
