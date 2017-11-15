//
//  define.h
//  jizhangben
//
//  Created by sunpeng on 2017/10/24.
//  Copyright © 2017年 mac1. All rights reserved.
//

#ifndef define_h
#define define_h

//导航和状态栏高度
#define NAVIGATION_STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//不同屏幕相对375的比例
#define NEW_BILI ([UIScreen mainScreen].bounds.size.width/375.0)

#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif /* define_h */
