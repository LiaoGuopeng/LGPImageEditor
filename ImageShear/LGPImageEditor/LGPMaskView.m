//
//  LGPMaskView.m
//  ImageShear
//
//  Created by guopeng Liao on 2016/12/22.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import "LGPMaskView.h"

@implementation LGPMaskView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    return self;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];

    UIBezierPath *circlePath = nil;

    if (self.delegate && [self.delegate respondsToSelector:@selector(bezierPathWithToRect:)]) {
        circlePath = [self.delegate bezierPathWithToRect:CGRectZero];
    }else{
        
        switch (self.type) {
            case LGPMaskViewTypeRect:
                circlePath = [UIBezierPath bezierPathWithRect:_maskRect];
                break;
                
            case LGPMaskViewTypeOval:
                circlePath = [UIBezierPath bezierPathWithOvalInRect:_maskRect];
                break;
        }
    }
    
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    
    CAShapeLayer *Layer = [CAShapeLayer layer];
    Layer.lineWidth = 2.f;
    Layer.fillColor = [UIColor clearColor].CGColor;
    Layer.strokeColor = [UIColor whiteColor].CGColor;
    Layer.path = circlePath.CGPath;
    
    
    self.layer.mask = shapeLayer;
    [self.layer addSublayer:Layer];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return nil;
}
@end
