//
//  MQPhotoClippingView.h
//
//  Created by 杨孟强 on 16/8/26.
//  Copyright © 2016年 杨孟强. All rights reserved.
//
/*
    //创建方法
    MQPhotoClippingView *photoClippingView = [[MQPhotoClippingView alloc] initWithFrame:self.view.frame];
    photoClippingView.image = [UIImage imageNamed:@"1.JPG"];
    photoClippingView.clippingRect = CGRectMake(20, 80, 300, 300);
    [view addSubview:self.photoClippingView];
 
    //获取裁剪位置图片
    [photoClippingView clippingImage];
 */

#import <UIKit/UIKit.h>

/**裁剪图片View*/
@interface MQPhotoClippingView : UIView

/**
 *  创建裁剪图片View
 */
+ (instancetype)createPhotoClippingView:(CGRect)frame showImage:(UIImage *)showImage clippingRect:(CGRect)clippingRect;
/**
 *  必须使用此方法初始化
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**显示的图片*/
@property (nonatomic, strong) UIImage *image;
/**裁剪区域*/
@property (nonatomic) CGRect clippingRect;
/**填充区域颜色*/
@property (nonatomic, strong) UIColor *fillColor;
/**最大的放大倍数(默认4.0)*/
@property (nonatomic) CGFloat maxZoomRatio;

/**
 *  获取当前裁剪区域图片
 */
- (UIImage *)clippingImage;

@end
