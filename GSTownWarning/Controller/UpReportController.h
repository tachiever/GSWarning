//
//  UpReportController.h
//  GSTownWarning
//
//  Created by Tcy on 2017/9/29.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpReportController : UIViewController
@property (nonatomic ) NSMutableDictionary *useDic;

@property (copy,nonatomic) void (^actionUploadSuccess)();

@end
