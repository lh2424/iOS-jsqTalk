//
//  BrowserImageView.h
//  SDPhotoBrowser
//
//  Created by dql on 15/3/12.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserImageView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, assign) CGRect imageViewFrame;


- (void)eliminateScale; // 清除缩放

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
