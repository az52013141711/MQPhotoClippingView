//
//  MQPhotoClippingView.m
//
//  Created by 杨孟强 on 16/8/26.
//  Copyright © 2016年 杨孟强. All rights reserved.
//

#import "MQPhotoClippingView.h"

#pragma mark - -----PhotoClippingFillView中间透明周围半透明View-----
@interface MQPhotoClippingFillView : UIView

/**透明区域*/
@property (nonatomic) CGRect clippingRect;
/**填充颜色*/
@property (nonatomic, strong) UIColor *fillColor;

@end

@implementation MQPhotoClippingFillView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.clippingRect = self.frame;
        self.fillColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    return self;
}

#pragma mark --drawRect
-(void)drawRect:(CGRect)rect
{
    //填充背景
    UIColor *fillColor = self.fillColor ? self.fillColor : [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    [fillColor setFill];
    UIRectFill(rect);
    
    //边框
    CGRect fillBorderRect = self.clippingRect;
    fillBorderRect.origin.y -= 1;
    fillBorderRect.size.height += 2;
    [[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1] setFill];
    UIRectFill(CGRectIntersection(fillBorderRect, rect));
    
    //中空
    [[UIColor clearColor] setFill];
    UIRectFill(CGRectIntersection(self.clippingRect, rect));
}

#pragma mark --set方法
- (void)setClippingRect:(CGRect)clippingRect
{
    _clippingRect = clippingRect;
    [self setNeedsDisplay];
}
- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

@end


#pragma mark - ------PhotoClippingView裁剪view------
@interface MQPhotoClippingView ()

@property (nonatomic, strong) MQPhotoClippingFillView *clippingFileView;

@property (nonatomic, strong) UIImageView *imageView;
/**初始化image后imageView的坐标*/
@property (nonatomic) CGRect imageOriginalRect;

@end

@implementation MQPhotoClippingView


#pragma mark - 创建
+ (instancetype)createPhotoClippingView:(CGRect)frame showImage:(UIImage *)showImage clippingRect:(CGRect)clippingRect
{
    MQPhotoClippingView *photoClippingView = [[MQPhotoClippingView alloc] initWithFrame:frame];
    photoClippingView.clippingRect = clippingRect;
    photoClippingView.image = showImage;
    return photoClippingView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.maxZoomRatio = 4.0f;
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        self.clippingFileView = [[MQPhotoClippingFillView alloc] initWithFrame:frame];
        [self addSubview:self.clippingFileView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        [self addGestureRecognizer:pan];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
        [self addGestureRecognizer:pinch];
    }
    return self;
}

#pragma mark - 手势
#pragma mark 滑动手势
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    
    CGPoint center = self.imageView.center;
    CGPoint translation = [recognizer translationInView:self];
    
    self.imageView.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGFloat minX = self.clippingRect.origin.x - (self.imageView.frame.size.width - self.clippingRect.size.width);
        CGFloat maxX = self.clippingRect.origin.x;
        CGFloat minY = self.clippingRect.origin.y - (self.imageView.frame.size.height - self.clippingRect.size.height);
        CGFloat maxY = self.clippingRect.origin.y;
        
        CGRect rect = self.imageView.frame;
        
        rect.origin.x = (rect.origin.x > maxX ? maxX :
                         (rect.origin.x < minX ? minX : rect.origin.x));
        rect.origin.y = (rect.origin.y > maxY ? maxY :
                         (rect.origin.y < minY ? minY : rect.origin.y));
        
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.frame = rect;
        }];
    }
}
#pragma mark 捏合手势
- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer
{
    CGFloat scale = recognizer.scale;
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
    recognizer.scale = 1.0;
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGFloat minW = self.imageOriginalRect.size.width;
        CGFloat maxW = self.imageOriginalRect.size.width * self.maxZoomRatio;
        
        CGRect rect = self.imageView.frame;
        
        if (rect.size.width > maxW) {
            
            CGFloat proportion = maxW / rect.size.width;
            CGFloat x = (maxW - rect.size.width) / 2;
            CGFloat y = (rect.size.height * proportion - rect.size.height) / 2;
            
            rect.size.width = maxW;
            rect.size.height *= proportion;
            rect.origin.x -= x;
            rect.origin.y -= y;
        } else if (rect.size.width < minW) {
            
            CGFloat proportion = minW / rect.size.width;
            CGFloat x = (minW - rect.size.width) / 2;
            CGFloat y = (rect.size.height * proportion - rect.size.height) / 2;
            
            rect.size.width = minW;
            rect.size.height *= proportion;
            rect.origin.x -= x;
            rect.origin.y -= y;
        }
        
        CGFloat minX = self.imageOriginalRect.origin.x - (rect.size.width - self.imageOriginalRect.size.width);
        CGFloat maxX = self.imageOriginalRect.origin.x;
        CGFloat minY = self.imageOriginalRect.origin.y - (rect.size.height - self.imageOriginalRect.size.height);
        CGFloat maxY = self.imageOriginalRect.origin.y;
        
        rect.origin.x = (rect.origin.x > maxX ? maxX :
                         (rect.origin.x < minX ? minX : rect.origin.x));
        rect.origin.y = (rect.origin.y > maxY ? maxY :
                         (rect.origin.y < minY ? minY : rect.origin.y));
        
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.frame = rect;
        }];
    }
}

#pragma mark - 获取裁剪后图片
- (UIImage *)clippingImage
{
    UIImage *theImage = nil;
    if (self.image) {
        //view截图
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //裁剪图片
        CGImageRef cgimg = CGImageCreateWithImageInRect([theImage CGImage], self.clippingRect);
        theImage = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
    }
    return theImage;
}

#pragma mark - set方法
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.clippingFileView.frame = frame;
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
    
    if (image) {
        
        CGFloat scale = (image.size.width > image.size.height ?
                         (self.clippingRect.size.height /
                          image.size.height) :
                         (self.clippingRect.size.width /
                          image.size.width));
        
        self.imageView.frame = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
        self.imageView.center = CGPointMake(self.clippingRect.origin.x+self.clippingRect.size.width/2, self.clippingRect.origin.y+self.clippingRect.size.height/2);
        
        self.imageOriginalRect = self.imageView.frame;
    }
}
- (void)setClippingRect:(CGRect)clippingRect
{
    _clippingRect = clippingRect;
    self.image = self.image;
    self.clippingFileView.clippingRect = clippingRect;
}
- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    self.clippingFileView.fillColor = fillColor;
}


@end
