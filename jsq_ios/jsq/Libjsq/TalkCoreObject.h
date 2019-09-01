//
//  TalkCoreObject.h
//  jsq
//
//  Created by liang hong on 2019/8/24.
//  Copyright © 2019年 liang hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN

@interface TalkCoreObject : NSObject<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *clientSocket;

/*
 * 自身的登录编号id(4字节)
 */
@property(nonatomic,retain)NSString *socketId;
/*
 * 通知的标识
 */
@property(nonatomic,copy)NSString *noticeDidRead,*noticeDidWrite;

@property (atomic,assign) long lastTime;


+(instancetype)shareInstance;

-(void)startTalkServer:(NSString *)noticeDidRead :(NSString *)noticeDidWrite;

-(void)sendMessageWithText:(NSString *)reciveId :(NSString *)talkText;
-(NSString *)stringFromHexString:(NSString *)str;
-(NSString *)stringFromInt:(int)textId;

-(void)lognSocketWith:(NSString *)socketId;

-(void)exitSocket;

@end

NS_ASSUME_NONNULL_END
