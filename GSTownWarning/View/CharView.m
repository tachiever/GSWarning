//
//  CharView.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/18.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "CharView.h"

@interface CharView(){

}
@property (nonatomic ) NSMutableArray *dataArray;
@property (nonatomic ) NSMutableArray *timArray;
@property (nonatomic ) CGFloat preW;
@property (nonatomic ) CGFloat viewH;

@end

@implementation CharView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        _dataArray=[[NSMutableArray alloc]init];
        _timArray=[[NSMutableArray alloc]init];
        
        NSArray *arr=@[@"20",@"10",@"10",@"10",@10,@"10",@10,@"10",@"10",@"10",@"10",@10,@"10",@10,@"10",@"10"];
        NSArray *timarr=@[@"0:00",@"3:00",@"6:00",@"9:00",@"12:00",@"15:00",@"18:00",@"21:00",@"0:00",@"3:00",@"6:00",@"9:00",@"12:00",@"15:00",@"18:00",@"21:00"];

        [_dataArray addObjectsFromArray:arr];
        [_timArray addObjectsFromArray:timarr];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    _preW=(self.frame.size.width-50)/(_dataArray.count-1);
    _viewH=self.frame.size.height-40;
    NSNumber *max = [_dataArray valueForKeyPath:@"@max.floatValue"];
    NSNumber *min = [_dataArray valueForKeyPath:@"@min.floatValue"];
    CGFloat hig=([max floatValue]==[min floatValue])?1:[max floatValue]-[min floatValue];;

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetRGBStrokeColor(ctx, 250, 250, 250, 0.9);
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, 25, 35+_viewH*(1-([_dataArray[0] floatValue]-[min floatValue])/hig));
    for (int i=1; i<_dataArray.count; i++) {
        CGContextAddLineToPoint(ctx, 25+_preW*i, 35+_viewH*(1-([_dataArray[i] floatValue]-[min floatValue])/hig));
    }
    CGContextStrokePath(ctx);
    
    for (int i=0; i<_dataArray.count; i++) {
        CGContextRef ctx1 = UIGraphicsGetCurrentContext();
        //CGContextSetRGBStrokeColor(ctx1, 240, 255, 0, 1.0);
        CGContextSetLineWidth(ctx1, 1.5);
        [RGBACOLOR(250, 255, 0, 0.9) set];
        CGContextAddArc(ctx1, 25+_preW*i, 35+_viewH*(1-([_dataArray[i] floatValue]-[min floatValue])/hig), 3, 0, 2*M_PI, 0);
        CGContextFillPath(ctx1);
        
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_preW*i, 15+_viewH*(1-([_dataArray[i] floatValue]-[min floatValue])/hig), 50, 20)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.text =[NSString stringWithFormat:@"%@℃",_dataArray[i]];
        lab.font = [UIFont systemFontOfSize:10];
        lab.textColor=[UIColor whiteColor];
        [self addSubview:lab];
        
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(_preW*i, 0, 50, 20)];
        lab1.textAlignment=NSTextAlignmentCenter;
        
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:00"];
        
        NSTimeInterval interval = 60 * 60 * [_timArray[i] integerValue];
        NSString *titleString = [dateFormatter stringFromDate:[[NSDate date] initWithTimeInterval:interval sinceDate:[NSDate date]]];
        
        lab1.text =[NSString stringWithFormat:@"%@",titleString];
        lab1.font = [UIFont systemFontOfSize:13];
        lab1.textColor=[UIColor whiteColor];
        [self addSubview:lab1];

    }
}

- (void)updateWithArr:(NSMutableArray *)datArr tim:(NSMutableArray *)timArr{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_dataArray removeAllObjects];
    [_timArray removeAllObjects];
    _dataArray =[datArr mutableCopy];
    _timArray =[timArr mutableCopy];
    [self setNeedsDisplay];
}

@end
