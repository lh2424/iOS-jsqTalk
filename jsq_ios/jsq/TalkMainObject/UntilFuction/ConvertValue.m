//
//  ConvertValue.m
//  36cn
//
//  Created by shi on 13-12-12.
//  Copyright (c) 2013年 shi. All rights reserved.
//

#import "ConvertValue.h"

@implementation ConvertValue

#pragma mark - 判断为空
+ (BOOL)isNULL:(NSString*)string
{
    @try {
            if (((NSNull *)string == [NSNull null]||string == nil || string.length == 0 || [string isEqualToString:@""]||[string isEqualToString:@"<null>"]||[string isEqualToString:@"(null)"]))
            {
                return YES;
            }
            else
            {
                return NO;
            }
    }
    @catch (NSException *exception)
    {
        NSLog(@"isNULL:%@",string);
        return NO;
    }
}

#pragma 播放声音
+(void)voicePlay:(NSString *)voiceName :(NSString *)voiceType
{
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:voiceName ofType:voiceType];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);
}

#pragma 绘制完的Label后获取文字的CGSize
+(CGSize)textSizeFuctionUpdata:(UILabel *)lable
{
    CGSize textSize = [lable.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size;
    return textSize;
}

+(void)showUIAlertViewWithString:(NSString *)title
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles:nil,nil];
    [alert show];
}

@end
