

//
//  SixView.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/19.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "SixView.h"


@interface SixView (){


}
@property (nonatomic ) NSMutableArray *weaArray;
@property (nonatomic ) NSMutableArray *temArray;
@property (nonatomic ) NSMutableArray *timArray;
@property (nonatomic ) CGFloat preW;
@end
@implementation SixView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        _weaArray=[[NSMutableArray alloc]init];
        _temArray=[[NSMutableArray alloc]init];
        _timArray=[[NSMutableArray alloc]init];
        
        NSArray *falarr=@[@"20",@"10",@"10",@"10"];
        NSArray *arr=@[@"晴",@"晴",@"晴",@"晴"];
        NSArray *tim=@[@"0/0 00:00",@"0/0 00:00",@"0/0 00:00",@"0/0 00:00"];
        
        [_weaArray addObjectsFromArray:arr];
        [_timArray addObjectsFromArray:tim];
        [_temArray addObjectsFromArray:falarr];
        
    }
    return self;
}

- (void)setup {
    UIImageView *hBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    [hBg setContentMode:UIViewContentModeScaleToFill];
    [hBg setImage:[UIImage imageNamed:@"titBg"]];
    [self addSubview:hBg];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    label.text =@"6小时天气预报";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    [hBg addSubview:label];
    
    UIImageView *bBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 32, self.frame.size.width, self.frame.size.height-32)];
    [bBg setContentMode:UIViewContentModeScaleToFill];
    
    UIImage *image =[UIImage imageNamed:@"titBg"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [bBg setImage:image];
    [self addSubview:bBg];
    
}

- (void)drawRect:(CGRect)rect{
    
    [self setup];
    _preW=(self.frame.size.width-16)/_weaArray.count;
    

    for (int i=0; i<_weaArray.count; i++) {
        UIImageView *hBg=[[UIImageView alloc]initWithFrame:CGRectMake((8+_preW/4)+_preW*i, 50, _preW*1/2, _preW*1/2)];
        [hBg setContentMode:UIViewContentModeScaleToFill];
        [hBg setImage:[UIImage imageNamed:[self dayWeatherChangeImage:_weaArray[i]]]];
        [self addSubview:hBg];
        
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(8+_preW*i, 60+ _preW/2, _preW, 20)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.text =[NSString stringWithFormat:@"%@",[self WeatherWithStr:_weaArray[i]]];
        lab.font = [UIFont systemFontOfSize:13];
        lab.textColor=[UIColor whiteColor];
        [self addSubview:lab];
        
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(8+_preW*i, 82+ _preW*1/2, _preW, 20)];
        lab1.textAlignment=NSTextAlignmentCenter;
        lab1.text =[NSString stringWithFormat:@"%@℃",_temArray[i]];
        lab1.font = [UIFont systemFontOfSize:13];
        lab1.textColor=[UIColor whiteColor];
        [self addSubview:lab1];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(8+_preW*i, 104+ _preW*1/2, _preW, 20)];
        lab2.textAlignment=NSTextAlignmentCenter;
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd HH:00"];
        NSTimeInterval interval = 60 * 60 * [_timArray[i] integerValue];
        NSString *titleString = [dateFormatter stringFromDate:[[NSDate date] initWithTimeInterval:interval sinceDate:[NSDate date]]];
        
        lab2.text =[NSString stringWithFormat:@"%@",titleString];
        lab2.font = [UIFont systemFontOfSize:12];
        lab2.textColor=[UIColor whiteColor];
        [self addSubview:lab2];
    }
}

- (void)updateWithArr:(NSMutableArray *)datArr tim:(NSMutableArray *)timArr
                  tem:(NSMutableArray *)temArr{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_weaArray removeAllObjects];
    [_timArray removeAllObjects];
    [_temArray removeAllObjects];
    _weaArray =[datArr mutableCopy];
    _timArray =[timArr mutableCopy];
    _temArray =[temArr mutableCopy];
    [self setNeedsDisplay];
}

