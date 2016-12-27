//
//  LGPMaskView.h
//  ImageShear
//
//  Created by guopeng Liao on 2016/12/22.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LGPMaskViewType) {
    LGPMaskViewTypeRect = 0,
    LGPMaskViewTypeOval
};

@protocol LGPMaskBezierPathDelegate <NSObject>

@optional
/**
 *  定义一个闭合的UIBezierPath，请在两个情况下定义。一是当rect为CGRectZero的时候，基于[UIScreen mainScreen].bounds画出maskView上的遮罩UIBezierPath；二是当rect有值时，在基于rect内无上下左右间距的跟之前的BezierPath等比例的画出UIBezierPath（比较复杂,详情请看demo）。
 *
 *  @param rect rect
 *
 *  @return bezierPath
 */
- (UIBezierPath *)bezierPathWithToRect:(CGRect)rect;

@end

@interface LGPMaskView : UIView

@property (nonatomic,assign)CGRect maskRect;
@property (nonatomic,assign)LGPMaskViewType type;

@property (nonatomic,weak)id<LGPMaskBezierPathDelegate> delegate;
@end
