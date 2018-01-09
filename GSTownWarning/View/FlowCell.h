//
//  FlowCell.h
//  GSTownWarning
//
//  Created by Tcy on 2017/10/9.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineUp;
@property (weak, nonatomic) IBOutlet UILabel *lineDown;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UILabel *timLab;
@property (weak, nonatomic) IBOutlet UILabel *suggLab;
@property (weak, nonatomic) IBOutlet UIView *bgVie;
- (void)setIconimageWith:(NSInteger)inte;
@end
