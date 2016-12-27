//
//  LGPImageEditorVC.h
//  ImageShear
//
//  Created by guopeng Liao on 2016/12/22.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGPMaskView.h"

@interface LGPImageEditor : UIView<LGPMaskBezierPathDelegate>

//你需要编辑的图片
@property (nonatomic,strong)UIImage *readyEditImage;

//编辑的遮罩类型。
@property (nonatomic,assign)LGPMaskViewType type;

//遮罩rect
@property (nonatomic,assign)CGRect maskRect;

//选取之后的图片回调
@property (nonatomic,copy)void(^sureOfReturnImage)(UIImage *image);

//如果以上两个类型都不能满足你，你想自定义一个BezierPath用来剪切图片的话，指定代理并且实现它。优先级大于maskRect和type的设置。
@property (nonatomic,weak)id<LGPMaskBezierPathDelegate> delegate;

- (void)show;
@end

