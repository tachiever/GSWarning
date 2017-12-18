//
//  PProvinces.h
//  UI--67--生日--自定义键盘
//
//  Created by tcy on 16/4/11.
//  Copyright © 2016年 tcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PProvinces : NSObject

@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSString *name;

+ (instancetype)provincesWithDict:(NSDictionary *)dict;
@end
