//
//  AtmoSeverCell.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/26.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "AtmoSeverCell.h"

@implementation AtmoSeverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self stup];
    // Initialization code
}
- (void)stup{

    _bgView.layer.masksToBounds=NO;
    //_bgView.layer.cornerRadius=6;
    _bgView.layer.shadowColor=[UIColor grayColor].CGColor;
    _bgView.layer.shadowOffset=CGSizeMake(0, 0);
    _bgView.layer.shadowOpacity=0.8;
    _bgView.layer.shadowRadius=3.f;
    if (SCREEN_WIDTH<330) {
        self.titLab.font=[UIFont systemFontOfSize:15];
        self.timLab.font=[UIFont systemFontOfSize:14];
    }else{
        self.titLab.font=[UIFont systemFontOfSize:16];
        self.timLab.font=[UIFont systemFontOfSize:14];
    }
}

- (void)setInf:(NSDictionary *)dic{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[dic[@"up_time"] doubleValue]/1000.0];
    NSString *titleString=[dateFormatter stringFromDate:date];
    _timLab.text=[NSString stringWithFormat:@"%@",titleString];
    _titLab.text=dic[@"title"];
    
}

- (void)setBaiKeInf:(NSDictionary *)dic{
    _titLab.text=dic[@"title"];
    [_iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"img"]]]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
