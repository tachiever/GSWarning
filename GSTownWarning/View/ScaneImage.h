//
//  ScaneImage.h
//  GSTownWarning
//
//  Created by Tcy on 2017/11/9.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaneImage : UIView

- (void)setWithImage:(UIImage *)image;

@property (copy,nonatomic) void (^hiddenView)();

@end
