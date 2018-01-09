//
//  SelectBtn.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/30.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "SelectBtn.h"

@implementation SelectBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    self.layer.masksToBounds=NO;
//    self.layer.cornerRadius=4;
//    self.backgroundColor=RGBCOLOR(244, 236, 217);
//    self.layer.borderWidth=1;
//    self.layer.borderColor=[UIColor orangeColor].CGColor;
    return self;
}

- (void)createWith:(NSString *)ImageName name:(NSString *)name{
    
    UIButton * searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2-self.frame.size.height/4,4,self.frame.size.height/2,self.frame.size.height/2)];
    [searchBtn setImage:[UIImage imageNamed:ImageName] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchBtn];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height/2+4,self.frame.size.width,self.frame.size.height/2-4)];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.text =name;
    if (SCREEN_WIDTH>380) {
        lab.font = [UIFont systemFontOfSize:15];

    }if (SCREEN_WIDTH<380&&SCREEN_WIDTH>330){
        lab.font = [UIFont systemFontOfSize:14];
        
        
    }if (SCREEN_WIDTH<330){
        lab.font = [UIFont systemFontOfSize:13];
        
        
    }
    lab.textColor=[UIColor darkGrayColor];
    [self addSubview:lab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(search)];
    
    tap.numberOfTapsRequired = 1;
 
    [self addGestureRecognizer:tap];


}

- (void)search{
    if (self.selectBtn) {
        self.selectBtn(self.tag);
    }

}

@end
