//
//  TalkViewTableViewCell.h
//  Immortal_liang
//
//  Created by liang hong on 2019/2/5.
//  Copyright © 2019年 ideal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface TalkViewTableViewCell : UITableViewCell
-(instancetype)initWithSocketData;
-(void)reloadTalkDeailListViews:(NSDictionary *)talkDict;
@end

NS_ASSUME_NONNULL_END
