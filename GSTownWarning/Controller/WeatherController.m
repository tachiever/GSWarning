//
//  WeatherController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/17.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "WeatherController.h"

#import <CoreLocation/CoreLocation.h>

#import "ThrVIew.h"
#import "SixView.h"
#import "TwelveView.h"

@interface WeatherController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate>{
    
    NSString *_lat;
    NSString *_lon;
    NSString *_locationCity;
    NSString *_locationPro;
    NSMutableDictionary *_dataDic;
    
    
}
@property ( nonatomic)  UILabel *locaLab;
@property ( nonatomic)  UIImageView *locaImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *tempLab;
@property (weak, nonatomic) IBOutlet UILabel *fallLab;
@property (weak, nonatomic) IBOutlet UILabel *windLab;
@property (weak, nonatomic) IBOutlet UIImageView *weaImage;
@property (weak, nonatomic) IBOutlet UILabel *weaLab;

@property (nonatomic) ThrVIew *ThrView;
//@property (nonatomic) SixView *SixView;
@property (nonatomic) TwelveView *TweView;

@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic)BOOL isFin;

@property (nonatomic ) UIImage *bgImage;
@property (nonatomic ) UILabel *timeLab;

@end

@implementation WeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFin=NO;
    _dataDic=[[NSMutableDictionary alloc]init];
    
    _bgImage=[UIImage imageNamed:@"shense.png"];
    
    
    [self downLoadBgImage];

    [self createScrollerView];
    [self locate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openLoca) name:@"OpenLoca" object:nil];
    
    
    
}
- (void)openLoca{
    
    [self locate];
    
}

//#pragma mark ChangeBackground Image Alpha
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (_scrollView.contentOffset.y<SCREEN_HEIGHT&&_scrollView.contentOffset.y>0) {
//
//        _bgImageView.image=[UIImage boxblurImage:_bgImage withBlurNumber:_scrollView.contentOffset.y/SCREEN_HEIGHT];
//    }
//
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (_scrollView.contentOffset.y<SCREEN_HEIGHT&&_scrollView.contentOffset.y>0) {
//
//        //_bgImageView.image=[UIImage boxblurImage:_bgImage withBlurNumber:_scrollView.contentOffset.y/SCREEN_HEIGHT];
//    }
//}
//- (void)scrollsToBottomAnimated:(BOOL)animated{
//    CGFloat offset =_scrollView.contentSize.height - _scrollView.bounds.size.height;
//    if (offset > 0)
//    {
//       // [_scrollView setContentOffset:CGPointMake(0, offset) animated:animated];
//    }
//}

#pragma mark MainView
- (void)createScrollerView{
    CGFloat h0=SCREEN_HEIGHT>600?(SCREEN_HEIGHT>700?140:128):120;
    CGFloat h1=SCREEN_HEIGHT>600?(SCREEN_HEIGHT>700?94:38):114;
    _locaLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-115, 33, 100, 22)];
    _locaLab.textAlignment=NSTextAlignmentCenter;
    _locaLab.font=[UIFont systemFontOfSize:17];
    _locaLab.textColor=[UIColor whiteColor];
    _locaLab.text=@"当前位置：";
    [self.view addSubview:_locaLab];
    
    _locaImage=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-115-16-8, 33, 16, 22)];
    _locaImage.contentMode=UIViewContentModeScaleToFill;
    _locaImage.image=[UIImage imageNamed:@"loca.png"];
    [self.view addSubview:_locaImage];
    
    
    _scrollView.delegate=self;
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator=NO;
    //  _scrollView.contentInset=UIEdgeInsetsMake(0,0,0,0);
    _scrollView.contentSize = CGSizeMake(0, h0+h1+435);
    
    [_scrollView addHeaderWithTarget:self action:@selector(refresh)];
    [_scrollView setHeaderRefreshingText:@"正在刷新..."];
    
    
    
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110,10,80,26)];
    _timeLab.textAlignment=NSTextAlignmentCenter;
    _timeLab.layer.masksToBounds=YES;
    _timeLab.layer.cornerRadius=6;
    _timeLab.text=@"更新时间：";
    _timeLab.backgroundColor=RGBACOLOR(144, 144, 144, 0.5);
    _timeLab.font = [UIFont systemFontOfSize:13];
    _timeLab.textColor=[UIColor whiteColor];
    [_scrollView addSubview:_timeLab];
    
    
    _weatherView.frame=CGRectMake(0, h1, SCREEN_WIDTH, h0);
    _weatherView.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:_weatherView];
    
    _ThrView=[[ThrVIew alloc]initWithFrame:CGRectMake(0, h0+h1+5, SCREEN_WIDTH, 225)];
    _ThrView.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:_ThrView];
    
    
    _TweView=[[TwelveView alloc]initWithFrame:CGRectMake(0, h0+h1+235, SCREEN_WIDTH, 200)];
    _TweView.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:_TweView];
    
}



