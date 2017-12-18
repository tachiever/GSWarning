//
//  SpecialWeaCell.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/26.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "SpecialWeaCell.h"

@implementation SpecialWeaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self stup];


}

- (void)stup{
    
    _titLab.layer.masksToBounds=YES;
    _titLab.layer.cornerRadius=4 ;

}
- (void)setInf:(NSDictionary *)dic{
    _titLab.text=dic[@"title"];
    _detailLab.text=dic[@"detailed"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[dic[@"up_time"] doubleValue]/ 1000.0];
    NSString *titleString=[dateFormatter stringFromDate:date];
    _timlab.text=titleString;
    
    [NBRequest requestWithURL:[NSString stringWithFormat:@"%@%@",URLHOST,dic[@"img"]] type:RequestNormal success:^(NSData *requestData) {
        [_weaImage setImage:[UIImage imageWithData:requestData]];
    } failed:^(NSError *error) {
        
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
