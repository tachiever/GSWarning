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
    _titLab.text=dic[@"report_type"];
    
    CGRect fre=_titLab.frame;
    fre.size.width=[NSString stringWidth:dic[@"report_type"] font:16]+8;
    
    _titLab.frame=fre;
    
    _detailLab.text=dic[@"report_content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[dic[@"report_time"] doubleValue]/ 1000.0];
    NSString *titleString=[dateFormatter stringFromDate:date];
    _timlab.text=[NSString stringWithFormat:@"上报人:%@\n%@",dic[@"name"],titleString];
    
    
    NSArray  *array = [dic[@"report_filepath"] componentsSeparatedByString:@","];

    for (int i=0; i<array.count; i++) {
        
        
        if ([array[i] rangeOfString:@"jpg"].location !=NSNotFound||[array[i] rangeOfString:@"png"].location !=NSNotFound) {
            
            
            
            [NBRequest requestWithURL:[NSString stringWithFormat:@"%@%@",URLHOST,array[i]] type:RequestNormal success:^(NSData *requestData) {
                [_weaImage setImage:[UIImage imageWithData:requestData]];
                

                
            } failed:^(NSError *error) {
                
            }];
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",URLHOST,array[i]]);
            break;
        }else{
        
            [_weaImage setImage:[UIImage imageNamed:@"logo.png"]];
        
        }
    }

    
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
