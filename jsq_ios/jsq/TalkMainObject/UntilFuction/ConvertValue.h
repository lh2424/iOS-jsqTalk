//
//  ConvertValue.h
//  玄机文化
//
//  Created by 广东省深圳市 on 16/3/11.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ConvertValue : NSObject

//判断字串
+(BOOL)isNULL:(NSString*)string;
//播放声音
+(void)voicePlay:(NSString *)voiceName :(NSString *)voiceType;
//获取赋内容和属性以后的label大小
+(CGSize)textSizeFuctionUpdata:(UILabel *)lable;
//零时整理个公用提示
+(void)showUIAlertViewWithString:(NSString *)title;
@end