- (void)refresh{
    if (_lat.length>0) {
        [self getNearPointInform:_lat longtitude:_lon];
    }else{
        [self locate];
    }
    
    // [self getNearPointInform:@"36.069"longtitude:@"107.94"];
    
}

#pragma mark - Location
-(void)locate{
    if([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
            
            
            if (self.locationManager == nil) {
                self.locationManager = [[CLLocationManager alloc]init];
            }
            
            self.locationManager.delegate = self;
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法定位，请允许使用定位" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
              //  [self locate];
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
                
            }]];
            [self presentViewController:alert animated:true completion:nil];
            
        }
        
        
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法定位，请开启定位" preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];

           // [self locate];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
    
    [self.locationManager startUpdatingLocation];
}
#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    CLLocation *currentLocation = [locations lastObject];
        NSLog(@"当前经纬度%.1f,%.1f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    if (!_isFin) {

        //反编码
        [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count > 0) {
                CLPlacemark *placeMark = placemarks[0];
                
                
                //获取城市
                NSString *prov = placeMark.administrativeArea;
              //  NSString *city = placeMark.locality;
               // NSString *cnty = placeMark.subLocality;
                NSString *town = placeMark.thoroughfare;
                if (!prov) {
                    prov = nil;
                    prov = placeMark.locality;
                }
                [self setLocaText:town];
                //NSLog(@"%@",placeMark.administrativeArea); //这就是当前的城市
                
                //_locationCity=[NSString stringWithFormat:@"%@",city];
                //_locationCounty=[NSString stringWithFormat:@"%@",placeMark.subLocality];
                // _locationPro=[NSString stringWithFormat:@"%@",placeMark.administrativeArea];
                
                
                
                _lat=[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                _lon=[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                [self getNearPointInform:_lat longtitude:_lon];
                [self getSevenDayInform:_lat longtitude:_lon];

                
                _isFin=!_isFin;
            }
            else if (error == nil && placemarks.count == 0) {
                NSLog(@"No location and error return");
            }
            else if (error) {
                NSLog(@"location error: %@ ",error);
            }
            
        }];
    }
    
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

- (void)setLocaText:(NSString *)loca{
    CGFloat w=[NSString stringWidth:loca font:17]+8;
    _locaLab.text=[NSString stringWithFormat:@"%@",loca];
    _locaLab.frame=CGRectMake(SCREEN_WIDTH-w-15, 33, w, 22);
    _locaImage.frame=CGRectMake(SCREEN_WIDTH-w-15-8-16, 33, 16, 22);
    
}


- (void)getNearPointInform:(NSString *)lat longtitude:(NSString *)lon{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:lat forKey:@"lat"];
    [dict setObject:lon forKey:@"lng"];
    [dict setObject:@"hourdt" forKey:@"m"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger POST:Weather parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
       // NSLog(@"ssss%@",dict);
        if ([dict[0][@"code"] floatValue]==20000) {
            NSDictionary *defDic=dict[1][@"forecast_default"];
            // _dataDic=dict[1][0];
            //[self downLoadData];
            _tempLab.text=[NSString stringWithFormat:@"%@℃",defDic[@"temp"]];
            _windLab.text=[NSString stringWithFormat:@"%@",defDic[@"wind"]];
            _fallLab.text=[NSString stringWithFormat:@"湿度：%@%@",defDic[@"humidity"],@"%"];
            _weaLab.text=[NSString stringWithFormat:@"%@",defDic[@"weather"]];
            [_weaImage setImage:[UIImage imageNamed:[NSString weaIconWithWea:defDic[@"weather"]]]];
            _timeLab.text=[NSString stringWithFormat:@"更新时间：%@",defDic[@"time"]];
            _timeLab.frame= CGRectMake(SCREEN_WIDTH-[NSString stringWidth:_timeLab.text font:13]-30,10,[NSString stringWidth:_timeLab.text font:13]+10,26);

            NSArray *hourdata=dict[1][@"forecast_1h"];
            [self updateThridView:hourdata];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        }
        [_scrollView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_scrollView headerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];
    }];
}

