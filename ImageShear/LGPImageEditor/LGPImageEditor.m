//
//  LGPImageEditorVC.m
//  ImageShear
//
//  Created by guopeng Liao on 2016/12/22.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import "LGPImageEditor.h"

@interface LGPImageEditor ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *zoomingScroolView;
@property (nonatomic,strong)UIImageView *zoomingImageView;

@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIButton *chooseButton;

@property (nonatomic,strong)UIView *buttonBackgroundView;

@property (nonatomic,strong)LGPMaskView *maskView;
@end

@implementation LGPImageEditor

+ (instancetype)imageEditorMaskViewForMaskRect:(CGRect)maskViewRect{
    LGPImageEditor *editor = [LGPImageEditor new];
    editor.maskRect = maskViewRect;
    return editor;
}

+(instancetype)imageEditorMaskViewCenterInMiddleForBounds:(CGRect)maskViewBounds{
    LGPImageEditor *editor = [LGPImageEditor new];
    
    maskViewBounds.origin.x = editor.center.x - maskViewBounds.size.width/2;
    maskViewBounds.origin.y = editor.center.y - maskViewBounds.size.height/2;
    editor.maskRect = maskViewBounds;
    return editor;
}

- (instancetype)init{
    self = [super init];
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor blackColor];
    return self;
}

- (UIScrollView *)zoomingScroolView{
    if (!_zoomingScroolView) {
        
        UIScrollView *zoomingScroolView=[[UIScrollView alloc] initWithFrame:self.maskRect];
        zoomingScroolView.layer.masksToBounds = NO;
        zoomingScroolView.userInteractionEnabled=YES;
        zoomingScroolView.maximumZoomScale=2.0;
        zoomingScroolView.minimumZoomScale=1.0;
        zoomingScroolView.decelerationRate=1.0;
        zoomingScroolView.showsVerticalScrollIndicator = NO;
        zoomingScroolView.showsHorizontalScrollIndicator = NO;
        zoomingScroolView.delegate = self;
        zoomingScroolView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        
        _zoomingScroolView = zoomingScroolView;
    }
    return _zoomingScroolView;
}

- (UIImageView *)zoomingImageView{
    if (!_zoomingImageView) {
        UIImageView *zoomingImageView = [[UIImageView alloc] initWithImage:self.readyEditImage];
        zoomingImageView.userInteractionEnabled = YES;
        zoomingImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        
        CGSize imageSize = zoomingImageView.image.size;
        
        CGSize size;
        if (imageSize.width>self.maskRect.size.width&&imageSize.height>self.maskRect.size.height) {
            
            if ((imageSize.height/(imageSize.width/self.bounds.size.width))>=self.maskRect.size.height) {
                
                CGFloat imageViewH = self.bounds.size.height;
                if (imageSize.width > 0) {
                    imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
                }
                size.width = self.frame.size.width;
                size.height = imageViewH;
                self.zoomingScroolView.minimumZoomScale = MAX(self.maskRect.size.width/size.width, self.maskRect.size.height/size.height);
                
            }else{
                CGFloat imageViewW = self.bounds.size.width;
                if (imageSize.width > 0) {
                    imageViewW = self.maskRect.size.height * (imageSize.width / imageSize.height);
                }
                size.height = self.maskRect.size.height;
                size.width = imageViewW;
            }
            
        }else if(imageSize.width>=self.maskRect.size.width&&imageSize.height<self.maskRect.size.height){
            
            CGFloat imageViewH = self.maskRect.size.height;
            CGFloat imageViewW = (self.maskRect.size.height / imageSize.height)*imageSize.width;
            size.width = imageViewW;
            size.height = imageViewH;
            
        }else if(imageSize.width<self.maskRect.size.width&&imageSize.height>=self.maskRect.size.height){
            
            CGFloat imageViewW = self.maskRect.size.width;
            CGFloat imageViewH = (self.maskRect.size.width / imageSize.width)*imageSize.height;
            size.width = imageViewW;
            size.height = imageViewH;
            
        }else{
            
            if ((self.maskRect.size.width-imageSize.width)>=(self.maskRect.size.height-imageSize.height)) {
                CGFloat imageViewW = self.maskRect.size.width;
                CGFloat imageViewH = (self.maskRect.size.width / imageSize.width)*imageSize.height;
                size.width = imageViewW;
                size.height = imageViewH;
            }else{
                CGFloat imageViewH = self.maskRect.size.height;
                CGFloat imageViewW = (self.maskRect.size.height / imageSize.height)*imageSize.width;
                size.width = imageViewW;
                size.height = imageViewH;
            }
        }
        
        zoomingImageView.frame = CGRectMake(0, 0, size.width, size.height);
        _zoomingImageView = zoomingImageView;
    }
    return _zoomingImageView;
}

