//
//  WeaAndPressView.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/18.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "WeaAndPressView.h"

@interface WeaAndPressView (){

    UIImageView *_weaIcon;
    UILabel *_weaLab;
    UIView *_pressView;
    UILabel *_valLab;
}

@end
@implementation WeaAndPressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        
        [self setup];
        
    }
    return self;
}

- (void)setup {
    _weaIcon=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-26)/2, 5, 26, 26)];
    [_weaIcon setContentMode:UIViewContentModeScaleToFill];
    [_weaIcon setImage:[UIImage imageNamed:@"d_qing.png"]];
    [self addSubview:_weaIcon];
    
    _weaLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width, 25)];
    _weaLab.textAlignment=NSTextAlignmentCenter;
    _weaLab.text =@"多云";
    _weaLab.font = [UIFont systemFontOfSize:12];
    _weaLab.textColor=[UIColor whiteColor];
    [self addSubview:_weaLab];
    
    _pressView=[[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-10)/2, self.frame.size.height-30-20, 10, 10)];
    _pressView.layer.masksToBounds=YES;
    _pressView.layer.cornerRadius=5;
    _pressView.backgroundColor=RGBACOLOR(244, 244, 244, 0.9);
    [self addSubview:_pressView];
    
    
    _valLab=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-35, self.frame.size.width, 20)];
   // _valLab.backgroundColor=[UIColor greenColor];
    _valLab.textAlignment=NSTextAlignmentCenter;
    _valLab.text =@"100.0";
    _valLab.font = [UIFont systemFontOfSize:12];
    _valLab.textColor=[UIColor whiteColor];
    [self addSubview:_valLab];
}


- (void)updateWithWeather:(NSString *)weather fall:(CGFloat )fall fallNum:(NSString *)fallnum{
    
    [_weaIcon setImage:[UIImage imageNamed:[self dayWeatherChangeImage:weather]]];
    [_weaLab setText:[self WeatherWithStr:weather]];
    [_valLab setText:[NSString stringWithFormat:@"%@",fallnum]];
    CGRect fra=CGRectMake((self.frame.size.width-10)/2, self.frame.size.height-50-(self.frame.size.height-110)*fall, 10, 10+((self.frame.size.height-110)*fall));
    
    [UIView animateWithDuration:0.5 animations:^{
        _pressView.frame=fra;
        
    }completion:^(BOOL finished) {
        
        
    }];
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
    return dayIconstr;
}
@end
