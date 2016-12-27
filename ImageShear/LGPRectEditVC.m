//
//  LGPRectEditVC.m
//  LGPImageEditorDemo
//
//  Created by guopeng Liao on 2016/12/26.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import "LGPRectEditVC.h"
#import "LGPImageEditor.h"

#define WeakObj(o) __weak typeof(o) o##Weak = o;


@interface LGPRectEditVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation LGPRectEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"矩形选取";
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
    vc.type = LGPMaskViewTypeRect;
    
    CGRect rect = CGRectMake(15,self.view.frame.size.height*0.25,self.view.frame.size.width-30,self.view.frame.size.height/2);
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

- (void)dealloc{
    
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
