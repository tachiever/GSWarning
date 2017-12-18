//
//  TwelCell.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/21.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "TwelCell.h"

@implementation TwelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgImage.layer.masksToBounds=YES;
    _bgImage.layer.cornerRadius=6;
    _bgImage.layer.borderWidth=1.5;

}

-(void)setInfor:(NSMutableDictionary *)dic{



}

@end
