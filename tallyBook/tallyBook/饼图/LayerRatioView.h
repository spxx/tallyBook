//
//  LayerRatioView.h
//  tallyBook
//
//  Created by sunpeng on 2017/11/15.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayerRatioView : UIView

@property(nonatomic , copy) NSArray *dataItems;//数据

@property(nonatomic , copy) NSArray *colorItems;//颜色

@property(nonatomic , assign) CGFloat circleRadius;

@property(nonatomic , strong) CAShapeLayer *bgCircleLayer;

- (instancetype)initWithFrame:(CGRect)frame andCircleRadius:(CGFloat)circleRadius;


@end
