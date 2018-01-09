//
//  SelectBtn.h
//  GSTownWarning
//
//  Created by Tcy on 2017/10/30.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectBtn : UIView
@property (copy,nonatomic) void (^selectBtn)(NSInteger tag);
- (void)createWith:(NSString *)ImageName name:(NSString *)name;
@end
