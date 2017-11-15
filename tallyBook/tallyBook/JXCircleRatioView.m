//
//  JXCircleRatioView.m
//  circleViewDome
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCircleRatioView.h"

/*! 白色圆的半径 */
static CGFloat const whiteCircleRadius = 76.0/2.0;
/*! 指引线的小圆 */
static CGFloat const smallCircleRadius = 4.0;
/*! 折线的宽度 */
static CGFloat const foldLineWidth = 20.0;


@implementation JXCircleRatioView


- (instancetype)initWithFrame:(CGRect)frame andCircleRadius:(CGFloat)circleRadius{
    
    if (self = [super initWithFrame:frame]) {
        _imagesArray  = @[@"小卖部.png",@"食堂.png",@"澡堂.png",@"水果.png",@"开水.png"];
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

/// 比例
- (CGFloat)getShareNumber:(NSArray *)arr{
    CGFloat f = 0.0;
    for (int  i = 0; i < arr.count; i++) {
        
        NSString *number = arr[i];
        f += [number floatValue];
    }
    //NSLog(@"总量：%.2f  比例:%.2f",f,360.0 / f);
    return M_PI*2 / f;
}

- (void)drawRect:(CGRect)rect {
    
    // 1.所占比例
    CGFloat bl = [self getShareNumber:self.numArray];

  
    
    // 2.开启上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat angle_start = 0; //开始时的弧度  －－－－－ 旋转200度
    CGFloat ff = 0;  //记录偏转的角度 －－－－－ 旋转200度
    
    CGFloat start = 0.0f;
    CGFloat end = 0.0f;
    
    for (int i = 0; i < self.numArray.count ; i ++) {
        
        
        CGFloat angle_end =  [self.numArray[i] floatValue] * bl + ff;  //结束
        
        end = [self.numArray[i] floatValue] / (M_PI *2 / bl) + start;
        
        ff += [self.numArray[i] floatValue] * bl;
        
        NSLog(@"angle_end == %f ----- %.2f",angle_end,end-start);
        
        CGFloat h = (angle_end + angle_start) / 2.0;
        
        CGFloat portion = 0.463;
        // 6.起始点
        CGFloat xx = self.frame.size.width  / 2.0 + (_circleRadius) * cosf(h);
        CGFloat yy = self.frame.size.height / 2.0 + (_circleRadius) * sinf(h);
        if (xx > self.frame.size.width * 0.5) {
            if (cosf(h)>portion) {
                xx = xx - (_circleRadius - whiteCircleRadius)*(cosf(h)-portion);
            }else{
                xx = xx - (_circleRadius - whiteCircleRadius)*cosf(h);
            }
            if (sinf(h)>portion) {
                yy = yy - (_circleRadius - whiteCircleRadius)*portion;
            }else if (sinf(h)<portion&&sinf(h)>-portion){
                yy = yy - (_circleRadius - whiteCircleRadius)*sinf(h);
            }
            else {
                yy = yy + (_circleRadius - whiteCircleRadius)*portion;
            }
            if(yy>self.viewHeight*0.5){
                yy+=3;
            }else{
                yy-=3;
            }
        }else{
            if (cosf(h)<-portion) {
                xx = xx - (_circleRadius - whiteCircleRadius)*(cosf(h)+portion);
            }else if(cosf(h)>portion){
                xx = xx - (_circleRadius - whiteCircleRadius)*portion;
            }else{
                xx = xx - (_circleRadius - whiteCircleRadius)*cosf(h);
            }

            if (sinf(h)<-portion) {
                yy = yy - (_circleRadius - whiteCircleRadius)*(sinf(h)+portion);
            }else if(sinf(h)>-portion&&sinf(h)<portion) {
                yy = yy - (_circleRadius - whiteCircleRadius)*sinf(h);
            }else{
                yy = yy - (_circleRadius - whiteCircleRadius)*portion;
            }
        }
        
        CGFloat centerAngle = M_PI * (start + end) + M_PI_2;
        NSLog(@"%f-----%f",sinf(centerAngle),cosf(centerAngle));
        CGFloat labelCenterX =   _circleRadius * sinf(centerAngle) + self.viewWidth*0.5  - ((_circleRadius - whiteCircleRadius)/2)*sinf(centerAngle);
        CGFloat labelCenterY = - _circleRadius * cosf(centerAngle) + self.viewHeight*0.5 + ((_circleRadius - whiteCircleRadius)/2)*cosf(centerAngle);

        
        UIImageView *imageV = [UIImageView new];
        imageV.viewSize = CGSizeMake(23, 23);
        [imageV align:ViewAlignmentCenter relativeToPoint:CGPointMake(labelCenterX, labelCenterY)];
        imageV.image = [UIImage imageNamed:_imagesArray[i]];
        [self addSubview:imageV];
    
        
        /*!参数：
         // 1.上下文
         // 2.中心点
         // 3.开始
         // 4.结束
         // 5.颜色
         */
        [self drawArcWithCGContextRef:ctx andWithPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) andWithAngle_start:angle_start andWithAngle_end:angle_end andWithColor:self.colorArray[i] andInt:i];
        
        angle_start = angle_end;
        start = end;
    }
    //3.添加中心圆
    [self addCenterCircle];
    
}


/// 添加中心白色圆
-(void)addCenterCircle{
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:whiteCircleRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    [[UIColor whiteColor] set];
    [arcPath fill];
    [arcPath stroke];
    
}



/**
 画圆弧
 
 @param ctx 上下文
 @param point 圆心
 @param angle_start 开始角度
 @param angle_end 结束角度
 @param color 颜色
 @param n 表示第几个弧行
 */
-(void)drawArcWithCGContextRef:(CGContextRef)ctx
                  andWithPoint:(CGPoint) point
            andWithAngle_start:(float)angle_start
              andWithAngle_end:(float)angle_end
                  andWithColor:(UIColor *)color
                        andInt:(int)n{
    
    // 1.开始画线
    CGContextMoveToPoint(ctx, point.x, point.y);

    // 2.颜色空间填充
    CGContextSetFillColor(ctx, CGColorGetComponents(color.CGColor));
    
    // 3.画圆
    CGContextAddArc(ctx, point.x, point.y, self.circleRadius, angle_start, angle_end, 0);
    
    // 4.填充
    CGContextFillPath(ctx);
    
    // 5.弧度的中心角度
    CGFloat h = (angle_end + angle_start) / 2.0;
    
    // 6.起始点
    CGFloat xx = self.frame.size.width  / 2 + (_circleRadius) * cos(h) ;
    CGFloat yy = self.frame.size.height / 2 + (_circleRadius) * sin(h) ;
    
    // 7.画折线
    [self addLineAndnumber:color andCGContextRef:ctx andX:xx andY:yy andInt:n angele:h];
    
}

/**
 * @color 颜色
 * @ctx CGContextRef
 * @x 小圆的中心点的x
 * @y 小圆的中心点的y
 * @n 表示第几个弧行
 * @angele 弧度的中心角度
 */

//画线
-(void)addLineAndnumber:(UIColor *)color
        andCGContextRef:(CGContextRef)ctx
                   andX:(CGFloat)x
                   andY:(CGFloat)y
                 andInt:(int)n
                 angele:(CGFloat)angele{
    
    // 1.起始点
    CGFloat smallCircleCenterPointX = x;
    CGFloat smallCircleCenterPointY = y;
    
    
    // 2.折点
    CGFloat lineLosePointX = 0.0 ; //指引线的折点
    CGFloat lineLosePointY = 0.0 ; //
    
    // 3.指引线的终点
    CGFloat lineEndPointX ; //
    CGFloat lineEndPointY ; //
    
    // 4.数字的起点
    CGFloat numberStartX;
    CGFloat numberStartY;
    
    // 5.文字的起点
//    CGFloat textStartX;
//    CGFloat textStartY;
    
    // 6.数字的长度
    NSString *number = self.numArray[n];
    CGSize numberSize = [number sizeWithAttributes:@{
                                                     NSFontAttributeName:[UIFont systemFontOfSize:10.0]
                                                     }];
    
    // 文字size
//    CGSize textSize = [model.name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:nameTextFont]}];
    
    
    // 设置折点
    lineLosePointX = smallCircleCenterPointX + foldLineWidth * cosf(angele);
    lineLosePointY = smallCircleCenterPointY + (- foldLineWidth * cosf(angele));
    
    
    // 7.画小圆
    if (smallCircleCenterPointX > self.bounds.size.width * 0.6 ) {
        
        // 指引线终点
        lineEndPointX = self.bounds.size.width - 18;
        lineEndPointY = lineLosePointY;
        
        // 数字
        numberStartX = lineEndPointX - 2 - numberSize.width;
        numberStartY = lineEndPointY - numberSize.height - 4;
        
        // 文字
//        textStartX = lineEndPointX - textSize.width;
//        textStartY = lineEndPointY;
        
        
    }else{
        
        // 指引线终点
        lineEndPointX = 18;
        lineEndPointY = lineLosePointY;
        
        // 数字
        numberStartX = lineEndPointX + 2;
        numberStartY = lineEndPointY - numberSize.height - 4;
        
        // 文字
//        textStartX = lineEndPointX;
//        textStartY = lineEndPointY;
        
    }
    
    
    if ([number floatValue]>0) {
        // 8.画小圆
        /*!创建圆弧
         参数：
         center->圆点
         radius->半径
         startAngle->起始位置
         endAngle->结束为止
         clockwise->是否顺时针方向
         */
        
        UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(lineEndPointX, lineEndPointY) radius:smallCircleRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        [color set];
        // 填充
        [arcPath fill];
        // 描边，路径创建需要描边才能显示出来
        [arcPath stroke];
        // 9.画指引线
        CGContextBeginPath(ctx);
        
        CGContextMoveToPoint(ctx, smallCircleCenterPointX, smallCircleCenterPointY);
        
        CGContextAddLineToPoint(ctx, lineLosePointX, lineLosePointY);
        CGContextAddLineToPoint(ctx, lineEndPointX, lineEndPointY);
        CGContextSetLineWidth(ctx, 1);
        
        //填充颜色
        CGContextSetFillColorWithColor(ctx , color.CGColor);
        CGContextStrokePath(ctx);
        // 10.画指引线上的数字
        [self.numArray[n] drawAtPoint:CGPointMake(numberStartX, numberStartY) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:color}];
        
    }
    
    
}

/// 重绘
-(void)setNumArray:(NSArray *)numArray{
    NSMutableArray *NumArray = [NSMutableArray array];
    [numArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!([obj floatValue]==0)) {
            [NumArray addObject:obj];
        }
    }];
    _numArray = NumArray;
    [self setNeedsDisplay];
}

-(void)stroke{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = 1;
    animation.fromValue = @0.0f;
    animation.toValue   = @1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [_bgCircleLayer addAnimation:animation forKey:@"circleAnimation"];
}


@end