- (UIView *)buttonBackgroundView{
    if (!_buttonBackgroundView) {
        _buttonBackgroundView = [UIView new];
        _buttonBackgroundView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
        _buttonBackgroundView.frame = CGRectMake(0, self.frame.size.height-60, self.frame.size.width, 60);
        [_buttonBackgroundView addSubview:self.cancelButton];
        [_buttonBackgroundView addSubview:self.chooseButton];
    }
    return _buttonBackgroundView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(25, 10, 50, 30);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = cancel;
    }
    return _cancelButton;
}

- (UIButton *)chooseButton{
    if (!_chooseButton) {
        UIButton *choose = [UIButton buttonWithType:UIButtonTypeCustom];
        choose.frame = CGRectMake(self.frame.size.width-75, 10, 50, 30);
        [choose setTitle:@"确定" forState:UIControlStateNormal];
        [choose addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        _chooseButton = choose;
    }
    return _chooseButton;
}

- (LGPMaskView *)maskView{
    if (!_maskView) {
        
        LGPMaskView *v = [[LGPMaskView alloc] initWithFrame:self.frame];
        v.maskRect = self.maskRect;
        v.type = self.type;
        v.delegate = self.delegate;
        _maskView = v;
    }
    return _maskView;
}

#pragma mark -UIScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomingImageView;
}

- (void)choose{

    UIGraphicsBeginImageContextWithOptions(self.zoomingImageView.frame.size, NO, [[UIScreen  mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect r = [self.maskView convertRect:self.maskRect toView:self.zoomingImageView];
    
    CGFloat clipX = r.origin.x;
    
    CGFloat clipY = r.origin.y;
    
    CGFloat clipW = r.size.width;
    
    CGFloat clipH = r.size.height;
    
    
    CGFloat scale = self.zoomingScroolView.zoomScale;
    
    clipX *= scale;
    
    clipY *= scale;
    
    clipW *= scale;
    
    clipH *= scale;
    
    CGRect clipedRect = CGRectMake(clipX, clipY, clipW,clipH);
    
    UIBezierPath *circlePath = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bezierPathWithToRect:)]) {
        circlePath = [self.delegate bezierPathWithToRect:clipedRect];
    }else{
    
        switch (self.type) {
            case LGPMaskViewTypeRect:
                circlePath = [UIBezierPath bezierPathWithRect:clipedRect];
                break;
                
            case LGPMaskViewTypeOval:
                circlePath = [UIBezierPath bezierPathWithOvalInRect:clipedRect];
                break;
        }
        
    }

    CGContextAddPath(context, circlePath.CGPath);

    CGContextClip(context);
    
    
    [self.readyEditImage drawInRect:self.zoomingImageView.frame];

    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGFloat s = [[UIScreen mainScreen] scale];
    
    clipX *= s;
    
    clipY *= s;
    
    clipW *= s;
    
    clipH *= s;
    
    CGRect cliRect = CGRectMake(clipX, clipY, clipW,clipH);
    
    CGImageRef cgImageCliped = CGImageCreateWithImageInRect(image.CGImage, cliRect);

    image = [UIImage imageWithCGImage:cgImageCliped];


    CGImageRelease(cgImageCliped);
    
    
    if (self.sureOfReturnImage) {
        self.sureOfReturnImage(image);
    }
    
    [self cancel];
}


- (void)cancel{
    self.sureOfReturnImage = nil;
    [self removeFromSuperview];
}

- (void)show{
    
    if (!self.readyEditImage) {
        NSLog(@"无图");
        return;
    }
    UIWindow *v = [UIApplication sharedApplication].windows.firstObject;
    
    [v addSubview:self];
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bezierPathWithToRect:)]) {
        self.maskRect = [self.delegate bezierPathWithToRect:CGRectZero].bounds;
    }
    
    [self addSubview:self.zoomingScroolView];
    
    [self.zoomingScroolView addSubview:self.zoomingImageView];
    
    self.zoomingScroolView.contentSize = self.zoomingImageView.frame.size;
    
    CGPoint offset = self.zoomingScroolView.contentOffset;
    
    offset.x = (self.zoomingImageView.frame.size.width - self.zoomingScroolView.frame.size.width) * 0.5;
    
    offset.y = (self.zoomingImageView.frame.size.height - self.zoomingScroolView.frame.size.height) * 0.5;
    self.zoomingScroolView.contentOffset = offset;
    
    [self addSubview:self.maskView];
    
    [self addSubview:self.buttonBackgroundView];
}

@end
