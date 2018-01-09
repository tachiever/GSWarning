//
//  YujingCell.h
//  GSTownWarning
//
//  Created by Tcy on 2017/10/12.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YujingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *statueImage;
@property (weak, nonatomic) IBOutlet UILabel *detLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

- (void)setDateTime:(NSString *)tim;
- (void)setInform:(NSDictionary *)dic;
@end
