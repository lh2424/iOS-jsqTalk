//
//  NormalTableViewCell.h
//  Immortal_liang
//
//  Created by liang hong on 2019/7/3.
//  Copyright © 2019年 ideal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NormalTableViewCell : UITableViewCell

-(instancetype)initNormalListWithStyleDict:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)reloadCellWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
