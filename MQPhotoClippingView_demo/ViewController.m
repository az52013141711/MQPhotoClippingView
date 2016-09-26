//
//  ViewController.m
//  MQPhotoClippingView_demo
//
//  Created by yoka_mobile_cm on 16/9/26.
//  Copyright © 2016年 杨孟强. All rights reserved.
//

#import "ViewController.h"

#import "MQPhotoClippingView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) MQPhotoClippingView *photoClippingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.photoClippingView = [[MQPhotoClippingView alloc] initWithFrame:self.view.frame];
    self.photoClippingView.image = [UIImage imageNamed:@"1.jpg"];
    self.photoClippingView.clippingRect = CGRectMake(20, 80, ScreenWidth-40, ScreenWidth-40);
    [self.view addSubview:self.photoClippingView];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-100, ScreenHeight-100, 100, 100)];
    [button setTitle:@"裁剪" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(caijian) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)caijian
{
    UIImage *theImage = [self.photoClippingView clippingImage];
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width)];
    imgview.image = theImage;
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [vc.view addSubview:imgview];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
