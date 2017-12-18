//
//  SixView.h
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/19.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SixView : UIView
- (void)updateWithArr:(NSMutableArray *)datArr tim:(NSMutableArray *)timArr
                  tem:(NSMutableArray *)temArr;
@end
