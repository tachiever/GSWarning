//
//  IconBtn.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/11.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "IconBtn.h"
@interface IconBtn (){

}

@end
@implementation IconBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        
        [self setup];
        
    }
    return self;
}

- (void)setup {
    
    _titLab= [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-14)];
    _titLab.font = [UIFont systemFontOfSize:14];
    _titLab.textColor=[UIColor blackColor];
    _titLab.backgroundColor=RGBCOLOR(245, 245, 245);
    _titLab.layer.masksToBounds=YES;
    _titLab.layer.cornerRadius=4;
    _titLab.layer.borderWidth=1;
    _titLab.textAlignment=NSTextAlignmentCenter;
    _titLab.layer.borderColor=RGBCOLOR(220, 220, 220).CGColor;
    [self addSubview:_titLab];
    
    _closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-18,2,16,16)];
    
    //[_closeBtn setImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];

   
    [_closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];

}

- (void)closeView{
    if (self.actionClose) {
        self.actionClose(self.tag);
    }
}

@end
