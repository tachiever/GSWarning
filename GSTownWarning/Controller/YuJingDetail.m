//
//  YuJingDetail.m
//  GSTownWarning
//
//  Created by Tcy on 2017/9/29.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "YuJingDetail.h"
#import <Social/Social.h>

@interface YuJingDetail (){
    
    CGFloat hAre;
    CGFloat hAllAre;
    CGFloat hSoulation;
    CGFloat hPerson;
    CGFloat W1;
    
    BOOL isAll;
    NSString *allAreStr;
    NSString *areStr;
}
@property ( nonatomic)  UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UIView *detView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *mAndDLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UIImageView *signImage;

@property (strong, nonatomic) IBOutlet UIView *footView;
@property (nonatomic )  UILabel *disLab;
@property (nonatomic )  UILabel *areLab;
@property (nonatomic )  UILabel *souLab;
@property (nonatomic )  UILabel *soulab;

@property (nonatomic )  UILabel *readerLab;
@property (nonatomic )  CGFloat dH;

@property(nonatomic,copy) UIActivityViewControllerCompletionHandler completionHandler;  // set to nil after call
typedef void (^UIActivityViewControllerCompletionHandler)(NSString *activityType, BOOL completed);
@end

@implementation YuJingDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    isAll=NO;
    if ([self.detKin isEqualToString:@"push"]) {
        [self downLoadPushDet];
    }else{
        self.detId=self.dic[@"ID"];
        [self updateUI];
       // NSLog(@"%@",self.dic);
        [self downLoadData:self.userDic];
    }

}

- (void)downLoadPushDet{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"wdetail" forKey:@"m"];
    [dict setObject:self.detId forKey:@"id"];
    //[dict setObject:@"62102741600000_20171012121803" forKey:@"id"];


    [dict setObject:[NSString timeStr] forKey:@"time"];
    [dict setObject:[[DataDefault shareInstance]userInfor][@"token"] forKey:@"token"];
    [dict setObject:[NSString signStrWithToken:[[DataDefault shareInstance]userInfor][@"token"] tim:[NSString timeStr]] forKey:@"sign"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    [manger POST:WarnUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
       // NSLog(@"%@",dic);
        if ([dic[0][@"code"] floatValue]==20000) {
            

            self.dic=dic[1][0];
            [self updateUI];
            // NSLog(@"%@",self.dic);
            [self downLoadData:self.userDic];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[0][@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];
    }];
}

- (void)downLoadData:(NSMutableDictionary *)userInf{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"con" forKey:@"m"];
    [dict setObject:userInf[@"city"] forKey:@"city"];
    if ([[userInf allKeys]  containsObject: @"cnty"]){
        [dict setObject:[NSString stringWithFormat:@"%@气象局",userInf[@"cnty"]] forKey:@"cnty"];
        
    }
    if ([[userInf allKeys]  containsObject: @"county"]){
        [dict setObject:[NSString stringWithFormat:@"%@气象局",userInf[@"county"]] forKey:@"cnty"];
    }
    [dict setObject:userInf[@"town"] forKey:@"town"];
    [dict setObject:_dic[@"ID"] forKey:@"usid"];
    [dict setObject:[NSString timeStr] forKey:@"time"];
    [dict setObject:userInf[@"phone"] forKey:@"phone"];
    [dict setObject:userInf[@"name"] forKey:@"name"];

    [self loadData:dict];
}

- (void)loadData:(NSMutableDictionary *)dict{
    [dict setObject:[NSString timeStr] forKey:@"time"];
    [dict setObject:[[DataDefault shareInstance]userInfor][@"token"] forKey:@"token"];
    [dict setObject:[NSString signStrWithToken:[[DataDefault shareInstance]userInfor][@"token"] tim:[NSString timeStr]] forKey:@"sign"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    
    [manger POST:WarnUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[0][@"code"] floatValue]==20000) {

            NSMutableArray *name=[[NSMutableArray alloc]init];
            
            for (NSDictionary *per in dic[1]) {
                [name addObject:per[@"reader_name"]];
            }
            NSString *nameStr =[NSString stringWithFormat:@"浏览者：%@", [name componentsJoinedByString:@"，"]];
            
            [self updateWith:nameStr];

            
        }else{
            [SVProgressHUD showErrorWithStatus:dic[0][@"msg"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];

    }];
    
}
- (void)updateWith:(NSString *)name{
    
  //  NSLog(@"sksksk%@",name);
    hPerson=[NSString stringHight:name font:15 width:SCREEN_WIDTH-56];
    _readerLab.frame=CGRectMake(28,464+_dH+hAre+hSoulation, SCREEN_WIDTH-56, hPerson);
    _readerLab.text=name;
    _scroller.contentSize=CGSizeMake(0, 484+_dH+hPerson+hAre+hSoulation);

}

