//
//  MainPageController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/9/28.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "MainPageController.h"
#import "LoginViewController.h"
#import "YuJingDetail.h"

#import "UpReportController.h"
#import "PersonalController.h"
#import "FeedBackController.h"
#import "RealTimeController.h"
#import "WeatherController.h"

#import "YujingCell.h"
#import "SelectBtn.h"
#import "MoreWarnSViewController.h"
#import "AtmBaikeController.h"

#import "UpReportListController.h"


@interface MainPageController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;

    NSMutableArray *_dataArray;
    NSMutableArray *_readArray;
    
}
@property (strong, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (nonatomic ) NSMutableDictionary *useDic;

@end

@implementation MainPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    _dataArray =[[NSMutableArray alloc]init];
    _readArray =[[NSMutableArray alloc]init];
    if ([[DataDefault shareInstance]readIdArr]!=nil) {
        _readArray=[[[DataDefault shareInstance]readIdArr] mutableCopy];

    }

    [self createTableView];
    //18139722829

    LoginViewController *pvc=[[LoginViewController alloc]init];
    [pvc setActionLoginSuccess:^(NSMutableDictionary *useinf){
        _useDic=[useinf mutableCopy];
        [self downLoadData:useinf];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotice:) name:@"PushWarn" object:nil ];


    }];
    [self.navigationController pushViewController:pvc animated:YES];

}

- (void)getNotice:(NSNotification *)not{
    NSLog(@"ssss%@",not.userInfo);
    
  //  YuJingDetail *yjdvc=[[YuJingDetail alloc]init];
//
//    [yjdvc setReadInform:^{
//        [_tableView reloadData];
//    }];
//    NSDictionary *dic;
//
//    dic=not.userInfo;
//
//    if (![_readArray containsObject: dic[@"ID"]]) {
//        [_readArray addObject:dic[@"ID"]];
//    }
//
//    // NSLog(@"%@",_readArray);
//    yjdvc.dic=dic;
//    yjdvc.userDic=_useDic;
//    [self.navigationController pushViewController:yjdvc animated:YES];
    
    

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新的预警消息" message:@"是否查看？" preferredStyle:  UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {


    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YuJingDetail *yjdvc=[[YuJingDetail alloc]init];
        yjdvc.userDic=_useDic;
        yjdvc.detKin=@"push";
        yjdvc.detId=not.userInfo[@"warning_id"];
            [self.navigationController pushViewController:yjdvc animated:YES];


    }]];
    [self presentViewController:alert animated:true completion:nil];
    
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
            return [_dataArray count];

    
    //return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YuJingDetail *yjdvc=[[YuJingDetail alloc]init];
    
    [yjdvc setReadInform:^{
        [_tableView reloadData];
    }];
    NSDictionary *dic;

    dic= _dataArray[indexPath.row];
     //NSLog(@"%@",dic);

    if (![_readArray containsObject: dic[@"ID"]]) {
        [_readArray addObject:dic[@"ID"]];
    }
    
   // NSLog(@"%@",_readArray);
    yjdvc.detKin=@"check";

    yjdvc.dic=dic;
    yjdvc.userDic=_useDic;
    [self.navigationController pushViewController:yjdvc animated:YES];
    
}




- (void)createTableView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(8, 70,SCREEN_WIDTH-16 ,SCREEN_HEIGHT-((SCREEN_WIDTH-16)/25*3+16)-70-14)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.masksToBounds=NO;
    bgView.layer.cornerRadius=4;
    bgView.layer.shadowColor=[UIColor grayColor].CGColor;
    bgView.layer.shadowOffset=CGSizeMake(0, 0);
    bgView.layer.shadowOpacity=0.8;
    bgView.layer.shadowRadius=4.f;
    [self.view addSubview:bgView];
    
    
    UIView *bgView2=[[UIView alloc]initWithFrame:CGRectMake(8, SCREEN_HEIGHT-((SCREEN_WIDTH-16)/25*3+16)-8,SCREEN_WIDTH-16 , (SCREEN_WIDTH-16)/25*3+16)];
    bgView2.backgroundColor=[UIColor whiteColor];
    bgView2.layer.masksToBounds=NO;
    bgView2.layer.cornerRadius=4;
    bgView2.layer.shadowColor=[UIColor grayColor].CGColor;
    bgView2.layer.shadowOffset=CGSizeMake(0, 0);
    bgView2.layer.shadowOpacity=0.8;
    bgView2.layer.shadowRadius=4.f;
    [self.view addSubview:bgView2];
    
    
    _header.frame=CGRectMake(0, 0, SCREEN_WIDTH-16, 60);
    _header.layer.masksToBounds=NO;
    _header.layer.cornerRadius=4;
    [bgView addSubview:_header];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH-16, SCREEN_HEIGHT-((SCREEN_WIDTH-16)/25*3)-164) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    [bgView addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"YujingCell" bundle:nil] forCellReuseIdentifier:@"YujingCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(refresh)];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    
    NSArray *imageArr=@[@"tqyb2.png",@"skcx2.png",@"xxsc2.png",@"zhkp2.png",@"grzx2.png"];
    NSArray *nameArr=@[@"天气预报",@"实况查询",@"信息上报",@"灾害科普",@"个人中心"];
    for (int i=0; i<nameArr.count; i++) {
        SelectBtn *btn=[[SelectBtn alloc]initWithFrame:CGRectMake(0+((SCREEN_WIDTH-16)/5)*(i%5), 8, (SCREEN_WIDTH-16)/5, (SCREEN_WIDTH-16)/25*3)];
        [btn createWith:imageArr[i] name:nameArr[i]];
        btn.tag=i;
        
        
        [btn setSelectBtn:^(NSInteger tag) {
            [self selectFunction:tag];
        }];
        [bgView2 addSubview:btn];
    }
    

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YujingCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YujingCell"];
    NSDictionary *dic;

        dic= _dataArray[indexPath.row];
    
