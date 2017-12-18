//
//  NSString+SignStr.h
//  ZhenBanWeather
//
//  Created by Tcy on 2017/9/15.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SignStr)
+ (NSString *)ChineseDateMandD;
+ (NSString *)ChineseDate;
+(NSString *)nowTimeStyle1;
+(NSString *)nowTimeStyle2;
+(NSString *)timeStr;
+(NSString *)signStrWithToken:(NSString *)str tim:(NSString *)tim;

@end
