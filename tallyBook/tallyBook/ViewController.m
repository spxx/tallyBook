//
//  ViewController.m
//  tallyBook
//
//  Created by sunpeng on 2017/11/15.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import "ViewController.h"
#import "MoneyTableViewCell.h"
#import "JXCircleRatioView.h"
#import "TimePickerView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,TimePickerDalegate>
{
    UILabel *_yearLabel;
    UILabel *_monthLabel;
    UILabel *_costLabel;
    UILabel *_revenue;
    NSArray *_imagesArray;
    NSString *_year;
    NSString *_month;
}
@property(nonatomic,strong)UIView *tableHeaderV;

@property(nonatomic,strong)UITableView *tableView;


@property(nonatomic,strong)JXCircleRatioView *ratioView;
@property(nonatomic, strong)UIView *bottomV;

@property(nonatomic, strong)TimePickerView *timePickerView;
@property(nonatomic, strong)UIDatePicker *datePickerView; /** 时间选择器*/
@property(nonatomic, strong)UIView *pickerView; /** 选择器View*/
@property(nonatomic, strong)UIView *pickerViewBackgroundView; /** 选择器背景*/

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *sixtyFourPixelsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44+NAVIGATION_STATUSBAR_HEIGHT)];
    sixtyFourPixelsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    sixtyFourPixelsView.backgroundColor =  UIColorFromHEX(0x8c9bd3);
    [self.view addSubview:sixtyFourPixelsView];
    //init custom navigation bar
    UIImageView *customNavigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT, self.view.frame.size.width, 44)];
    customNavigationBar.userInteractionEnabled = YES;
    customNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [sixtyFourPixelsView addSubview:customNavigationBar];
    
    //title
    
    UILabel *navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width - 120, 44)];
    navigationLabel.tag = 10002;
    navigationLabel.backgroundColor = [UIColor clearColor];
    navigationLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin;
    navigationLabel.font = [UIFont boldSystemFontOfSize:16*NEW_BILI];
    navigationLabel.textColor = UIColorFromHEX(0xffffff);
    navigationLabel.text = @"记账本";
    navigationLabel.backgroundColor = [UIColor clearColor];
    navigationLabel.textAlignment = NSTextAlignmentCenter;
    navigationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [customNavigationBar addSubview:navigationLabel];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT+44, SCREEN_WIDTH, 140*NEW_BILI-NAVIGATION_STATUSBAR_HEIGHT-44)];
    topView.backgroundColor = UIColorFromHEX(0x8c9bd3);
    [self.view addSubview:topView];
    CGFloat with = SCREEN_WIDTH/3.0;
    CGFloat hegit = (140*NEW_BILI-NAVIGATION_STATUSBAR_HEIGHT-44-60*NEW_BILI)/2;
    
    
    for (int i = 0; i < 2; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(with+with*i, hegit, 1, 60*NEW_BILI)];
        line.backgroundColor =UIColorFromHEX(0xffffff);
        line.alpha = 0.6;
        [topView addSubview:line];
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyyMM"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    _year = [NSString stringWithFormat:@"%@年",[currentDateString substringToIndex:4]];
    _month = [NSString stringWithFormat:@"%@月",[currentDateString substringFromIndex:4]];
    _monthLabel = [UILabel new];
    _monthLabel.viewSize = CGSizeMake(with, 24*NEW_BILI);
    [_monthLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, topView.viewHeight - hegit)];
    _monthLabel.font = [UIFont boldSystemFontOfSize:24];
    _monthLabel.text = @"10月";
    _monthLabel.textColor = UIColorFromHEX(0xffffff);
    [_monthLabel sizeToFit];
    [_monthLabel align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(with/2, topView.viewHeight - hegit - (60*NEW_BILI - 20*NEW_BILI - _monthLabel.viewHeight)/2)];
    [topView addSubview:_monthLabel];
    
    UIImageView *row = [UIImageView new];
    row.viewSize = CGSizeMake(15, 15);
    [row align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_monthLabel.viewRightEdge + 5, _monthLabel.center.y)];
    row.image = [UIImage imageNamed:@"账单-下拉.png"];
    [topView addSubview:row];
    
    
    _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(_monthLabel.viewX, hegit+(60*NEW_BILI - 20*NEW_BILI - _monthLabel.viewHeight)/2, with, 12*NEW_BILI)];
    _yearLabel.text = @"2017年";
    _yearLabel.font = [UIFont systemFontOfSize:12*NEW_BILI];
    _yearLabel.textColor =UIColorFromHEX(0xffffff);
    [_yearLabel sizeToFit];
    _yearLabel.viewX = _monthLabel.viewX;
    [topView addSubview:_yearLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, with, topView.viewHeight)];
    [btn addTarget:self action:@selector(timeCheck) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
    
    _costLabel = [UILabel new];
    _costLabel.viewSize = CGSizeMake(with, 24*NEW_BILI);
    [_costLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, topView.viewHeight - hegit)];
    _costLabel.font = [UIFont boldSystemFontOfSize:24*NEW_BILI];
    _costLabel.text = @"588.00";
    _costLabel.textColor = UIColorFromHEX(0xffffff);
    [_costLabel sizeToFit];
    [_costLabel align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(with/2+with, _monthLabel.viewBottomEdge)];
    [topView addSubview:_costLabel];
    
    UILabel *costM = [[UILabel alloc] initWithFrame:CGRectMake(_costLabel.viewX, hegit+(60*NEW_BILI - 20*NEW_BILI - _monthLabel.viewHeight)/2, with, 12*NEW_BILI)];
    costM.text = @"支出";
    costM.font = [UIFont systemFontOfSize:12*NEW_BILI];
    costM.textColor =UIColorFromHEX(0xffffff);
    [costM sizeToFit];
    costM.viewX = _costLabel.viewX;
    [topView addSubview:costM];
    
    
    _revenue = [UILabel new];
    _revenue.viewSize = CGSizeMake(with, 24*NEW_BILI);
    [_revenue align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, topView.viewHeight - hegit)];
    _revenue.font = [UIFont boldSystemFontOfSize:24*NEW_BILI];
    _revenue.text = @"588.00";
    _revenue.textColor = UIColorFromHEX(0xffffff);
    [_revenue sizeToFit];
    [_revenue align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(with/2+with*2, _monthLabel.viewBottomEdge)];
    [topView addSubview:_revenue];
    
    UILabel *revenueM = [[UILabel alloc] initWithFrame:CGRectMake(_revenue.viewX, hegit + (60*NEW_BILI - 20*NEW_BILI - _monthLabel.viewHeight)/2, with, 12*NEW_BILI)];
    revenueM.text = @"收入";
    revenueM.font = [UIFont systemFontOfSize:12*NEW_BILI];
    revenueM.textColor =UIColorFromHEX(0xffffff);
    [revenueM sizeToFit];
    revenueM.viewX = _revenue.viewX;
    [topView addSubview:revenueM];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - topView.viewBottomEdge)];
    _tableView.backgroundColor = UIColorFromHEX(0xffffff);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[MoneyTableViewCell class] forCellReuseIdentifier:@"moneyCell"];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 1, 20);
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = self.tableHeaderV;
    
    [self.view addSubview:self.pickerViewBackgroundView];
    [self.view addSubview:self.pickerView];
}
-(void)loadData{
    
}