- (void)getSevenDayInform:(NSString *)lat longtitude:(NSString *)lon{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:lat forKey:@"lat"];
    [dict setObject:lon forKey:@"lng"];
    [dict setObject:@"sevendt" forKey:@"m"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger POST:Weather parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
       // NSLog(@"ssss%@",dict);
        if ([dict[0][@"code"] floatValue]==20000) {
            NSMutableArray *temArr=[[NSMutableArray alloc]init];
            NSMutableArray *tem1Arr=[[NSMutableArray alloc]init];
            NSMutableArray *weaArr=[[NSMutableArray alloc]init];
            NSMutableArray *imaArr=[[NSMutableArray alloc]init];
            weaArr =dict[1][@"wea"];
            
            NSString *dStr =dict[1][@"dtemp"];
            NSString *nStr =dict[1][@"ntemp"];
            dStr = [dStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
            dStr = [dStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
            
            nStr = [nStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
            nStr = [nStr stringByReplacingOccurrencesOfString:@"]" withString:@""];

            [temArr addObjectsFromArray:[nStr componentsSeparatedByString:@","]];
            [tem1Arr addObjectsFromArray:[dStr componentsSeparatedByString:@","]];

            
            NSArray *dateArr=dict[1][@"data"];
            NSMutableArray *timeArr=[[NSMutableArray alloc]init];
            
            
            for (int i=0; i<8; i++) {
                
                NSString *ima=dict[1][@"weapic"][i];
                
                [imaArr addObject:[ima componentsSeparatedByString:@","][0]];
                [timeArr addObject:[NSString stringWithFormat:@"%@ %@",dateArr[i*2],dateArr[i*2+1]]];
            }

            [_TweView updateWithArr:weaArr tim:timeArr tem1:tem1Arr tem:temArr imageArr:imaArr];

        }else{
            [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        }
        [_scrollView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_scrollView headerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];
    }];
}



- (void)downLoadBgImage{
    int x = (arc4random() % 14)+1;
    NSLog(@"0s0s0%d",x);
    [NBRequest requestWithURL:[NSString stringWithFormat:BgImage,x] type:RequestNormal success:^(NSData *requestData) {
        _bgImage=[UIImage imageWithData:requestData];
        [_bgImageView setImage:_bgImage];
        [[DataDefault shareInstance]setBgImage:requestData];
    } failed:^(NSError *error) {

    }];
}


- (void)updateThridView:(NSArray *)arr{
    //NSLog(@"%@",arr);
    NSMutableArray *weaArr3=[[NSMutableArray alloc]init];
    NSMutableArray *timArr3=[[NSMutableArray alloc]init];
    NSMutableArray *temArr3=[[NSMutableArray alloc]init];
    NSMutableArray *fallArr3=[[NSMutableArray alloc]init];
    
    for (int i=0; i<arr.count; i++) {
        [weaArr3 addObject:arr[i][@"weather"] ];
        [timArr3 addObject:arr[i][@"time"] ];
        [temArr3 addObject:arr[i][@"temp"] ];
        [fallArr3 addObject:[NSString stringWithFormat:@"%@ %@",arr[i][@"windL"], arr[i][@"windD"] ]];
        
    }
    
    
    
    
    [_ThrView updateWithTimarr:timArr3 Temarr:temArr3 Weaarr:weaArr3 Fallarr:fallArr3];

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTime:(NSString *)tim{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[tim doubleValue]/ 1000.0];
    //NSString* dateString = [dateFormatter stringFromDate:date];
    
    
    NSTimeInterval interval = 60 * 60 * 8;
    NSString *titleString = [dateFormatter stringFromDate:[date initWithTimeInterval:interval sinceDate:date]];
    // NSLog(@"===%@",titleString);
    _timeLab.text=[NSString stringWithFormat:@"%@前更新",[self timelenth:titleString]];
    
    _timeLab.frame= CGRectMake(SCREEN_WIDTH-[NSString stringWidth:_timeLab.text font:13]-30,20,[NSString stringWidth:_timeLab.text font:13]+10,26);
}

- (NSString *)timelenth:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
    NSDate *date1 = [dateFormatter dateFromString:str];
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSinceDate:date1];
    NSString *dateContent;
    if ((int)time>3600) {
        int minutes = ((int)time)/3600;
        
        dateContent = [[NSString alloc] initWithFormat:@"%i小时",minutes];
        
    }else{
        int minutes = ((int)time)/60;
        
        dateContent = [[NSString alloc] initWithFormat:@"%i分钟",minutes];
        
    }
    
    return dateContent;
}

