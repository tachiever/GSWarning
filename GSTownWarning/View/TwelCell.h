//
//  TwelCell.h
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/21.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwelCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgImage;
@property (weak, nonatomic) IBOutlet UIImageView *weaIcon;
@property (weak, nonatomic) IBOutlet UILabel *timLab;
@property (weak, nonatomic) IBOutlet UILabel *temLab;
@property (weak, nonatomic) IBOutlet UILabel *weaLab;
@property (weak, nonatomic) IBOutlet UIImageView *weaImage;

@end
