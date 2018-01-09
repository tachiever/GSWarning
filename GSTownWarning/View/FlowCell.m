//
//  FlowCell.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/9.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "FlowCell.h"

@implementation FlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self stup];
}

- (void)setIconimageWith:(NSInteger)inte{

    [_iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",inte+1]]];


}

- (void)stup{
    
    _bgVie.layer.masksToBounds=NO;
    _bgVie.layer.cornerRadius=6;
    _bgVie.layer.shadowColor=[UIColor grayColor].CGColor;
    _bgVie.layer.shadowOffset=CGSizeMake(0, 0);
    _bgVie.layer.shadowOpacity=0.7;
    _bgVie.layer.shadowRadius=2.f;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
