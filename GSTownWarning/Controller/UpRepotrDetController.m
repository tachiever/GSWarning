//
//  UpRepotrDetController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/30.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "UpRepotrDetController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>


#import "ScaneImage.h"


@interface UpRepotrDetController (){

    
}
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *timAndLoca;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic ) AVPlayerViewController * playerVc;
//@property (nonatomic ) AVPlayer * player;
@property (nonatomic ) UIView * maskVew;
@property (nonatomic ) ScaneImage * scaneView;
@property (nonatomic ) NSMutableArray *dataArr;

@end

@implementation UpRepotrDetController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArr=[[NSMutableArray alloc]init];
    
    [self createUI];
    [self createScaneView];
    
    [self createPlayer];


}
- (void)createScaneView{
    UpRepotrDetController *blockSelf = self;

    _scaneView =[[ScaneImage alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_scaneView];
    
    [_scaneView setHiddenView:^(){
        
        [blockSelf hiddenScanView];
    }];
    _scaneView.hidden=YES;

}

- (void)showScanView{

    self.scaneView.hidden=NO;
    [UIView animateWithDuration:0.3 animations:^{
        _scaneView.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];

}

- (void)hiddenScanView{
    
    [UIView animateWithDuration:0.3 animations:^{
        _scaneView.alpha=0.4;

    } completion:^(BOOL finished) {
        self.scaneView.hidden=YES;

    }];
}

- (void)createUI{
    CGFloat h=[NSString stringHight:_infDic[@"report_content"] font:15 width:SCREEN_WIDTH-60];
    CGFloat w=SCREEN_WIDTH/3-33.33333;
    _bgView.frame=CGRectMake(10, 74, SCREEN_WIDTH-20, 125+w+h);
    _bgView.layer.masksToBounds=NO;
    _bgView.layer.cornerRadius=4;
    _bgView.layer.shadowColor=[UIColor grayColor].CGColor;
    _bgView.layer.shadowOffset=CGSizeMake(0, 0);
    _bgView.layer.shadowOpacity=0.8;
    _bgView.layer.shadowRadius=4.f;
    [self.view addSubview:_bgView];
    
    
    
    _titLab.text=_infDic[@"report_type"];
    if ([_infDic[@"report_type"] isEqualToString:@"自然灾害"]) {
        [_iconImage setImage:[UIImage imageNamed:@"zrzh.png"]];
    }
    if ([_infDic[@"report_type"] isEqualToString:@"公共卫生事件"]) {
        [_iconImage setImage:[UIImage imageNamed:@"ggwssy.png"]];
    }
    if ([_infDic[@"report_type"] isEqualToString:@"安全事件"]) {
        [_iconImage setImage:[UIImage imageNamed:@"aqsy.png"]];
    }else{
        [_iconImage setImage:[UIImage imageNamed:@"sgzn.png"]];

    }

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20,64,SCREEN_WIDTH-60,h)];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.text =[NSString stringWithFormat:@"%@",_infDic[@"report_content"]];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor=[UIColor darkGrayColor];
    [_bgView addSubview:lab];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[_infDic[@"report_time"] doubleValue]/ 1000.0];
    NSString *titleString=[dateFormatter stringFromDate:date];
    _timAndLoca.text=[NSString stringWithFormat:@"时间:%@\n位置:%@",titleString,_infDic[@"jq_position"]];
    NSString *st=[NSString stringWithFormat:@"%@",_infDic[@"report_filepath"]];
    if (st.length>0) {
        NSArray  *array = [_infDic[@"report_filepath"] componentsSeparatedByString:@","];
        _dataArr=[array mutableCopy];
        for (int i=0; i<_dataArr.count; i++) {
            
            UIImageView *hBg=[[UIImageView alloc]initWithFrame:CGRectMake(22+(w+20)*i, 78+h, w, w)];
            [hBg setContentMode:UIViewContentModeScaleAspectFit];
            // hBg.backgroundColor=[UIColor blackColor];
             [hBg setImage:[UIImage imageNamed:@"vido.png"]];
            
            [_bgView addSubview:hBg];
            
            
            hBg.userInteractionEnabled = YES;//打开用户交互
            UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
            [hBg addGestureRecognizer:tapGesturRecognizer];
            
            if ([array[i] rangeOfString:@"jpg"].location !=NSNotFound||[array[i] rangeOfString:@"png"].location !=NSNotFound) {
                hBg.tag=i+10;
                
                [NBRequest requestWithURL:[NSString stringWithFormat:@"%@%@",URLHOST,array[i]] type:RequestNormal success:^(NSData *requestData) {
                    [hBg setImage:[UIImage imageWithData:requestData]];
                    
                } failed:^(NSError *error) {
                    
                }];
                // NSLog(@"%@",[NSString stringWithFormat:@"%@%@",URLHOST,array[i]]);
            }else{
                hBg.tag=i;
                
                [hBg setImage:[UIImage imageNamed:@"vido.png"]];
            }
        }
    }else{
            _bgView.frame=CGRectMake(10, 74, SCREEN_WIDTH-20, 125+h);
        
    }
  
}

- (void)createPlayer{
    
    _maskVew=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _maskVew.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_maskVew];
   // NSURL *remoteUrl = [NSURL URLWithString:@"http://gsqx.com:6081/dfecw/uploadfiles/si/1510190774454.mp4"];
   // AVPlayer *player = [AVPlayer playerWithURL:remoteUrl];

    _playerVc = [[AVPlayerViewController alloc] init];
   // _playerVc.player = player;
    self.playerVc.view.frame = CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70);
    [_maskVew addSubview:self.playerVc.view];
//    [self.playerVc.player play];
    
    UIButton * searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(5,20,50,50)];
    [searchBtn setTitle:@"X" forState:UIControlStateNormal];
    [searchBtn setTintColor:RGBCOLOR(222, 222, 222)];
    [searchBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    
    [_maskVew addSubview:searchBtn];
    
    
    _maskVew.hidden=YES;


}
- (void)hidden{
    [self.playerVc.player pause];
    _maskVew.hidden=YES;

}

-(void)singleTapAction:(UITapGestureRecognizer *)ges{
    
    if (ges.view.tag>9) {
        [NBRequest requestWithURL:[NSString stringWithFormat:@"%@%@",URLHOST,_dataArr[ges.view.tag-10]] type:RequestNormal success:^(NSData *requestData) {
            
            [_scaneView setWithImage:[UIImage imageWithData:requestData]];
            [self showScanView];

        } failed:^(NSError *error) {
            
        }];
    }else{
        _maskVew.hidden=NO;

         NSURL *remoteUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLHOST,_dataArr[ges.view.tag]]];
         AVPlayer *player = [AVPlayer playerWithURL:remoteUrl];
         _playerVc.player = player;
        [self.playerVc.player play];

    }
}





- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
