//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"

// dql
#import "BrowserImageView.h"

 
//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"

//  =============================================

@implementation SDPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SDPhotoBrowserBackgrounColor;
    }
    return self;
}


//- (void)didMoveToSuperview
//{
//    [self setupScrollView];
//    
//    [self setupToolbars];
//}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        [self setupScrollView];
        [self setupToolbars];
    }
}

- (void)setupToolbars
{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor clearColor];
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }
    UILabel *tempLabel = indexLabel;
    [tempLabel sizeToFit];
    indexLabel.frame = CGRectMake((kScreenwidth - 70) * 0.5, self.bounds.size.height - tempLabel.frame.size.height - 15, 70, tempLabel.frame.size.height);
    _indexLabel = indexLabel;
    [self addSubview:indexLabel];
    
    // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    UIImage *image = [UIImage imageNamed:@"save_icon_highlighted"];
    [saveButton setImage:image forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor clearColor];
    saveButton.frame = CGRectMake(30, self.bounds.size.height - image.size.height - 15, image.size.width, image.size.height);
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesturePress:)];
    [self addGestureRecognizer:gesture];
}

- (void)longGesturePress:(UIGestureRecognizer*)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] &&
        gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *sheet =   [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到手机" otherButtonTitles:nil, nil];
        [sheet showInView:self];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self saveImage];
    }
}
- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
//    BrowserImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    CGRect frame = self.bounds;
    
    for (int i = 0; i < self.imageCount; i++) {
        BrowserImageView * imageView = [[BrowserImageView alloc] initWithFrame:frame];
        imageView.tag = i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)]];
        [_scrollView addSubview:imageView];
    }
    
    
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
//    SDBrowserImageView *imageView = _scrollView.subviews[index];
    BrowserImageView * imageView = _scrollView.subviews[index];
    if (imageView.hasLoadedImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = SDPhotoBrowserImageViewMargin;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height - SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(BrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    _scrollView.pagingEnabled = YES;
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    _scrollView.hidden = YES;
    
    //    SDBrowserImageView *currentImageView = (SDBrowserImageView *)recognizer.view;
    BrowserImageView * currentImageView = (BrowserImageView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    
    UIView *sourceView = self.sourceImagesContainerView ? self.sourceImagesContainerView.subviews[self.currentImageIndex] : self.currentView;
    CGRect targetTemp = self.sourceImagesContainerView  ?  [self.sourceImagesContainerView convertRect:sourceView.frame toView:self] : CGRectMake(self.currentView.frame.origin.x, self.currentView.frame.origin.y + kNavigationBarH, self.currentView.frame.size.width, self.currentView.frame.size.height);
    
    int status = 1;// 正常状态 ， 滚动的图片范围在sourceImagesContainerView所在view的视线
    if (self.sourceImagesContainerView)
    {
        if (targetTemp.origin.x >= self.sourceImagesContainerView.frame.size.width + self.sourceImagesContainerView.frame.origin.x)
        {
            status = -1;
            CGSize size = [UIScreen mainScreen].bounds.size;
            targetTemp = CGRectMake((size.width - 250) * 0.5, (size.height - 250) * 0.5, 300, 300);
        }
    }
   
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = currentImageView.image;

    // 获取当前图片的大小，设置动画的初始状态
    BrowserImageView * browserImageView = _scrollView.subviews[currentIndex];
    CGSize imageViewSize = browserImageView.imageViewFrame.size;
    tempView.bounds = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
    tempView.center = self.center;
    
    [self addSubview:tempView];
    
    _saveButton.hidden = YES;
    
    if (status == 1)
    {
        [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
            tempView.frame = targetTemp;
            self.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished)
        {
            
            [self removeFromSuperview];
        }];
    }else
    {
        if (self.sourceImagesContainerView)
        {
            [UIView animateWithDuration:0.1 animations:^{
                tempView.frame = CGRectMake(self.sourceImagesContainerView.frame.size.width * 0.2 +self.sourceImagesContainerView.frame.origin.x, self.sourceImagesContainerView.frame.size.height * 0.2 +self.sourceImagesContainerView.frame.origin.y, self.sourceImagesContainerView.frame.size.width * 0.6, self.sourceImagesContainerView.frame.size.height * 0.6);
                self.alpha = 0.1;
            } completion:^(BOOL finished){
                self.backgroundColor = [UIColor clearColor];
                self.alpha = 1;
                [self removeFromSuperview];
            }];
        }else
        {
            [UIView animateWithDuration:0.1 animations:^{
                tempView.frame = CGRectMake(self.currentView.frame.size.width * 0.2 +self.currentView.frame.origin.x, self.currentView.frame.size.height * 0.2 +self.currentView.frame.origin.y, self.currentView.frame.size.width * 0.6, self.currentView.frame.size.height * 0.6);
                self.alpha = 0.1;
            } completion:^(BOOL finished){
                self.backgroundColor = [UIColor clearColor];
                self.alpha = 1;
                [self removeFromSuperview];
            }];
        }
        
    }
   
}

- (void)showFirstImage
{
    
    UIView *sourceView = self.sourceImagesContainerView ? self.sourceImagesContainerView.subviews[self.currentImageIndex] : self.currentView;
    
    CGRect rect = self.sourceImagesContainerView  ?  [self.sourceImagesContainerView convertRect:sourceView.frame toView:self] :self.currentView.frame;
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    
    // 获取当前图片的大小，设置动画的初始状态
//    BrowserImageView * browserImageView = _scrollView.subviews[self.currentImageIndex];
//    CGSize targetTempSize = browserImageView.imageViewFrame.size;
    
    // 重新获取大小

    
    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    CGRect scaleOriginRect = [self imageScaleRectForIndex:_currentImageIndex];
    BrowserImageView * browserImageView = _scrollView.subviews[self.currentImageIndex];
    browserImageView.imageViewFrame = scaleOriginRect;
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
//        tempView.bounds = (CGRect){CGPointZero, {targetTempSize.width * 2, targetTempSize.height * 2}};
        tempView.bounds = scaleOriginRect;
    } completion:^(BOOL finished) {
        self->_hasShowedFistView = YES;
        [tempView removeFromSuperview];
        self->_scrollView.hidden = NO;
    }];
}


