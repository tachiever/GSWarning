//
//  SpecialWeaCell.h
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/26.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialWeaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *timlab;
@property (weak, nonatomic) IBOutlet UIImageView *weaImage;
- (void)setInf:(NSDictionary *)dic;

@end
