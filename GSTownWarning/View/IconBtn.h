//
//  IconBtn.h
//  GSTownWarning
//
//  Created by Tcy on 2017/10/11.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconBtn : UIView
@property (nonatomic ) UILabel *titLab;
@property (nonatomic ) UIButton * closeBtn;


@property (copy,nonatomic) void (^actionClose)(NSInteger tag);
@end
