//
//  BaseNavigationController.m
//  Immortal_liang
//
//  Created by 广东省深圳市 on 16/1/18.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, weak) BaseViewController *currentShowVC;
@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    //背景状态栏和title
    [self.navigationBar setBarTintColor:[UIColor blueColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    BaseNavigationController *nav = [super initWithRootViewController:rootViewController];
    nav.interactivePopGestureRecognizer.delegate = self;
    nav.delegate = self;
    return nav;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (1 == navigationController.viewControllers.count)
    {
        self.currentShowVC = nil;
    }
    else
    {
        self.currentShowVC = (BaseViewController *)viewController;
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer)
    {
        return (self.currentShowVC == self.topViewController);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
