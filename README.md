# MQPhotoClippingView

    //创建方法
    MQPhotoClippingView *photoClippingView = [[MQPhotoClippingView alloc] initWithFrame:self.view.frame];
    photoClippingView.image = [UIImage imageNamed:@"1.JPG"];
    photoClippingView.clippingRect = CGRectMake(20, 80, 300, 300);
    [view addSubview:self.photoClippingView];
 
    //获取裁剪位置图片
    [photoClippingView clippingImage];
    
    
    
