//
//  PProvinces.m
//  UI--67--生日--自定义键盘
//
//  Created by tcy on 16/4/11.
//  Copyright © 2016年 tcy. All rights reserved.
//

#import "PProvinces.h"

@implementation PProvinces
+ (instancetype)provincesWithDict:(NSDictionary *)dict
{
    PProvinces *pro = [[self alloc] init];
    [pro setValuesForKeysWithDictionary:dict];
    return pro;
}
@end
