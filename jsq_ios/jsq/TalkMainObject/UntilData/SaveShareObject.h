//
//  SaveShareObject.h
//  BaseCase
//
//  Created by liang hong on 2019/4/12.
//  Copyright © 2019年 lxjr. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface SaveShareObject : NSObject

/*
 * 自身的登录编号id(4字节)
 */
@property(nonatomic,retain)NSString *socketId;
/*
 * 昵称
 */
@property(nonatomic,retain)NSString *nickName;
/*
 * 头像
 */
@property(nonatomic,retain)NSString *urlHead;

+(id)shareSaveShareObject;

-(void)initlognData:(NSDictionary *)dict;
-(NSDictionary *)getLognData;
-(void)setLognData:(NSDictionary *)dict;
-(void)moveLognData;

//创建发送的UI数据
-(NSDictionary *)buildSendMessgeFrame:(NSString *)tempStr;
//创建接收的UI数据
-(NSDictionary *)buildReceveMessgeFrame:(NSString *)talkText;



//发送前组装成字典
-(NSString *)assembleMessgeString:(NSString *)reciveId :(NSString *)talkText;
//根据关键字获取聊天列表
-(NSArray *)getDataFromKeyWorld:(NSString *)keyWorld;
//获取聊天主列表
-(NSArray *)getTalkIndexList;
//存储聊天主列表
-(void)setTalkIndexList:(NSArray *)array;
//增加指定单个的聊天UI数据
-(void)addTalkIndexList:(NSDictionary *)dict :(NSString *)keyWorld;
//检查聊天主页是否有某个聊天人,没有就加,有就替换最后一句
-(void)upDataTalkIndexList:(NSDictionary *)dict;
//文字解析成dict
-(NSDictionary *)changeMessageData:(NSString *)talkText;
@end

NS_ASSUME_NONNULL_END
