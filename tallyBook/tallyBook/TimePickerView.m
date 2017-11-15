//
//  TimePickerView.m
//  IOSlineChart
//
//  Created by liuchun on 2017/8/10.
//  Copyright © 2017年 zhangleishan. All rights reserved.
//

#import "TimePickerView.h"



#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface TimePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong,nonatomic) UIPickerView *datePicker;
@property (strong,nonatomic) NSMutableArray *monthData;//月数据
@property (strong,nonatomic) NSMutableArray *yearData;//年数据

@property (strong,nonatomic) NSString  *timeSelectedString;//选择时间结果
@property (strong,nonatomic)NSString  *monthStr;//月
@property (strong,nonatomic)NSString  *yearStr;//年

@end

@implementation TimePickerView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{
    
    //添加自定义一个时间选择器
    self.datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,self.bounds.size.height)];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.dataSource = self;
    self.datePicker.delegate = self;
    //初始时间选择文字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    self.monthStr = [formatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy"];
    self.yearStr = [formatter1 stringFromDate:[NSDate date]];
    
    self.timeSelectedString = [NSString stringWithFormat:@"%@-%@",self.yearStr,self.monthStr];
    [self.datePicker selectRow:self.monthStr.integerValue-1 inComponent:1 animated:NO];
    [self.datePicker selectRow:self.yearStr.integerValue-2015 inComponent:0 animated:NO];
    
    [self addSubview:self.datePicker];

}

//获取日期
-(void)getdate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY.MM"];
    self.timeSelectedString = [dateFormatter stringFromDate:date];
}
#pragma mark pickDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    //年，月
    return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.yearStr = self.yearData[row];
    }else{
        self.monthStr = self.monthData[row];
    }
   
    self.timeSelectedString = [NSString stringWithFormat:@"%@-%@",self.yearStr,self.monthStr];
    NSLog(@"%@",self.timeSelectedString);
    if ([_delegate respondsToSelector:@selector(getdatepicker:andMonth:)]) {
        if (!self.timeSelectedString) {
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            [self getdate:currentDate];
        }
        [_delegate getdatepicker:[NSString stringWithFormat:@"%@年",self.yearStr] andMonth:[NSString stringWithFormat:@"%@月",self.monthStr]];
    }

}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        //年分200年
        return self.yearData.count;
    }else {
        //月份12各月
        return 12;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return  [NSString stringWithFormat:@"%@年",self.yearData[row]];
    }else {
        return  [NSString stringWithFormat:@"%@月",self.monthData[row]];
    }
}

-(NSMutableArray *)monthData{
    if (!_monthData) {
        _monthData = [[NSMutableArray alloc]init];
        for (int i = 1; i<13; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [self.monthData addObject:str];
        }
    }
    return _monthData;
}
-(NSMutableArray *)yearData{
    if (!_yearData) {
        _yearData = [[NSMutableArray alloc]init];
        for (int i = 2015; i<=[self.yearStr intValue]; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [self.yearData addObject:str];
        }
    }
    return _yearData;
}



@end

