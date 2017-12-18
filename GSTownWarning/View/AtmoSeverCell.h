//
//  AtmoSeverCell.h
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/26.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AtmoSeverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *timLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

- (void)setInf:(NSDictionary *)dic;
- (void)setBaiKeInf:(NSDictionary *)dic;
@end