- (NSString *)dayWeatherChangeImage:(NSString *)weather{
    
    NSString *dayIconstr;
    NSInteger dayIcon=[weather integerValue];
    if (0==dayIcon){
        dayIconstr=@"d_qing";
    }
    else if (1==dayIcon){
        dayIconstr=@"d_duoyun";
    }
    else if (2==dayIcon){
        dayIconstr=@"d_yin";
        
    }
    else if (3==dayIcon){
        dayIconstr=@"d_zhenyu";
    }
    else if (4==dayIcon){
        dayIconstr=@"d_leizhenyu";
    }
    else if (5==dayIcon){
        dayIconstr=@"d_leizhengyubanyoubingbao";
    }
    else if (6==dayIcon){
        dayIconstr=@"d_yujiaxue";
    }
    else if (7==dayIcon){
        dayIconstr=@"d_xiaoyu";
    }
    else if (8==dayIcon){
        dayIconstr=@"d_zhongyu";
    }
    else if (9==dayIcon){
        dayIconstr=@"d_dayu";
    }
    else if (10==dayIcon){
        dayIconstr=@"d_baoyu";
    }
    else if (11==dayIcon){
        dayIconstr=@"d_dabaoyu";
    }
    else if (12==dayIcon){
        dayIconstr=@"d_tedabaoyu";
    }
    else if (13==dayIcon){
        dayIconstr=@"d_zhenxue";
    }
    else if (14==dayIcon){
        dayIconstr=@"d_xiaoxue";
    }
    else if (15==dayIcon){
        dayIconstr=@"d_zhongxue";
    }
    else if (16==dayIcon){
        dayIconstr=@"d_daxue";
    }
    else if (17==dayIcon){
        dayIconstr=@"d_baoxue";
    }
    else if (18==dayIcon){
        dayIconstr=@"d_wu";
    }
    else if (19==dayIcon){
        dayIconstr=@"d_dongyu";
    }
    else if (20==dayIcon){
        dayIconstr=@"d_shachenbao";
    }
    else if (21==dayIcon){
        dayIconstr=@"d_xiaoyu_zhongyu";
    }
    else if (22==dayIcon){
        dayIconstr=@"d_zhongyu_dayu";
    }
    else if (23==dayIcon){
        dayIconstr=@"d_dayu_baoyu";
    }
    else if (24==dayIcon){
        dayIconstr=@"d_baoyu_dabaoyu";
    }
    else if (25==dayIcon){
        dayIconstr=@"d_dabaoyu_tedabaoyu";
    }
    else if (26==dayIcon){
        dayIconstr=@"d_xiaoxue_zhongxue";
    }
    else if (27==dayIcon){
        dayIconstr=@"d_zhongxue_daxue";
    }
    else if (28==dayIcon){
        dayIconstr=@"d_daxue_baoxue";
    }
    else if (29==dayIcon){
        dayIconstr=@"d_fuchen";
    }
    else if (30==dayIcon){
        dayIconstr=@"d_yangsha";
    }
    else if (31==dayIcon){
        dayIconstr=@"d_qiangshachenbao";
    }
    
    else if (33==dayIcon){
        dayIconstr=@"d_zhongyu";
    }
    else if (33==dayIcon){
        dayIconstr=@"d_zhongxue";
    }
    else if (53==dayIcon){
        dayIconstr=@"d_mai";
    }
    else{
        dayIconstr=@"d_qing";
        
    }
    
    return dayIconstr;
}
- (NSString *)WeatherWithStr:(NSString *)weather{
    
    NSString *dayIconstr;
    NSInteger dayIcon=[weather integerValue];
    if (0==dayIcon){
        dayIconstr=@"晴";
    }
    else if (1==dayIcon){
        dayIconstr=@"多云";
    }
    else if (2==dayIcon){
        dayIconstr=@"阴";
        
    }
    else if (3==dayIcon){
        dayIconstr=@"阵雨";
    }
    else if (4==dayIcon){
        dayIconstr=@"雷阵雨";
    }
    else if (5==dayIcon){
        dayIconstr=@"冰雹";
    }
    else if (6==dayIcon){
        dayIconstr=@"雨夹雪";
    }
    else if (7==dayIcon){
        dayIconstr=@"小雨";
    }
    else if (8==dayIcon){
        dayIconstr=@"中雨";
    }
    else if (9==dayIcon){
        dayIconstr=@"大雨";
    }
    else if (10==dayIcon){
        dayIconstr=@"暴雨";
    }
    else if (11==dayIcon){
        dayIconstr=@"大暴雨";
    }
    else if (12==dayIcon){
        dayIconstr=@"特大暴雨";
    }
    else if (13==dayIcon){
        dayIconstr=@"阵雪";
    }
    else if (14==dayIcon){
        dayIconstr=@"小雪";
    }
    else if (15==dayIcon){
        dayIconstr=@"中雪";
    }
    else if (16==dayIcon){
        dayIconstr=@"大雪";
    }
    else if (17==dayIcon){
        dayIconstr=@"暴雪";
    }
    else if (18==dayIcon){
        dayIconstr=@"雾";
    }
    else if (19==dayIcon){
        dayIconstr=@"冻雨";
    }
    else if (20==dayIcon){
        dayIconstr=@"沙尘暴";
    }
    else if (21==dayIcon){
        dayIconstr=@"中雨";
    }
    else if (22==dayIcon){
        dayIconstr=@"大雨";
    }
    else if (23==dayIcon){
        dayIconstr=@"暴雨";
    }
    else if (24==dayIcon){
        dayIconstr=@"大暴雨";
    }
    else if (25==dayIcon){
        dayIconstr=@"特大暴雨";
    }
    else if (26==dayIcon){
        dayIconstr=@"中雪";
    }
    else if (27==dayIcon){
        dayIconstr=@"大雪";
    }
    else if (28==dayIcon){
        dayIconstr=@"暴雪";
    }
    else if (29==dayIcon){
        dayIconstr=@"浮尘";
    }
    else if (30==dayIcon){
        dayIconstr=@"扬沙";
    }
    else if (31==dayIcon){
        dayIconstr=@"强沙尘暴";
    }
    
    else if (33==dayIcon){
        dayIconstr=@"雨";
    }
    else if (33==dayIcon){
        dayIconstr=@"雪";
    }
    else if (53==dayIcon){
        dayIconstr=@"霾";
    }
    else{
        dayIconstr=@"晴";

    }
    return dayIconstr;
}

@end
