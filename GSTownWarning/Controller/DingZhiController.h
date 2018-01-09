//
//  DingZhiController.h
//  GSTownWarning
//
//  Created by Tcy on 2017/10/10.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DingZhiController : UIViewController
@property (nonatomic ) NSString *type;
@property (nonatomic ) NSMutableArray *pointArray;
@property (copy,nonatomic) void (^actionSelectPoint)(NSMutableArray *pointArray);

@end
