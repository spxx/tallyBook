//
//  JXCircleRatioView.h
//  circleViewDome
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXCircleRatioView : UIView

@property(nonatomic , assign) CGFloat circleRadius;// 半径

@property(nonatomic , strong) NSArray *colorArray;//颜色
@property(nonatomic , strong) NSArray *nameArray;//名字
@property(nonatomic , strong) NSArray *numArray;//数字
@property(nonatomic , strong) NSArray *imagesArray;//图片

@property(nonatomic , strong) CAShapeLayer *bgCircleLayer;

- (instancetype)initWithFrame:(CGRect)frame andCircleRadius:(CGFloat)circleRadius;

-(void)stroke;

@end
