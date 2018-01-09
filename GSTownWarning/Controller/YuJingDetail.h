//
//  YuJingDetail.h
//  GSTownWarning
//
//  Created by Tcy on 2017/9/29.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuJingDetail : UIViewController


@property (nonatomic ) NSDictionary *dic;
@property (nonatomic ) NSMutableDictionary *userDic;
@property (nonatomic ) NSString *detKin;
@property (nonatomic ) NSString *detId;

@property (copy,nonatomic) void (^readInform)();

@end
