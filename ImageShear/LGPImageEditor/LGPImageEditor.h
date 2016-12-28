//
//  LGPImageEditorVC.h
//  ImageShear
//
//  Created by guopeng Liao on 2016/12/22.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用过程中如果出现bug，或者有任何不适当的地方，请及时以以下任意一种方式联系我。               *
 *                                                                     *
 * 持续更新地址: https://github.com/LiaoGuopeng/LGPImageEditor                             *
 * QQ : 756581014
 *
 * Email : 756581014@qq.com                                                          *
 * GitHub: https://github.com/LiaoGuopeng                                              *                                                                *
 *                                                                                *
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>
#import "LGPMaskView.h"

@interface LGPImageEditor : UIView<LGPMaskBezierPathDelegate>

//初始化，遮罩是屏幕居中的
+ (instancetype)imageEditorMaskViewCenterInMiddleForBounds:(CGRect )maskViewBounds;

//想要出现在任意地方请调用这个
+ (instancetype)imageEditorMaskViewForMaskRect:(CGRect )maskViewRect;

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

