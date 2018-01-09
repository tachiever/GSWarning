//
//  RealTimeController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/10.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "RealTimeController.h"
#import "DingZhiController.h"
#import "RealTimeCell.h"

@interface RealTimeController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate>{
    UITableView *_tableView;
    NSInteger Num;
    NSInteger kin,tag;
    CGFloat h1,h2,h3;
    
}
@property (nonatomic, strong) DateTimePickerView *datePickerView;

@property (nonatomic ) NSMutableArray *temArray;
@property (nonatomic ) NSMutableArray *temDZArray;
@property (nonatomic ) NSMutableArray *fallArray;
@property (nonatomic ) NSMutableArray *fallDZArray;

@property (nonatomic ) NSMutableArray *pointArray;

@property (weak, nonatomic) IBOutlet UIButton *temBtn;
@property (weak, nonatomic) IBOutlet UIButton *fallBtn;
@property (weak, nonatomic) IBOutlet UILabel *pointLab;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIView *temHeader;

@property (strong, nonatomic) IBOutlet UIView *fallHeader;
@property (strong, nonatomic) IBOutlet UIView *tenResul;
@property (strong, nonatomic) IBOutlet UIView *fallResul;
@property (weak, nonatomic) IBOutlet UIView *temBgView;
@property (weak, nonatomic) IBOutlet UIButton *temTime;

@property (weak, nonatomic) IBOutlet UIButton *fallBegin;
@property (weak, nonatomic) IBOutlet UIButton *fallEnd;

@property (nonatomic ) UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn1;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn2;


@end

@implementation RealTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _temArray=[[NSMutableArray alloc]init];
    _fallArray=[[NSMutableArray alloc]init];
    _temDZArray=[[NSMutableArray alloc]init];
    _fallDZArray=[[NSMutableArray alloc]init];
    _pointArray=[[NSMutableArray alloc]init];
    Num=0;
    kin=0;
    tag=0;
    h1= SCREEN_HEIGHT>600? 46:40;
    h2= SCREEN_HEIGHT>600? 15:13;
    h3= SCREEN_HEIGHT>600? 17:15;
    
    [self createTableView];
    
    if ([[DataDefault shareInstance]pointArray]==nil) {
        if ([[[[DataDefault shareInstance]userInfor] allKeys]  containsObject: @"county"]){
           [ _pointArray addObject:[[DataDefault shareInstance]userInfor][@"county"] ];
        }
        if ([[[[DataDefault shareInstance]userInfor] allKeys]  containsObject: @"cnty"]){
            [_pointArray addObject:[[DataDefault shareInstance]userInfor][@"cnty"]];
        }
        [[DataDefault shareInstance]setPointArray:_pointArray];
    }else{
        _pointArray=[[[DataDefault shareInstance]pointArray] mutableCopy];
    }
    
    [self updateUI];

    
}

