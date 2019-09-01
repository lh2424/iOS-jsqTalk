//
//  TalkToViewController.h
//  Immortal_liang
//
//  Created by liang hong on 2019/2/6.
//  Copyright © 2019年 ideal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TalkToViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSString *reciveId;

@end

NS_ASSUME_NONNULL_END