-(UIView *)pickerViewBackgroundView{
    if (!_pickerViewBackgroundView) {
        _pickerViewBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _pickerViewBackgroundView.backgroundColor = [UIColor blackColor];
        _pickerViewBackgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CkCancleButton)];
        [_pickerViewBackgroundView addGestureRecognizer:tap];
        _pickerViewBackgroundView.alpha = 0.0;
    }
    return _pickerViewBackgroundView;
}

-(UIView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 218)];
        _pickerView.alpha = 0.0;
        _pickerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, 0, 50, 38)];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [sureButton addTarget:self action:@selector(CkSureButton) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView addSubview:sureButton];
        
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 50, 38)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [cancleBtn addTarget:self action:@selector(CkCancleButton) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView addSubview:cancleBtn];
        [_pickerView addSubview:self.timePickerView];
        
        
    }
    return _pickerView;
}

-(TimePickerView *)timePickerView{
    if (!_timePickerView) {
        _timePickerView = [[TimePickerView alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, 188)];
        _timePickerView.delegate = self;
    }
    return _timePickerView;
}

-(UIView *)tableHeaderV{
    if (!_tableHeaderV) {
        _tableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 15)];
        titleL.text = @"消费报表";
        titleL.font = [UIFont systemFontOfSize:15];
        titleL.textAlignment = NSTextAlignmentCenter;
        [titleL sizeToFit];
        titleL.viewWidth = SCREEN_WIDTH;
        [_tableHeaderV addSubview:titleL];
        _ratioView = [[JXCircleRatioView alloc] initWithFrame:CGRectMake(0, titleL.viewBottomEdge + 22, SCREEN_WIDTH, 180+31) andCircleRadius:180/2];
        _ratioView.backgroundColor = [UIColor whiteColor];
        _ratioView.colorArray = @[UIColorFromHEX(0xff866a),UIColorFromHEX(0xb3bde1),
                                  UIColorFromHEX(0x6ae2f5),UIColorFromHEX(0x60e5a5),
                                  UIColorFromHEX(0xffbd6a)];
        _ratioView.nameArray = @[@"小卖部",@"食堂",@"澡堂",@"水果超市",@"开水房"];
        _ratioView.numArray = @[@"110.00",@"560.00",@"00.00",@"120.00",@"00.00"];
        [_tableHeaderV addSubview:_ratioView];
        
        [_ratioView stroke];
        
        _bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, _ratioView.viewBottomEdge, SCREEN_WIDTH, 0)];
        _bottomV.backgroundColor = [UIColor whiteColor];
        [self drawViewWithArray:_ratioView.numArray];
        [_tableHeaderV addSubview:_bottomV];
        
    }
    return _tableHeaderV;
}
-(void)timeCheck{
    NSLog(@"点击");
    _pickerView.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        _pickerViewBackgroundView.alpha = 0.3;
        _pickerView.frame =CGRectMake(0, SCREEN_HEIGHT-218, SCREEN_WIDTH, 218);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)CkSureButton{
    [self CkCancleButton];
    _yearLabel.text = _year;
    [_yearLabel sizeToFit];
    _monthLabel.text = _month;
    [_monthLabel sizeToFit];
    //数据请求
    [_ratioView stroke];
}

