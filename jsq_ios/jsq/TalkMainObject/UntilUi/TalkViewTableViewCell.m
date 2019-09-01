//
//  TalkViewTableViewCell.m
//  Immortal_liang
//
//  Created by liang hong on 2019/2/5.
//  Copyright © 2019年 ideal. All rights reserved.
//

#import "TalkViewTableViewCell.h"

@implementation TalkViewTableViewCell
{
    UIImageView *imageView0,*imageView1;
    UILabel *labelView0, *labelView1;
    UITextView *textView0,*textView1;
}

-(instancetype)initWithSocketData
{
    self = [super init];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imageView0 = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView0];
        
        imageView1 = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView1];
        
        labelView0 = [[UILabel alloc] init];
        [self.contentView addSubview:labelView0];

        labelView1 = [[UILabel alloc] init];
        [self.contentView addSubview:labelView1];
        
        textView0= [[UITextView alloc] init];
        [self.contentView addSubview:textView0];
        
        textView1= [[UITextView alloc] init];
        [self.contentView addSubview:textView1];
    }
    
    return self;
}

-(void)reloadTalkDeailListViews:(NSDictionary *)talkDict
{
    if ([[talkDict objectForKey:@"talkId"] isEqualToString:[[SaveShareObject shareSaveShareObject] socketId]])
    {
        imageView1.frame = CGRectMake(kScreenwidth - BORDERLINE -50, BORDERLINE, 50, 50);
        [imageView1 sd_setImageWithString:[talkDict objectForKey:@"showImageUrl"] placeholderImage:[UIImage imageNamed:@"default_head_head"]];
        
        labelView1.frame = CGRectMake(BORDERLINE, BORDERLINE, imageView1.frame.origin.x-BORDERLINE,UNITEHEIGHT);
        labelView1.textAlignment = NSTextAlignmentRight;
        labelView1 .text = [talkDict objectForKey:@"showName"];
        labelView1.textColor = [UIColor grayColor];
        labelView1.font = [UIFont systemFontOfSize:13];
        
        CGRect tempFrame = CGRectMake([[talkDict objectForKey:@"talkFrameX"] floatValue], [[talkDict objectForKey:@"talkFrameY"] floatValue], [[talkDict objectForKey:@"talkFrameW"] floatValue], [[talkDict objectForKey:@"talkFrameH"] floatValue]);
        tempFrame.origin.y = CGRectGetMaxY(labelView1.frame);
        textView1.frame = tempFrame;
        
        textView1.font = [UIFont systemFontOfSize:16];
        textView1.text = [talkDict objectForKey:@"showTalkText"];
        textView1.textContainerInset = UIEdgeInsetsMake(BORDERLINE, BORDERLINE, BORDERLINE, BORDERLINE);
        textView1.scrollEnabled = NO;
        textView1.editable = NO;
        [textView1 sizeToFit];
        
        UIImage *tempImg1 = [UIImage imageNamed:@"right_chat_bg"];
        UIEdgeInsets insets = UIEdgeInsetsMake(tempImg1.size.height/3, tempImg1.size.width/3, tempImg1.size.height/3, tempImg1.size.width/3); // 上、左、下、右
        tempImg1 = [tempImg1 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        UIImageView *userImgView1=[[UIImageView alloc] initWithFrame:textView1.bounds];
        userImgView1.image=tempImg1;
        userImgView1.contentMode = UIViewContentModeScaleToFill;
        [textView1 addSubview:userImgView1];
        [textView1 sendSubviewToBack:userImgView1];
    }
    else
    {
        imageView0.frame = CGRectMake(BORDERLINE, BORDERLINE, 50, 50);
        [imageView0 sd_setImageWithString:[talkDict objectForKey:@"showImageUrl"] placeholderImage:[UIImage imageNamed:@"default_head_head"]];
        
        labelView0.frame = CGRectMake(CGRectGetMaxX(imageView0.frame)+BORDERLINE, BORDERLINE, kScreenwidth - (CGRectGetMaxX(imageView0.frame)+BORDERLINE),UNITEHEIGHT);
        labelView0 .text = [talkDict objectForKey:@"showName"];
        labelView0.textColor = [UIColor grayColor];
        labelView0.font = [UIFont systemFontOfSize:13];
        
        CGRect tempFrame = CGRectMake([[talkDict objectForKey:@"talkFrameX"] floatValue], [[talkDict objectForKey:@"talkFrameY"] floatValue], [[talkDict objectForKey:@"talkFrameW"] floatValue], [[talkDict objectForKey:@"talkFrameH"] floatValue]);
        tempFrame.origin.x = CGRectGetMaxX(imageView0.frame)+BORDERLINE;
        tempFrame.origin.y = CGRectGetMaxY(labelView0.frame);
        textView0.frame = tempFrame;
        
        textView0.font = [UIFont systemFontOfSize:16];
        textView0.text = [talkDict objectForKey:@"showTalkText"];
        textView0.textContainerInset = UIEdgeInsetsMake(BORDERLINE, BORDERLINE, BORDERLINE, BORDERLINE);
        textView0.scrollEnabled = NO;
        textView0.editable = NO;
        [textView0 sizeToFit];

        UIImage *tempImg0 = [UIImage imageNamed:@"left_chat_bg"];
        UIEdgeInsets insets = UIEdgeInsetsMake(tempImg0.size.height/3, tempImg0.size.width/3, tempImg0.size.height/3, tempImg0.size.width/3); // 上、左、下、右
        tempImg0 = [tempImg0 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        UIImageView *userImgView0=[[UIImageView alloc] initWithFrame:textView0.bounds];
        userImgView0.image=tempImg0;
        userImgView0.contentMode = UIViewContentModeScaleToFill;
        [textView0 addSubview:userImgView0];
        [textView0 sendSubviewToBack:userImgView0];
    }
}

@end
