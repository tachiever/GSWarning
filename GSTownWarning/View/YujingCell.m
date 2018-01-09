//
//  YujingCell.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/12.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "YujingCell.h"

@implementation YujingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDateTime:(NSString *)tim{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd HH:mm"];
    
    NSDate *dat=[NSDate dateWithTimeIntervalSince1970:[tim floatValue]/1000];
    NSString  *time=[dateFormatter stringFromDate:dat];
    _timeLab.text=[NSString stringWithFormat:@"更新时间:%@",time];

}

- (void)setInform:(NSDictionary *)dic{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd HH:mm"];
    
    NSDate *dat=[NSDate dateWithTimeIntervalSince1970:[dic[@"PUB_TIME"] floatValue]/1000];
    NSString  *time=[dateFormatter stringFromDate:dat];
    _timeLab.text=[NSString stringWithFormat:@"更新时间:%@",time];
    self.detLab.text=dic[@"CONTENT"];
    
    
    //NSLog(@"%@",[dic[@"WARN_LEVEL"] substringToIndex:2]);
    if ([[dic[@"WARN_LEVEL"] substringToIndex:2] isEqualToString:@"红色"]) {
        [self.iconImage setImage:[UIImage imageNamed:@"hs.png"]];
    }
    if ([[dic[@"WARN_LEVEL"] substringToIndex:2] isEqualToString:@"橙色"]) {
        [self.iconImage setImage:[UIImage imageNamed:@"c.png"]];
    }
    if ([[dic[@"WARN_LEVEL"] substringToIndex:2] isEqualToString:@"蓝色"]) {
        [self.iconImage setImage:[UIImage imageNamed:@"l.png"]];
    }
    if ([[dic[@"WARN_LEVEL"] substringToIndex:2] isEqualToString:@"黄色"]) {
        [self.iconImage setImage:[UIImage imageNamed:@"h.png"]];
    }


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