//    cell.detLab.text=dic[@"CONTENT"];
//    [cell setDateTime:dic[@"ENDTIME"]];
    if ([_readArray containsObject: dic[@"ID"]]) {

        [cell.statueImage setImage: [UIImage imageNamed:@"yd.png"]];
    }else{
        
        [cell.statueImage setImage: [UIImage imageNamed:@"wd.png"]];

    }
    [cell setInform:dic];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
//    cell.backgroundColor=[UIColor blueColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 121;
}

- (void)refresh{
    [self downLoadData:_useDic];
}


- (void)downLoadData:(NSMutableDictionary *)userInf{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"list" forKey:@"m"];
    if ([[userInf allKeys]  containsObject: @"cnty"]){
        [dict setObject:[NSString stringWithFormat:@"%@气象局",userInf[@"cnty"]] forKey:@"cnty"];
        _titLab.text=[NSString stringWithFormat:@"%@%@预警信息",userInf[@"cnty"],userInf[@"town"]];

    }
    if ([[userInf allKeys]  containsObject: @"county"]){
        [dict setObject:[NSString stringWithFormat:@"%@气象局",userInf[@"county"]] forKey:@"cnty"];
        _titLab.text=[NSString stringWithFormat:@"%@%@预警信息",userInf[@"county"],userInf[@"town"]];

    }
    [self loadData:dict];


}

- (void)loadData:(NSMutableDictionary *)dict{
    
   // NSLog(@"sss%@",dict[@"cnty"]);
    
    
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
        [_dataArray removeAllObjects];

       // NSLog(@"--%@",dic);
        if ([dic[0][@"code"] floatValue]==20000) {
            for (NSDictionary *dict in dic[1]) {
                [_dataArray addObject:dict];
            }
            [_tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[0][@"msg"]];
        }
        
        [_tableView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_tableView headerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];

    }];
}


- (IBAction)checkMore:(id)sender {
    
    MoreWarnSViewController *uvc=[[MoreWarnSViewController alloc]init];
    uvc.userInf=[_useDic mutableCopy];

    [self.navigationController pushViewController:uvc animated:YES];
}
- (void)selectFunction:(NSInteger )tag {
    //NSLog(@"%ld",(long)sender.tag);
    if (tag==0) {
        WeatherController *uvc=[[WeatherController alloc]init];
        
        [self.navigationController pushViewController:uvc animated:YES];
    }
    if (tag==1) {
        RealTimeController *uvc=[[RealTimeController alloc]init];
        
        [self.navigationController pushViewController:uvc animated:YES];
    }
    if (tag==2) {
       // UpReportController *uvc=[[UpReportController alloc]init];
        UpReportListController*uvc=[[UpReportListController alloc]init];
        uvc.useDic=[_useDic mutableCopy];
        [self.navigationController pushViewController:uvc animated:YES];
    
    }
    if (tag==3) {

        AtmBaikeController *uvc=[[AtmBaikeController alloc]init];
        
        [self.navigationController pushViewController:uvc animated:YES];
    }
    if (tag==4) {
        
        PersonalController *uvc=[[PersonalController alloc]init];
        [uvc setActionchangeSuccess:^(NSMutableDictionary *useInf) {
            [self downLoadData:useInf];
            
        }];
        
        [self.navigationController pushViewController:uvc animated:YES];
    }

    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [[DataDefault shareInstance]setReadIdArr:_readArray];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
