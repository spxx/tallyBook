//
//  UIView+UIview_Layout.h
//  jizhangben
//
//  Created by sunpeng on 2017/10/25.
//  Copyright © 2017年 mac1. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    ViewAlignmentTopLeft,
    ViewAlignmentTopCenter,
    ViewAlignmentTopRight,
    ViewAlignmentMiddleLeft,
    ViewAlignmentCenter,
    ViewAlignmentMiddleRight,
    ViewAlignmentBottomLeft,
    ViewAlignmentBottomCenter,
    ViewAlignmentBottomRight,
}ViewAlignment;

@interface UIView (UIview_Layout)

@property (nonatomic ) CGFloat viewWidth;        //view.frame.size.width
@property (nonatomic ) CGFloat viewHeight;        //view.frame.size.height
@property (nonatomic ) CGFloat viewX;            //view.frame.origin.x
@property (nonatomic ) CGFloat viewY;            //view.frame.origin.y
@property (nonatomic ) CGPoint viewOrigin;        //view.frame.origin
@property (nonatomic ) CGSize  viewSize;            //view.frame.size
@property (nonatomic ) CGFloat viewRightEdge;    //view.frame.origin.x + view.frame.size.width
@property (nonatomic ) CGFloat viewBottomEdge;    //view.frame.origin.y + view.frame.size.height

- (CGPoint)boundsCenter;

- (void)frameIntegral;

- (CGPoint)leftBottomCorner;

- (CGPoint)leftTopCorner;

- (CGPoint)rightTopCorner;

- (CGPoint)rightBottomCorner;

-(void)align:(ViewAlignment)alignment relativeToPoint:(CGPoint)point;
//position the view relative to a rectangle
-(void)align:(ViewAlignment)alignment relativeToRect:(CGRect)rect;
@end
