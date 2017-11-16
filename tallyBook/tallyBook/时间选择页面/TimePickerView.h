//
//  TimePickerView.h
//  IOSlineChart
//
//  Created by liuchun on 2017/8/10.
//  Copyright © 2017年 zhangleishan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimePickerDalegate <NSObject>

-(void)getdatepicker:(NSString *)year andMonth:(NSString *)month;

@end


@interface TimePickerView : UIView

@property(nonatomic,assign)id <TimePickerDalegate> delegate;

@end
