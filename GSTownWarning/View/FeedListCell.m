//
//  FeedListCell.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/9.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "FeedListCell.h"

@implementation FeedListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self stup];
}


- (void)stup{
    
    _bgView.layer.masksToBounds=NO;
    _bgView.layer.cornerRadius=6;
    _bgView.layer.shadowColor=[UIColor grayColor].CGColor;
    _bgView.layer.shadowOffset=CGSizeMake(0, 0);
    _bgView.layer.shadowOpacity=0.7;
    _bgView.layer.shadowRadius=2.f;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