- (void)updateUI{
    _fallBtn.backgroundColor=[UIColor clearColor];
    _fallBtn.layer.borderWidth=1;
    _fallBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    
    _tenResul.frame=CGRectMake(0, 168, SCREEN_WIDTH, 107);
    [self.view addSubview:_tenResul];
    
    _fallResul.frame=CGRectMake(0, 168, SCREEN_WIDTH, 107);
    [self.view addSubview:_fallResul];
    
    self.datePickerView = [[DateTimePickerView alloc] init];
    _datePickerView.delegate = self;
    _datePickerView.pickerViewMode = DatePickerViewDateTimeMode;
    [self.view addSubview:_datePickerView];
    
    if (kin==0) {
        _fallResul.hidden=YES;
    }else{
        _tenResul.hidden=YES;
        
    }
    
    _temBgView.layer.masksToBounds=NO;
    _temBgView.layer.cornerRadius=6;
    _temBgView.layer.shadowColor=[UIColor grayColor].CGColor;
    _temBgView.layer.shadowOffset=CGSizeMake(0, 2);
    _temBgView.layer.shadowOpacity=0.7;
    _temBgView.layer.shadowRadius=2.f;
    
    _fallBegin.layer.masksToBounds=NO;
    _fallBegin.layer.cornerRadius=4;
    _fallBegin.layer.shadowColor=[UIColor grayColor].CGColor;
    _fallBegin.layer.shadowOffset=CGSizeMake(0, 0);
    _fallBegin.layer.shadowOpacity=0.7;
    _fallBegin.layer.shadowRadius=2.f;
    
    _fallEnd.layer.masksToBounds=NO;
    _fallEnd.layer.cornerRadius=4;
    _fallEnd.layer.shadowColor=[UIColor grayColor].CGColor;
    _fallEnd.layer.shadowOffset=CGSizeMake(0, 0);
    _fallEnd.layer.shadowOpacity=0.7;
    _fallEnd.layer.shadowRadius=2.f;
    
    [_fallBegin.titleLabel setFont:[UIFont systemFontOfSize:h2]];
    [_fallEnd.titleLabel setFont:[UIFont systemFontOfSize:h2]];
    _pointLab.font=[UIFont systemFontOfSize:h3];
    
    _searchBtn1.layer.masksToBounds=NO;
    _searchBtn1.layer.cornerRadius=4;
    _searchBtn1.layer.shadowColor=[UIColor grayColor].CGColor;
    _searchBtn1.layer.shadowOffset=CGSizeMake(0, 2);
    _searchBtn1.layer.shadowOpacity=0.7;
    _searchBtn1.layer.shadowRadius=2.f;
    
    _searchBtn2.layer.masksToBounds=NO;
    _searchBtn2.layer.cornerRadius=4;
    _searchBtn2.layer.shadowColor=[UIColor grayColor].CGColor;
    _searchBtn2.layer.shadowOffset=CGSizeMake(0, 2);
    _searchBtn2.layer.shadowOpacity=0.7;
    _searchBtn2.layer.shadowRadius=2.f;
    
    CGFloat l1,l2,l3,l4;
    l1= SCREEN_HEIGHT>600? (SCREEN_HEIGHT>700? 240:200):160;
    l2= SCREEN_HEIGHT>600? (SCREEN_HEIGHT>700? 0:-40):-30;
    l3= SCREEN_HEIGHT>600? (SCREEN_HEIGHT>700? 155:135):113;
    l4= SCREEN_HEIGHT>600? (SCREEN_HEIGHT>700? -55:-50):-35;
    
    [_temTime setImageEdgeInsets:UIEdgeInsetsMake(0, l1, 0, 0)];
    [_temTime setTitleEdgeInsets:UIEdgeInsetsMake(0, l2, 0, 0)];

    [_fallBegin setImageEdgeInsets:UIEdgeInsetsMake(0,l3, 0, 0)];
    [_fallBegin setTitleEdgeInsets:UIEdgeInsetsMake(0, l4, 0, 0)];
    
    [_fallEnd setImageEdgeInsets:UIEdgeInsetsMake(0,l3, 0, 0)];
    [_fallEnd setTitleEdgeInsets:UIEdgeInsetsMake(0,l4, 0, 0)];
    if (_pointArray.count>1) {
        [_nextBtn setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    }else{
        [_nextBtn setImage:[UIImage imageNamed:@"right_un.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)pickTime:(UIButton *)sender {
    tag=sender.tag;
    [_datePickerView showDateTimePickerView];
    
}
#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    if (tag==1) {
        [_temTime setTitle:date forState:UIControlStateNormal];

    }
    if (tag==2) {
        [_fallBegin setTitle:date forState:UIControlStateNormal];
        
    }
    if (tag==3) {
        [_fallEnd setTitle:date forState:UIControlStateNormal];
        
    }
}

#pragma mark - 查询
- (IBAction)checkResult:(UIButton *)sender {
    if (sender.tag==1) {
        if (_temTime.titleLabel.text.length>0) {
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy/MM/dd HH:mm"];
            
            NSTimeInterval interval1;
            NSDate *beg=[dateFormatter2 dateFromString:_temTime.titleLabel.text];
            interval1 = [beg timeIntervalSince1970];
            NSTimeInterval interval2 = [[NSDate date] timeIntervalSince1970];
            if (interval2>=interval1) {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"rain_one" forKey:@"m"];
                [dict setObject:[NSString stringWithFormat:@"%.f",interval1*1000] forKey:@"staTime"];
                if (Num==0) {
                    [dict setObject:_pointArray[Num] forKey:@"cnty"];
                    NSLog(@"默认站点");
                    
                }else{
                    NSMutableArray *pArr=[[NSMutableArray alloc]init];
                    pArr=[_pointArray mutableCopy];
                    [pArr removeObjectAtIndex:0];
                    NSString *pathStr = [pArr componentsJoinedByString:@","];
                    [dict setObject:pathStr forKey:@"staNam"];
                    NSLog(@"定制站点");
                    
                }
                [self checkData:dict];
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"时间选择有误"];
            }
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:@"请选择时间!"];

        }
        
        NSLog(@"温度");

        
    }else{
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSDate *beg=[dateFormatter2 dateFromString:_fallBegin.titleLabel.text];
        NSDate *end=[dateFormatter2 dateFromString:_fallEnd.titleLabel.text];
        NSTimeInterval interval1 = [beg timeIntervalSince1970];
        NSTimeInterval interval2 = [end timeIntervalSince1970];
        if (interval2>interval1) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"rain_more" forKey:@"m"];
            [dict setObject:[NSString stringWithFormat:@"%.f",interval1*1000] forKey:@"starttime"];
            [dict setObject:[NSString stringWithFormat:@"%.f",interval2*1000] forKey:@"endtime"];
            if (Num==0) {
                [dict setObject:_pointArray[Num] forKey:@"cnty"];
                NSLog(@"默认站点");

            }else{
                NSMutableArray *pArr=[[NSMutableArray alloc]init];
                pArr=[_pointArray mutableCopy];
                [pArr removeObjectAtIndex:0];
                NSString *pathStr = [pArr componentsJoinedByString:@","];
                [dict setObject:pathStr forKey:@"staNam"];
                NSLog(@"定制站点");

            }
            [self checkData:dict];
        }else{
            [SVProgressHUD showErrorWithStatus:@"时间选择有误"];
        }
        NSLog(@"降水");

    }
}


