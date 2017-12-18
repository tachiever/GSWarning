//
//  ThrVIew.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/17.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "ThrVIew.h"
#import "CharView.h"
#import "ThrHoursView.h"


@interface ThrVIew ()<UIScrollViewDelegate>{
    UIScrollView *_scrollerView;
    CharView *temChar;
    ThrHoursView *weaView;
}

@end
@implementation ThrVIew

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        
        [self setup];
        
    }
    return self;
}

- (void)setup {
    UIImageView *hBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    [hBg setContentMode:UIViewContentModeScaleToFill];
    [hBg setImage:[UIImage imageNamed:@"titBg"]];
    [self addSubview:hBg];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    label.text =@"3小时预报";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    [hBg addSubview:label];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-210, 0, 200, 30)];
    lab.textAlignment=NSTextAlignmentRight;
    lab.text =@"温度:℃ 降水:mm";
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor=[UIColor whiteColor];
    [hBg addSubview:lab];
    
    UIImageView *bBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 32, self.frame.size.width, self.frame.size.height-32)];
    [bBg setContentMode:UIViewContentModeScaleToFill];
    
    UIImage *image =[UIImage imageNamed:@"titBg"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [bBg setImage:image];
    [self addSubview:bBg];
    
    
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 8, bBg.frame.size.width-16, bBg.frame.size.height-16)];
    _scrollerView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollerView.pagingEnabled = NO; //是否翻页
    _scrollerView.backgroundColor = [UIColor clearColor];
    _scrollerView.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    _scrollerView.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    _scrollerView.bounces = YES;
    _scrollerView.delegate = self;
    _scrollerView.contentSize = CGSizeMake(1000,0);
    [bBg addSubview:_scrollerView];
    bBg.userInteractionEnabled=YES;
    
    temChar=[[CharView alloc]initWithFrame:CGRectMake(0, 0, 1000, 90)];
    temChar.backgroundColor=[UIColor clearColor];
    [_scrollerView addSubview:temChar];
    
    weaView=[[ThrHoursView alloc]initWithFrame:CGRectMake(0, 100, 1000, self.frame.size.height-32-100)];
    weaView.backgroundColor=[UIColor clearColor];
    [_scrollerView addSubview:weaView];

    
}

- (void)updateWithTimarr:(NSMutableArray *)timArr Temarr:(NSMutableArray *)temArr Weaarr:(NSMutableArray *)weaArr Fallarr:(NSMutableArray *)fallArr{

    [temChar updateWithArr:temArr tim:timArr];
    [weaView updateWithWeaArr:weaArr fall:fallArr];

}


@end
