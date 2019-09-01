//
//  NormalTableViewCell.m
//  Immortal_liang
//
//  Created by liang hong on 2019/7/3.
//  Copyright © 2019年 ideal. All rights reserved.
//

#import "NormalTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation NormalTableViewCell
{
    UILabel *nameLabel,*descriptLabel;
    UIImageView *titleImageView;
}
-(instancetype)initNormalListWithStyleDict:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //image_url
        titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BORDERLINE, BORDERLINE, CELL_INDEX-2*BORDERLINE, CELL_INDEX-2*BORDERLINE)];
        [titleImageView setImage:[UIImage imageNamed:@"default_head_head"]];
        [self addSubview:titleImageView];
        
        nameLabel = [[UILabel alloc] init];
        [self addSubview:nameLabel];
        
        descriptLabel = [[UILabel alloc] init];
        [self addSubview:descriptLabel];
    }
    return self;
}

-(void)reloadCellWithDict:(NSDictionary *)dict
{
    //收到的数据判断是否等于发送者,等于的话就只更新列表的对话数据
    if (![[dict objectForKey:@"talkId"] isEqualToString:[[SaveShareObject shareSaveShareObject] socketId]])
    {
        [titleImageView sd_setImageWithString:[dict objectForKey:@"showImageUrl"] placeholderImage:[UIImage imageNamed:@"default_head_head"]];
        nameLabel.text = [dict objectForKey:@"showName"];
    }
    
    nameLabel.font=[UIFont systemFontOfSize:16];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.frame = CGRectMake(CGRectGetMaxX(titleImageView.frame)+ BORDERLINE, BORDERLINE, kScreenwidth-(CGRectGetMaxX(titleImageView.frame)+BORDERLINE), UNITEHEIGHT);
    
    descriptLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"showTalkText"]];
    descriptLabel.font=[UIFont systemFontOfSize:14];
    descriptLabel.adjustsFontSizeToFitWidth = YES;
    descriptLabel.textColor = [UIColor grayColor];
    CGSize labelSize = [ConvertValue textSizeFuctionUpdata:descriptLabel];
    descriptLabel.frame=CGRectMake(CGRectGetMaxX(titleImageView.frame)+ BORDERLINE,CGRectGetMaxY(nameLabel.frame)+ BORDERLINE, labelSize.width, UNITEHEIGHT);
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *remind = [dict objectForKey:@"remind"];
    if (![ConvertValue isNULL:remind]) {
        descriptLabel.textColor = [UIColor redColor];
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:(CGFloat)0.0];
}

@end
