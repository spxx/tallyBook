//
//  LayerRatioView.m
//  tallyBook
//
//  Created by sunpeng on 2017/11/15.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import "LayerRatioView.h"

#define kPieFillColor [UIColor clearColor].CGColor
#define kPieRandColor [UIColor colorWithRed:arc4random() % 255 / 255.0f green:arc4random() % 255 / 255.0f blue:arc4random() % 255 / 255.0f alpha:1.0f]

@implementation LayerRatioView


-(instancetype)initWithFrame:(CGRect)frame andCircleRadius:(CGFloat)circleRadius{
   
    if (self = [super init]) {
        self.circleRadius = circleRadius;
        CGPoint centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        CGFloat radiusBasic = frame.size.width;
        CGFloat bgRadius = radiusBasic * 0.5;
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                              radius:bgRadius
                                                          startAngle:0
                                                            endAngle:M_PI_2 * 4
                                                           clockwise:YES];
        _bgCircleLayer = [CAShapeLayer layer];
        _bgCircleLayer.fillColor   = [UIColor clearColor].CGColor;
        _bgCircleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _bgCircleLayer.strokeStart = 0.0f;
        _bgCircleLayer.strokeEnd   = 1.0f;
        _bgCircleLayer.zPosition   = 1;
        _bgCircleLayer.lineWidth   = bgRadius * 2.0f;
        _bgCircleLayer.path        = bgPath.CGPath;
        self.layer.mask = _bgCircleLayer;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGFloat otherRadius = self.frame.size.width * 0.5;
    UIBezierPath *otherPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
                                                             radius:otherRadius
                                                         startAngle:0
                                                           endAngle:M_PI_2 * 4
                                                          clockwise:YES];
    CGFloat total = 0.0f;
    for (int i = 0; i < _dataItems.count; i++) {
        total += [_dataItems[i] floatValue];
    }
    
    CGFloat start = 0.0f;
    CGFloat end = 0.0f;
    for (int i = 0; i < _dataItems.count; i++) {
        //4.计算当前end位置 = 上一个结束位置 + 当前部分百分比
        end = [_dataItems[i] floatValue] / total + start;
        
        //图层
        CAShapeLayer *pie = [CAShapeLayer layer];
        [self.layer addSublayer:pie];
        pie.fillColor   = kPieFillColor;
        if (i > _colorItems.count - 1 || !_colorItems  || _colorItems.count == 0) {//如果传过来的颜色数组少于item个数则随机填充颜色
            pie.strokeColor = kPieRandColor.CGColor;
        } else {
            pie.strokeColor = ((UIColor *)_colorItems[i]).CGColor;
        }
        pie.strokeStart = start;
        pie.strokeEnd   = end;
        pie.lineWidth   = otherRadius * 2.0f;
        pie.zPosition   = 2;
        pie.path        = otherPath.CGPath;
        
        NSLog(@"%f",end - start);
        //计算百分比label的位置
        CGFloat centerAngle = M_PI * (start + end) + M_PI_2;
        CGFloat labelCenterX = self.frame.size.width * 0.5f * sinf(centerAngle) + self.frame.size.width * 0.5f;
        CGFloat labelCenterY = -self.frame.size.width * 0.5f * cosf(centerAngle) + self.frame.size.width * 0.5f;
        
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 23,23)];
        label.center = CGPointMake(labelCenterX, labelCenterY);
        label.text = [NSString stringWithFormat:@"%ld",(NSInteger)((end - start + 0.005) * 100)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:10];
        label.layer.zPosition = 3;
        label.layer.borderWidth = 1;
        [self addSubview:label];
        
        //计算下一个start位置 = 当前end位置
        start = end;
    }
    self.layer.mask = _bgCircleLayer;
}
-(void)setDataItems:(NSArray *)dataItems{
    _dataItems = dataItems;
    [self setNeedsDisplay];
}

- (void)stroke
{
    //画图动画
    self.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = 2;
    animation.fromValue = @0.0f;
    animation.toValue   = @1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [_bgCircleLayer addAnimation:animation forKey:@"circleAnimation"];
    
}
- (void)dealloc
{
    [self.layer removeAllAnimations];
}


@end
