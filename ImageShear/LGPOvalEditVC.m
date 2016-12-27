//
//  LGPOvalEditVC.m
//  LGPImageEditorDemo
//
//  Created by guopeng Liao on 2016/12/26.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import "LGPOvalEditVC.h"
#import "LGPImageEditor.h"

#define WeakObj(o) __weak typeof(o) o##Weak = o;


@interface LGPOvalEditVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation LGPOvalEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"椭圆选取";
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
    vc.type = LGPMaskViewTypeOval;
    
    CGRect rect = CGRectMake(50,(self.view.frame.size.height - self.view.frame.size.width + 100)/2,self.view.frame.size.width-100,self.view.frame.size.width-100);
    vc.maskRect = rect;
    
    WeakObj(self);
    vc.sureOfReturnImage = ^(UIImage *image){
        selfWeak.imageView.image = image;
        selfWeak.imageView.bounds = rect;
        [picker dismissViewControllerAnimated:NO completion:nil];
    };
    
    [vc show];
    
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