- (CGRect)imageScaleRectForIndex:(NSInteger)index
{
    UIImage * image = [self placeholderImageForIndex:index];
    CGSize targetTempSize = image.size;
    
    //判断首先缩放的值
    float scaleX = self.frame.size.width/targetTempSize.width;
    float scaleY = self.frame.size.height/targetTempSize.height;
    
    CGRect scaleOriginRect;
    //倍数小的，先到边缘
    if (scaleX > scaleY)
    {
        //Y方向先到边缘
        float imgViewWidth = targetTempSize.width*scaleY;
        //        self.maximumZoomScale = self.frame.size.width/imgViewWidth;
        
        scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
    }
    else
    {
        //X先到边缘
        float imgViewHeight = targetTempSize.height*scaleX;
        //        self.maximumZoomScale = self.frame.size.height/imgViewHeight;
        
        scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
    }
    
    return scaleOriginRect;
}


- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动100后清除缩放
    CGFloat margin = 100.0;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
//        SDBrowserImageView *imageView = _scrollView.subviews[index];
        BrowserImageView * imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [imageView eliminateScale];

        }
    }
    
    
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];

    BrowserImageView * browserImageView = _scrollView.subviews[index];
    if (browserImageView.imageViewFrame.size.width == 0) {
        CGRect scaleOriginRect = [self imageScaleRectForIndex:index];
        browserImageView.imageViewFrame = scaleOriginRect;
    }
    
    [self setupImageOfImageViewForIndex:index];
}


-(void)dealloc
{
    [_indexLabel removeFromSuperview];
    [_scrollView removeFromSuperview];
    [_saveButton removeFromSuperview];
    _saveButton = nil;
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    _indexLabel = nil;
    _scrollView = nil;
}
@end