/**
 *  时间选择器的消失动画
 */
-(void)CkCancleButton{
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 218);
    } completion:^(BOOL finished) {
        _pickerView.alpha = 0.0;
        _pickerViewBackgroundView.alpha = 0;
    }];
    
}


-(void)getdatepicker:(NSString *)year andMonth:(NSString *)month{
    _year = year;
    _month = month;
}

-(void)drawViewWithArray:(NSArray *)numCount{
    
    for (UIView *subs in _bottomV.subviews) {
        [subs removeFromSuperview];
    }
    
    NSUInteger count = numCount.count%5>0?numCount.count/5+1:numCount.count/5;
    _bottomV.viewSize = CGSizeMake(SCREEN_WIDTH, count*20*NEW_BILI);
    CGFloat withS = 0;
    for (int x = 0; x<numCount.count; x++) {
        UIView *staticView = [[UIView alloc] initWithFrame:CGRectMake(20 * NEW_BILI+withS, (x/5)*20*NEW_BILI, withS, 12*NEW_BILI)];
        [_bottomV addSubview:staticView];
        
        UIView *colorV = [[UIView alloc] initWithFrame:CGRectMake(0, 1*NEW_BILI, 10*NEW_BILI, 10*NEW_BILI)];
        colorV.backgroundColor = _ratioView.colorArray[x];
        [staticView addSubview:colorV];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colorV.frame)+7*NEW_BILI, 0, 0, 12*NEW_BILI)];
        nameL.text = _ratioView.nameArray[x];
        nameL.textColor = UIColorFromHEX(0x8398a3);
        nameL.font = [UIFont systemFontOfSize:12*NEW_BILI];
        [nameL sizeToFit];
        nameL.viewHeight = 12*NEW_BILI;
        withS = withS + 20*NEW_BILI + nameL.viewRightEdge;
        staticView.viewWidth = withS;
        [staticView addSubview:nameL];
        
    }
    _tableHeaderV.viewSize = CGSizeMake(SCREEN_WIDTH, _bottomV.viewBottomEdge+8*NEW_BILI);
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34*NEW_BILI;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*NEW_BILI;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"moneyCell" forIndexPath:indexPath];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor =UIColorFromHEX(0xf4f4f4);
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(20, 15*NEW_BILI, SCREEN_WIDTH, 34*NEW_BILI)];
    timeL.text = @"2017-10-30";
    timeL.textColor = UIColorFromHEX(0x494d4f);
    timeL.font = [UIFont systemFontOfSize:10*NEW_BILI];
    [timeL sizeToFit];
    timeL.viewHeight = 10*NEW_BILI;
    [headerV addSubview:timeL];
    
    UILabel *costL = [UILabel new];
    costL.text = @"支出：50.00";
    costL.textColor = UIColorFromHEX(0x494d4f);
    costL.viewSize = CGSizeMake(SCREEN_WIDTH, 34*NEW_BILI);
    costL.font = [UIFont systemFontOfSize:10*NEW_BILI];
    [costL sizeToFit];
    costL.viewHeight = 10*NEW_BILI;
    [costL align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-20, 15*NEW_BILI)];
    [headerV addSubview:costL];
    
    return headerV;
}

@end

