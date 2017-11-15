//
//  MoneyTableViewCell.m
//  yizhangtong
//
//  Created by sunpeng on 2017/10/24.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import "MoneyTableViewCell.h"

@implementation MoneyTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.viewHeight  = 50*NEW_BILI;
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{    
    _classLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12*NEW_BILI, 100, 12*NEW_BILI)];
    _classLabel.text = @"食堂消费";
    _classLabel.textColor = UIColorFromHEX(0x494d4f);
    _classLabel.font = [UIFont systemFontOfSize:12*NEW_BILI];
    [_classLabel sizeToFit];
    _classLabel.viewHeight = 12*NEW_BILI;
    [self.contentView addSubview:_classLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.viewSize = CGSizeMake(200, 10*NEW_BILI);
    _timeLabel.textColor =UIColorFromHEX(0x78909c);
    _timeLabel.text = @"17:15";
    _timeLabel.font = [UIFont systemFontOfSize:10*NEW_BILI];
    [_timeLabel sizeToFit];
    _timeLabel.viewHeight = 10*NEW_BILI;
    [_timeLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(20, self.viewHeight-10*NEW_BILI)];
    [self.contentView addSubview:_timeLabel];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.viewSize = CGSizeMake(20, 10*NEW_BILI);
    _moneyLabel.textColor = UIColorFromHEX(0xff866a);
    _moneyLabel.font = [UIFont systemFontOfSize:17*NEW_BILI];
    _moneyLabel.text = @"-20.00";
    [_moneyLabel sizeToFit];
    _moneyLabel.viewHeight = 17*NEW_BILI;
    [_moneyLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-20, 14*NEW_BILI)];
    [self.contentView addSubview:_moneyLabel];
    
}
    


@end
