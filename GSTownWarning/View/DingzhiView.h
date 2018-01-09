//
//  DingzhiView.h
//  GSTownWarning
//
//  Created by Tcy on 2017/10/11.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DingzhiView : UIView
- (void)updateWithArr:(NSMutableArray *)titArr;
@property (nonatomic ) NSInteger model;
@property (copy,nonatomic) void (^actionCloseView)(NSInteger tag);

@end
