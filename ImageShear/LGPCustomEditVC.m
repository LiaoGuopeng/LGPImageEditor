//
//  LGPCustomEditVC.m
//  LGPImageEditorDemo
//
//  Created by guopeng Liao on 2016/12/26.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import "LGPCustomEditVC.h"
#import "LGPImageEditor.h"

#define WeakObj(o) __weak typeof(o) o##Weak = o;


@interface LGPCustomEditVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,LGPMaskBezierPathDelegate>

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation LGPCustomEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"自定义选取";
    
    self.imageView = [UIImageView new];
    self.imageView.center = self.view.center;
    self.imageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageDidClicked)];
    [self.imageView addGestureRecognizer:tap];
    
    [self imageDidClicked];
}

- (void)imageDidClicked{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    LGPImageEditor *vc = [LGPImageEditor new];
    vc.readyEditImage = image;
    vc.delegate = self;
    
    WeakObj(self);
    vc.sureOfReturnImage = ^(UIImage *image){
        selfWeak.imageView.image = image;
        selfWeak.imageView.bounds = CGRectMake(50,(selfWeak.view.frame.size.height - selfWeak.view.frame.size.width + 100)/2,(selfWeak.view.frame.size.width-10*2),(selfWeak.view.frame.size.width-10*2));
;
        [picker dismissViewControllerAnimated:NO completion:nil];
    };
    
    [vc show];
    
}

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
