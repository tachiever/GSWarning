//
//  ThrHoursView.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/20.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "ThrHoursView.h"
#import "WeaAndPressView.h"

@interface ThrHoursView(){
    
}
@property (nonatomic ) NSMutableArray *weaArray;
@property (nonatomic ) NSMutableArray *fallArray;
@property (nonatomic ) CGFloat preW;

@end

@implementation ThrHoursView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        _weaArray=[[NSMutableArray alloc]init];
        _fallArray=[[NSMutableArray alloc]init];
        
        NSArray *falarr=@[@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风",@"西风"];
        NSArray *arr=@[@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴"];
        
        [_weaArray addObjectsFromArray:arr];
        [_fallArray addObjectsFromArray:falarr];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    _preW=self.frame.size.width/_weaArray.count;
    
    //NSNumber *max = [_fallArray valueForKeyPath:@"@max.floatValue"];
   // CGFloat hig=([max floatValue]==0)?1:[max floatValue];
    for (int i=0; i<_weaArray.count; i++) {
        WeaAndPressView *wpv = [[WeaAndPressView alloc] initWithFrame:CGRectMake(_preW*i, 0, _preW, self.frame.size.height)];
        [wpv updateWithWeather:[NSString stringWithFormat:@"%@",_weaArray[i]] fall:0 fallNum:[NSString stringWithFormat:@"%@",_fallArray[i] ]];
        [self addSubview:wpv];

    }
}

- (void)updateWithWeaArr:(NSMutableArray *)weaArr fall:(NSMutableArray *)fallarr{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_weaArray removeAllObjects];
    [_fallArray removeAllObjects];
    _weaArray =[weaArr mutableCopy];
    _fallArray =[fallarr mutableCopy];
    [self setNeedsDisplay];
}
@end