- (NSString *)windSpeed:(NSString *)dic{
    NSString *jb;
    NSInteger val=[dic integerValue];
    if (0.0 <= val && val <= 0.2) {
        jb = @"0级";
    } else if (0.3 <= val && val <= 1.5) {
        jb = @"1级";
    } else if (1.6 <= val && val <= 3.3) {
        jb = @"2级";
    } else if (3.4 <= val && val <= 5.4) {
        jb = @"3级";
    } else if (5.5 <= val && val <= 7.9) {
        jb = @"4级";
    } else if (8.0 <= val && val <= 10.7) {
        jb = @"5级";
    } else if (10.8 <= val && val <= 13.8) {
        jb = @"6级";
    } else if (13.9 <= val && val <= 17.1) {
        jb = @"7级";
    } else if (17.2 <= val && val <= 17.2) {
        jb = @"8级";
    } else if (20.8 <= val && val <= 24.4) {
        jb = @"9级";
    } else if (24.5<= val && val <= 28.4) {
        jb = @"10级";
    } else if (28.5<= val && val <= 32.6) {
        jb = @"11级";
    } else if (32.7<= val && val <= 36.9) {
        jb = @"12级";
    } else if (37.0 <= val && val <= 41.4) {
        jb = @"13级";
    } else if (41.5 <= val && val <= 46.1) {
        jb = @"14级";
    } else if (46.2 <= val && val <= 50.9) {
        jb = @"15级";
    } else if (51.0 <= val && val <= 56.0) {
        jb = @"16级";
    }else if (56.1<= val && val <= 61.2) {
        jb = @"17级";
    }else if(val>=61.3){
        jb = @"18级";
    }
    return jb;
}

- (NSString *)windDirection:(NSString *)dic{
    
	   NSString *WindDirection;
    NSInteger val=[dic integerValue];
	   if (0 == val) {
           WindDirection = @"北";
           //		   img_id=R.drawable.trend_wind_1;
       } else if (0 < val && val < 90) {
           WindDirection = @"东北";
           //	    	img_id=R.drawable.trend_wind_2;
       }  else if (90 == val) {
           WindDirection = @"东";
           //	    	img_id=R.drawable.trend_wind_3;
       } else if (90 < val && val <180) {
           WindDirection = @"东南";
           //	    	img_id=R.drawable.trend_wind_4;
       } else if (180 == val) {
           WindDirection = @"南";
           //	    	img_id=R.drawable.trend_wind_5;
       } else if (180 < val && val <270) {
           WindDirection = @"西南";
           //	    	img_id=R.drawable.trend_wind_6;
       } else if (270 == val) {
           WindDirection = @"西";
           //	    	img_id=R.drawable.trend_wind_7;
       } else if (270 < val && val <359.9) {
           WindDirection = @"西北";
           //	    	img_id=R.drawable.trend_wind_8;
       }  else {
           WindDirection = @"静";
           //	    	img_id=R.drawable.main_icon_wind_no;
       }
    return WindDirection;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

