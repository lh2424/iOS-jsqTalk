//
//  UIImage+MJ.h
//  新浪微博
//
//  Created by apple on 13-10-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MJ)
#pragma mark 加载全屏的图片
+ (UIImage *)fullscrennImage:(NSString *)imgName;

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName;

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

//去掉图片白色背景
+(UIImage*) imageToTransparent:(UIImage*) image;

//处理拍照上传图片，图片会旋转的问题
+ (UIImage *)fixOrientation:(UIImage *)aImage;
@end