#pragma mark - 请求数据
- (void)checkData:(NSMutableDictionary *)dict{
    
    
    //NSLog(@"%@",dict);
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
    
    //TemAndFall
    [manger POST:TemAndFall parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (kin==0) {
            if (Num==0) {
                [_temArray removeAllObjects];

            }else{
            
                [_temDZArray removeAllObjects];

            }
            
        }
        if (kin==1) {
            if (Num==0) {
                [_fallArray removeAllObjects];
                
            }else{
                
                [_fallDZArray removeAllObjects];
                
            }
            
        }
     //   NSLog(@"%@",dic);
        
        if ([dic[0][@"code"] floatValue]==20000) {
            if (kin==0) {
                
                if (Num==0) {
                    for (NSDictionary *dicd in dic[1]) {
                        [_temArray addObject:dicd];
                    }
                }else{
                    
                    for (NSDictionary *dicd in dic[1]) {
                        [_temDZArray addObject:dicd];
                    }
                }

            }
            if (kin==1) {
                
                if (Num==0) {
                    for (NSDictionary *dicd in dic[1]) {
                        [_fallArray addObject:dicd];
                    }
                }else{
                    
                    for (NSDictionary *dicd in dic[1]) {
                        [_fallDZArray addObject:dicd];
                    }
                }

            }

            [_tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[0][@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];

    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (kin==1) {
        _fallHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH-16, h1);
        _fallHeader.layer.masksToBounds=NO;
        _fallHeader.layer.cornerRadius=6;
        return _fallHeader;
        
    }else{
        _temHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH-16, h1);
        _temHeader.layer.masksToBounds=NO;
        _temHeader.layer.cornerRadius=6;
        return _temHeader;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return h1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (kin==0) {
            if (Num==0) {
                return [_temArray count];
                
            }else{
                
                return [_temDZArray count];
                
            }
        } else {
            if (Num==0) {
                return _fallArray.count;
                
            }else{
                
                return _fallDZArray.count;
                
            }
        }
    
    //return 20;
}

- (void)createTableView{
    
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(8, 278, SCREEN_WIDTH-16, SCREEN_HEIGHT-286)];
    _bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bgView];
    _bgView.layer.masksToBounds=NO;
    _bgView.layer.cornerRadius=6;
    _bgView.layer.shadowColor=[UIColor grayColor].CGColor;
    _bgView.layer.shadowOffset=CGSizeMake(0, 2);
    _bgView.layer.shadowOpacity=0.8;
    _bgView.layer.shadowRadius=4.f;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 278, SCREEN_WIDTH-16, SCREEN_HEIGHT-286) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RealTimeCell" bundle:nil] forCellReuseIdentifier:@"RealTimeCell"];//xib定制cell
    _tableView.layer.masksToBounds=YES;
    _tableView.layer.cornerRadius=6;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RealTimeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RealTimeCell"];
    
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"MM/dd HH"];
    

    if (kin==0) {
        
        if (Num==0) {
            cell.nameLan.text=_temArray[indexPath.row][@"Station_Name"];
            cell.couLab.text=[_temArray[indexPath.row][@"TEM"] stringByAppendingString:@"℃"];
            NSDate *dat=[NSDate dateWithTimeIntervalSince1970:[_temArray[indexPath.row][@"Datetime"] floatValue]/1000.0];
            dat=[dat dateByAddingTimeInterval:8*3600+60];
            
            NSString *timeString = [formate stringFromDate:dat];
            
            cell.numLab.text=timeString;

        }else{
            
            cell.nameLan.text=_temDZArray[indexPath.row][@"Station_Name"];
            cell.couLab.text=[_temDZArray[indexPath.row][@"TEM"] stringByAppendingString:@"℃"];
            NSDate *dat=[NSDate dateWithTimeIntervalSince1970:[_temDZArray[indexPath.row][@"Datetime"] floatValue]/1000.0];
            dat=[dat dateByAddingTimeInterval:8*3600+60];
            
            NSString *timeString = [formate stringFromDate:dat];
            
            cell.numLab.text=timeString;

        }

        
    }
    if (kin==1) {
       // NSLog(@"======e=e=%@",_fallArray[indexPath.row]);
        cell.numLab.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];

        if (Num==0) {
            cell.nameLan.text=_fallArray[indexPath.row][@"s_name"];
            cell.couLab.text=[NSString stringWithFormat:@"%@mm",_fallArray[indexPath.row][@"rain"]];


        }else{
            
            cell.nameLan.text=_fallDZArray[indexPath.row][@"s_name"];
            cell.couLab.text=[NSString stringWithFormat:@"%@mm",_fallDZArray[indexPath.row][@"rain"]];


        }

    }
    if (indexPath.row%2==1) {
        cell.backgroundColor=RGBCOLOR(222, 222, 222);
    }else{
        
        cell.backgroundColor=[UIColor whiteColor];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return h1;
}



