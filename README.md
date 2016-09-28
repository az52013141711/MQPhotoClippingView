# MQPhotoClippingView

裁剪图片  裁剪制定位置图片
裁剪图片定制

![效果图](https://github.com/az52013141711/MQPhotoClippingView/blob/master/%E6%95%88%E6%9E%9C%E5%9B%BE.gif)

    //创建方法
    MQPhotoClippingView *photoClippingView = [[MQPhotoClippingView alloc] initWithFrame:self.view.frame];
    photoClippingView.image = [UIImage imageNamed:@"1.JPG"];
    photoClippingView.clippingRect = CGRectMake(20, 80, 300, 300);
    [view addSubview:self.photoClippingView];
 
    //获取裁剪位置图片
    [photoClippingView clippingImage];
    

    
    
    