- (void)updateUI{
    _scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT-64)];
    _scroller.backgroundColor=[UIColor whiteColor];
    _scroller.showsVerticalScrollIndicator=NO;
    _scroller.showsHorizontalScrollIndicator=NO;
    _scroller.bounces = YES; // 默认为YES 取消设置NO
    _scroller.directionalLockEnabled = YES; // 默认为NO，设置为YES内容视图只在一个方向上滚动
    _scroller.scrollEnabled = YES; // 默认为YES，设置NO不能滑动
    _detView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 259);
    [_scroller addSubview:_detView];
    [self.view addSubview:_scroller];

    
    allAreStr=[NSString stringWithFormat:@"%@",self.dic[@"AREANAME"]];
    
    NSArray  *array =[allAreStr componentsSeparatedByString:@","];
    NSMutableArray *steArr=[[NSMutableArray alloc]init];
    for (NSString *stre in array) {
        
        if([stre rangeOfString:@"村委会"].location ==NSNotFound)//_roaldSearchText
        {
            [steArr addObject:stre];
        }

    }
    areStr = [steArr componentsJoinedByString:@","];

    
    
    
    
    
    NSString *souStr;
    if ([[self.dic allKeys]  containsObject: @"MEASURES"]){
        souStr=[NSString stringWithFormat:@"%@",self.dic[@"MEASURES"]];
    }else{
        
        souStr=[NSString stringWithFormat:@"暂无发布"];
    }
    NSString *disStr=[NSString stringWithFormat:@"%@",self.dic[@"CONTENT"]];

    W1=[NSString stringWidth:@"预警内容:" font:15];
    
    hAre=[NSString stringHight:areStr font:14 width:SCREEN_WIDTH-56-W1-4];
    hAllAre=[NSString stringHight:allAreStr font:14 width:SCREEN_WIDTH-56-W1-4];
    
    hSoulation=[NSString stringHight:souStr font:14 width:SCREEN_WIDTH-56-W1-4];
    
    _dH=[NSString stringHight:disStr font:14 width:SCREEN_WIDTH-56-W1-4];
    
    UILabel *yjName = [[UILabel alloc] initWithFrame:CGRectMake(28,260,W1, 22)];
    yjName.textAlignment=NSTextAlignmentCenter;
    yjName.numberOfLines=0;
    yjName.text=@"预警内容:";
    yjName.font = [UIFont systemFontOfSize:15];
    yjName.textColor=[UIColor redColor];
    [_scroller addSubview:yjName];
    

    
    _disLab = [[UILabel alloc] initWithFrame:CGRectMake(28+W1+4,260, SCREEN_WIDTH-56-W1-4, _dH)];
    _disLab.textAlignment=NSTextAlignmentLeft;
    _disLab.numberOfLines=0;
    _disLab.text=disStr;
    _disLab.font = [UIFont systemFontOfSize:14];
    //_disLab.font=[UIFont fontWithName:@"System Light" size:15];

    _disLab.textColor=[UIColor blackColor];
    [_scroller addSubview:_disLab];
    

    
    
    UILabel *arLab = [[UILabel alloc] initWithFrame:CGRectMake(28,266+_dH, W1, 22)];
    arLab.textAlignment=NSTextAlignmentCenter;
    arLab.numberOfLines=0;
    arLab.text=@"预警范围:";
    arLab.font = [UIFont systemFontOfSize:15];
    arLab.textColor=[UIColor greenColor];
    [_scroller addSubview:arLab];
    
    
    _areLab = [[UILabel alloc] initWithFrame:CGRectMake(28+W1+4,268+_dH, SCREEN_WIDTH-56-W1-4, hAre)];
    _areLab.textAlignment=NSTextAlignmentLeft;
    _areLab.numberOfLines=0;
    _areLab.text=areStr;
    _areLab.font = [UIFont systemFontOfSize:14];
    //_areLab.font=[UIFont fontWithName:@"System Light" size:15];
    _areLab.userInteractionEnabled = YES;//打开用户交互
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAllAre:)];
    [_areLab addGestureRecognizer:tapGesturRecognizer];
    
    _areLab.textColor=[UIColor blackColor];
    [_scroller addSubview:_areLab];
    
    
    _soulab = [[UILabel alloc] initWithFrame:CGRectMake(28,274+_dH+hAre, W1, 22)];
    _soulab.textAlignment=NSTextAlignmentCenter;
    _soulab.numberOfLines=0;
    _soulab.text=@"预防措施:";
    _soulab.font = [UIFont systemFontOfSize:15];
    
    _soulab.textColor=[UIColor blueColor];
    [_scroller addSubview:_soulab];
    
    
    _souLab = [[UILabel alloc] initWithFrame:CGRectMake(28+W1+4,276+_dH+hAre, SCREEN_WIDTH-56-W1-4, hSoulation)];
    _souLab.textAlignment=NSTextAlignmentLeft;
    _souLab.numberOfLines=0;
    _souLab.text=souStr;
    _souLab.font = [UIFont systemFontOfSize:14];
    //_souLab.font=[UIFont fontWithName:@"System Light" size:15];

    _souLab.textColor=[UIColor blackColor];
    [_scroller addSubview:_souLab];
    
    
    _footView.frame=CGRectMake(0, 280+_dH+hAre+hSoulation, SCREEN_WIDTH, 164);
    [_scroller addSubview:_footView];
    
    
    _readerLab = [[UILabel alloc] initWithFrame:CGRectMake(28,464+_dH+hAre+hSoulation, SCREEN_WIDTH-56, 50)];
    _readerLab.textAlignment=NSTextAlignmentLeft;
    _readerLab.numberOfLines=0;
    _readerLab.text=@"浏览者：";
    _readerLab.font = [UIFont systemFontOfSize:15];
    _readerLab.textColor=[UIColor blackColor];
    [_scroller addSubview:_readerLab];
    
    
    
    _titLab.text=[NSString stringWithFormat:@"%@%@",self.dic[@"WARN_TYPE"],self.dic[@"WARN_LEVEL"]];
    [_iconImage setImage:[UIImage imageNamed:[self IconImageWithWeather:self.dic[@"WARN_TYPE"] lv:[self.dic[@"WARN_LEVEL"] substringToIndex:2]]]];
    if (self.dic[@"COUNT"]!=nil) {
        _countLab.text=[NSString stringWithFormat:@"浏览人数:%@",self.dic[@"COUNT"]];
    }else{
        _countLab.text=[NSString stringWithFormat:@"浏览人数:暂无统计"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    NSDate *dat=[NSDate dateWithTimeIntervalSince1970:[self.dic[@"PUB_TIME"] floatValue]/1000];
    NSString  *date=[dateFormatter stringFromDate:dat];
    _mAndDLab.text=[NSString stringWithFormat:@"%@",date];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    
    NSString  *time=[dateFormatter2 stringFromDate:dat];
    _timeLab.text=[NSString stringWithFormat:@"%@",time];
    
    if ([[self.dic[@"WARN_LEVEL"] substringToIndex:2] isEqualToString:@"红色"]) {
        [self.signImage setImage:[UIImage imageNamed:@"hs_det.png"]];
    }
    if ([[self.dic[@"WARN_LEVEL"] substringToIndex:2] isEqualToString:@"橙色"]) {
        [self.signImage setImage:[UIImage imageNamed:@"cs_det.png"]];
    }
    if ([[self.dic[@"WARN_LEVEL"] substringToIndex:2] isEqualToString:@"蓝色"]) {
        [self.signImage setImage:[UIImage imageNamed:@"ls_det.png"]];
    }
    if ([[self.dic[@"WARN_LEVEL"] substringToIndex:2] isEqualToString:@"黄色"]) {
        [self.signImage setImage:[UIImage imageNamed:@"hsd_det.png"]];
    }
    

}


- (void)showAllAre:(UITapGestureRecognizer *)ges{
    if (!isAll) {
        [UIView animateWithDuration:0.3 animations:^{
            
            _areLab.frame=CGRectMake(28+W1+4,268+_dH, SCREEN_WIDTH-56-W1-4, hAllAre);
            
            _soulab.frame=CGRectMake(28,274+_dH+hAllAre, W1, 22);
            _souLab.frame=CGRectMake(28+W1+4,276+_dH+hAllAre, SCREEN_WIDTH-56-W1-4, hSoulation);
            
            
            _footView.frame=CGRectMake(0, 280+_dH+hAllAre+hSoulation, SCREEN_WIDTH, 164);
            _readerLab.frame=CGRectMake(28,464+_dH+hAllAre+hSoulation, SCREEN_WIDTH-56, hPerson);

            _areLab.text=allAreStr;
            _scroller.contentSize=CGSizeMake(0, 484+_dH+hPerson+hAllAre+hSoulation);

        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            _areLab.frame=CGRectMake(28+W1+4,268+_dH, SCREEN_WIDTH-56-W1-4, hAre);

            _soulab.frame=CGRectMake(28,274+_dH+hAre, W1, 22);
            _souLab.frame=CGRectMake(28+W1+4,276+_dH+hAre, SCREEN_WIDTH-56-W1-4, hSoulation);
            
            
            _footView.frame=CGRectMake(0, 280+_dH+hAre+hSoulation, SCREEN_WIDTH, 164);
            _readerLab.frame=CGRectMake(28,464+_dH+hAre+hSoulation, SCREEN_WIDTH-56, hPerson);

            _scroller.contentSize=CGSizeMake(0, 484+_dH+hPerson+hAre+hSoulation);
        } completion:^(BOOL finished) {
            _areLab.text=areStr;

        }];

    }
    isAll=!isAll;
}
- (IBAction)share:(id)sender {
    
    NSString *textToShare = [NSString stringWithFormat:@"%@%@",self.dic[@"WARN_TYPE"],self.dic[@"WARN_LEVEL"]];
    //分享的图片
    UIImage *imageToShare = [UIImage imageNamed:@"LOGO.png"];

    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"http://gsqx.com:6081/dfecw/share.html?idsd_%@",self.detId]];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[urlToShare,imageToShare,textToShare];
    //NSArray *activityItems = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed) {
        
        NSLog(@"activityType :%@", activityType);
        
        if (completed)  {
            
            NSLog(@"completed");
        }
        else  {
            NSLog(@"cancel");
        }
        
        activityVC.completionHandler = myBlock;
    
    };
}
- (NSString *)IconImageWithWeather:(NSString *)wea lv:(NSString *)lv{
   // NSLog(@"---%@======%@",wea,lv);
    int w=0,l=0;
    NSArray *imagename=@[
  @[@"dafeng_cs.png",@"dafeng_hs.png",@"dafeng_huangse.png",@"dafeng_ls.png"],
  @[@"baoxue_cs.png",@"baoxue_hs.png",@"baoxue_huangse.png",@"baoxue_ls.png"],
  @[@"baoyu_cs.png",@"baoyu_hs.png",@"baoyu_huangse.png",@"baoyu_ls.png"],
  @[@"daolu_cs.png",@"daolu_hs.png",@"daolu_huangse.png",@"daolu_ls.png"],
  @[@"dawu_cs.png",@"dawu_hs.png",@"dawu_huangse.png",@"dawu_ls.png"],
  @[@"ganhan_cs.png",@"ganhan_hs.png",@"ganhan_huangse.png",@"ganhan_ls.png"],
  @[@"gaowen_cs.png",@"gaowen_hs.png",@"gaowen_huangse.png",@"gaowen_ls.png"],
  @[@"hanchao_cs.png",@"hanchao_hs.png",@"hanchao_huangse.png",@"hanchao_ls.png"],
  @[@"leidian_cs.png",@"leidian_hs.png",@"leidian_huangse.png",@"leidian_ls.png"],
  @[@"mai_cs.png",@"mai_hs.png",@"mai_huangse.png",@"mai_ls.png"],
  @[@"shachen_cs.png",@"shachen_hs.png",@"shachen_huangse.png",@"shachen_ls.png"],
  @[@"shuangdong_cs.png",@"shuangdong_hs.png",@"shuangdong_huangse.png",@"shuangdong_ls.png"],
  @[@"taifeng_cs.png",@"taifeng_hs.png",@"taifeng_huangse.png",@"taifeng_ls.png"],
  @[@"bingbao_cs.png",@"bingbao_hs.png",@"bingbao_huangse.png",@"bingbao_ls.png"]];
    
    if ([lv isEqualToString:@"红色"]) {
        l=1;
    }
    else if ([lv isEqualToString:@"橙色"]) {
        l=0;
    }
    else if ([lv isEqualToString:@"蓝色"]) {
        l=3;
    }
    else if ([lv isEqualToString:@"黄色"]) {
        l=2;
    }
    
    if ([wea isEqualToString:@"大风"]) {
        w=0;
    }
    else if ([wea isEqualToString:@"暴雨"]) {
        w=1;
    }
    else if ([wea isEqualToString:@"暴雪"]) {
        w=2;
    }
    else if ([wea isEqualToString:@"道路结冰"]) {
        w=3;
    }
    else if ([wea isEqualToString:@"大雾"]) {
        w=4;
    }
    else if ([wea isEqualToString:@"干旱"]) {
        w=5;
    }
    else if ([wea isEqualToString:@"高温"]) {
        w=6;
    }
    else if ([wea isEqualToString:@"寒潮"]) {
        w=7;
    }
    else if ([wea isEqualToString:@"雷电"]) {
        w=8;
    }
    else if ([wea isEqualToString:@"霾"]) {
        w=9;
    }
    else if ([wea isEqualToString:@"沙尘"]) {
        w=10;
    }
    else if ([wea isEqualToString:@"霜冻"]) {
        w=11;
    }
    else if ([wea isEqualToString:@"台风"]) {
        w=12;
    }
    else if ([wea isEqualToString:@"冰雹"]) {
        w=13;
    }
    
//    NSLog(@"---w=%d======l=%d",w,l);
//    NSLog(@"---===%@",imagename[w][l]);

    return imagename[w][l];
}
- (IBAction)back:(id)sender {
    if (self.readInform) {
        self.readInform();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
