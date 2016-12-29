# LGPImageEditor

一个用于选取图片后的编辑器。基本有矩形和椭圆形的类型。也可以自定义UIBezierPath来剪切图片。


##Pod支持：

支持pod：  pod 'LGPImageEditor', '~> 0.0.2'


#   用法简介

##  基本的矩形或者椭圆形（包括圆形）使用方法。
```objective-c
- (void)imageDidClicked{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = NO;//不要打开系统的编辑器
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width-30, self.view.frame.size.height/2);
    
    LGPImageEditor *vc = [LGPImageEditor imageEditorMaskViewCenterInMiddleForBounds:rect];
    vc.readyEditImage = image;
    vc.type = LGPMaskViewTypeRect;//默认矩形，LGPMaskViewTypeOval的话会根据maskRect画出椭圆形UIBezierPath
        
    WeakObj(self);
    vc.sureOfReturnImage = ^(UIImage *image){
        selfWeak.imageView.image = image;
        selfWeak.imageView.bounds = rect;
        [picker dismissViewControllerAnimated:NO completion:nil];
    };
    
    [vc show];//显示  不用设置frame
    
}
```

##  自定义UIBezierPath用法
```objective-c
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    LGPImageEditor *vc = [LGPImageEditor new];
    vc.readyEditImage = image;
    vc.delegate = self;//自定义用法，比较麻烦。优先级大于maskRect和type的设置。所以不用设置maskRect和type
    
    WeakObj(self);
    vc.sureOfReturnImage = ^(UIImage *image){
        selfWeak.imageView.image = image;
        selfWeak.imageView.bounds = CGRectMake(50,(selfWeak.view.frame.size.height - selfWeak.view.frame.size.width + 100)/2,(selfWeak.view.frame.size.width-10*2),(selfWeak.view.frame.size.width-10*2));
;
        [picker dismissViewControllerAnimated:NO completion:nil];
    };
    
    [vc show];
    
}
```

LGPMaskBezierPathDelegate代理方法会多次调用，需要根据参数rect画出两个同比例同规模的UIBezierPath。
```objective-c
#pragma make - LGPMaskBezierPathDelegate
- (UIBezierPath *)bezierPathWithToRect:(CGRect)rect{
    NSInteger spaceWidth = 10;
    
    NSInteger topSpaceWidth = 100;
    
    CGFloat radius;//半径
    
    CGPoint leftPoint;//最左侧的点
    
    CGPoint leftCenter;//左侧圆心
    
    CGPoint rightCenter;//右侧圆心
    
    CGPoint bottomVertices;//底部顶点
    
    CGPoint rightControlPoint;//右边曲线控制点
    
    CGPoint leftControlPoint;//左边曲线控制点

    if (CGRectEqualToRect(rect, CGRectZero)) {//当rect为CGRectZero的时候，基于[UIScreen mainScreen].bounds上在你希望的位置画出bezierPath
        
        //半径
        radius = (self.view.frame.size.width-spaceWidth*2)/4;
        
        //最左侧的点
        leftPoint = CGPointMake(spaceWidth, spaceWidth+radius+topSpaceWidth);
        
        //左侧圆心 位于左侧边距＋半径宽度
        leftCenter = CGPointMake(spaceWidth+radius, spaceWidth+radius+topSpaceWidth);
        
        //右侧圆心 位于左侧圆心的右侧 距离为两倍半径
        rightCenter = CGPointMake(spaceWidth+radius*3, spaceWidth+radius+topSpaceWidth);
       
        //底部顶点
        bottomVertices = CGPointMake(self.view.frame.size.width/2,radius*4+topSpaceWidth+spaceWidth);
       
        //右边曲线控制点
        rightControlPoint = CGPointMake(self.view.frame.size.width-spaceWidth, radius*4*0.55+topSpaceWidth+spaceWidth);
        
        //左边曲线控制点
        leftControlPoint = CGPointMake(spaceWidth, radius*4*0.55+topSpaceWidth+spaceWidth);
        
    }else{//rect不为CGRectZero时
        
        //上部分的两半圆半径
        radius = rect.size.width/4;
        //最左点，x=0+rect.origin.x   y = radius + rect.origin.y   
        leftPoint = CGPointMake(rect.origin.x,radius+rect.origin.y);
        
        leftCenter = CGPointMake((radius+rect.origin.x), (radius+rect.origin.y));
        
        rightCenter = CGPointMake((radius*3+rect.origin.x), (radius+rect.origin.y));
        
        bottomVertices = CGPointMake((rect.size.width/2+rect.origin.x),(rect.size.height+rect.origin.y));
        
        rightControlPoint = CGPointMake(rect.size.width+rect.origin.x,rect.origin.y+rect.size.height*0.55);
        
        leftControlPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height*0.55);
    }
    
    //左侧半圆
    UIBezierPath *heartLine = [UIBezierPath bezierPathWithArcCenter:leftCenter radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //右侧半圆
    [heartLine addArcWithCenter:rightCenter radius:radius startAngle:M_PI endAngle:0 clockwise:YES];

    //曲线连接到底部顶点
    [heartLine addQuadCurveToPoint:bottomVertices controlPoint:rightControlPoint];

    //用曲线 底部的顶点连接到左侧半圆的左起点
    [heartLine addQuadCurveToPoint:leftPoint controlPoint:leftControlPoint];

    [heartLine setLineCapStyle:kCGLineCapRound];
    
    return heartLine;
}

```

##  效果图

![](http://ww3.sinaimg.cn/mw690/005XldQagw1fb5gaik9gtj30ac0ijwfq.jpg)
![](http://ww4.sinaimg.cn/mw690/005XldQagw1fb5gait9vgj30af0j5my4.jpg)