#pragma mark - 切换温度与降水
- (IBAction)chooseKind:(UIButton *)sender {
    if (sender.tag==0) {
        _fallBtn.backgroundColor=[UIColor clearColor];
        _fallBtn.layer.borderWidth=1;
        _fallBtn.layer.borderColor=[UIColor whiteColor].CGColor;
        _temBtn.backgroundColor=RGBCOLOR(255, 214, 0);
        _temBtn.layer.borderColor=[UIColor clearColor].CGColor;
        kin=0;
        _fallResul.hidden=YES;
        _tenResul.hidden=NO;
        
        [_tableView reloadData];
        
    }else{
        
        _temBtn.backgroundColor=[UIColor clearColor];
        _temBtn.layer.borderWidth=1;
        _temBtn.layer.borderColor=[UIColor whiteColor].CGColor;
        _fallBtn.backgroundColor=RGBCOLOR(255, 214, 0);
        _fallBtn.layer.borderColor=[UIColor clearColor].CGColor;
        kin=1;
        _tenResul.hidden=YES;
        _fallResul.hidden=NO;
        [_tableView reloadData];
    }
}

- (IBAction)choosePoint:(UIButton *)sender {
    if (sender.tag==0) {
        if (Num==1) {
            Num=0;
            _pointLab.text=@"默认站点";
            [_upBtn setImage:[UIImage imageNamed:@"left_un.png"] forState:UIControlStateNormal];
            
            if (_pointArray.count>1) {
                [_nextBtn setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
            }else{
                [_nextBtn setImage:[UIImage imageNamed:@"right_un.png"] forState:UIControlStateNormal];
            }
            [_tableView reloadData];
        }
    }else{
        if (_pointArray.count>1) {
            if (Num==0) {
                Num=1;
                _pointLab.text=@"定制站点";
                [_nextBtn setImage:[UIImage imageNamed:@"right_un.png"] forState:UIControlStateNormal];
                [_upBtn setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
            }
            [_tableView reloadData];

        }else{
            [SVProgressHUD showErrorWithStatus:@"没有定制站点！"];
        }
    }
}
- (IBAction)addPoint:(id)sender {
    DingZhiController *uvc=[[DingZhiController alloc]init];
    uvc.type=@"2";
    uvc.pointArray=[_pointArray mutableCopy];
    [uvc setActionSelectPoint:^(NSMutableArray *arr) {
        _pointArray=[arr mutableCopy];
        
        Num=0;
        [_upBtn setImage:[UIImage imageNamed:@"left_un.png"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        _pointLab.text=@"默认站点";
        
    }];
    [self.navigationController pushViewController:uvc animated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
