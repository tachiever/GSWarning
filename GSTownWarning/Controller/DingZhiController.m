//
//  DingZhiController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/10.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "DingZhiController.h"
#import "DingzhiView.h"

@interface DingZhiController ()<UITextFieldDelegate>{
    
    
}
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (nonatomic ) DingzhiView *diZhiView;
@property (nonatomic ) DingzhiView *resultView;
@property (nonatomic ) NSMutableArray *dataArray;
@end

@implementation DingZhiController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[[NSMutableArray alloc]init];
    
    [self createHeader];
    
    if ([self.type integerValue]==1) {
        _titLab.text=@"周边定制";
    }else{
        _titLab.text=@"站点定制";

    }
}

- (void)createHeader{
    UIButton * searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,40,30)];
    searchBtn.layer.masksToBounds=YES;
    searchBtn.layer.cornerRadius=4;
    [searchBtn setBackgroundColor:RGBCOLOR(193, 218, 249)];
    [searchBtn setImage:[UIImage imageNamed:@"searchBtn.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    _searchField.leftView = searchBtn;
    
    _searchField.delegate = self;
    _searchField.backgroundColor=RGBACOLOR(90, 90, 90, 0.6);
    [_searchField setValue:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_searchField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    _searchField.returnKeyType=UIReturnKeySearch;
    
    _diZhiView=[[DingzhiView alloc]initWithFrame:CGRectMake(0,156 , SCREEN_WIDTH, SCREEN_HEIGHT/2-110)];
    _diZhiView.backgroundColor=[UIColor whiteColor];
    _diZhiView.model=0;
    [_diZhiView updateWithArr:_pointArray];
    DingZhiController *blockSelf = self;
    [_diZhiView setActionCloseView:^(NSInteger ta) {
        if (ta!=0) {
            [blockSelf.pointArray removeObjectAtIndex:ta];
            [blockSelf.diZhiView updateWithArr:blockSelf.pointArray];
        }else{
            [SVProgressHUD showErrorWithStatus:@"默认站点不能删除！"];

        
        }

    }];
    [self.view addSubview:_diZhiView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT/2-110+156 , SCREEN_WIDTH, 20)];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.text =@"搜索结果";
    lab.font = [UIFont systemFontOfSize:15];
    lab.backgroundColor=RGBCOLOR(222, 222, 222);
    lab.textColor=[UIColor blackColor];
    [self.view addSubview:lab];
    
    
    _resultView=[[DingzhiView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT/2-110+20+156 , SCREEN_WIDTH, SCREEN_HEIGHT/2-66)];
    _resultView.backgroundColor=[UIColor whiteColor];
    _resultView.model=1;
    [_resultView updateWithArr:_dataArray];
    [_resultView setActionCloseView:^(NSInteger ta) {
        
        if (![blockSelf.pointArray containsObject:blockSelf.dataArray[ta]]) {
            [blockSelf.pointArray addObject:blockSelf.dataArray[ta]];
            [blockSelf.diZhiView updateWithArr:blockSelf.pointArray];
        }else{
            [SVProgressHUD showErrorWithStatus:@"该站点已添加！"];
        }
 
    
    }];
    [self.view addSubview:_resultView];
    
}



- (void)search{
    if (_searchField.text.length>0) {
        
        [_dataArray removeAllObjects];
        [self checkStat:_searchField.text];
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"搜索内容不能为空！"];
        
    }
}

- (void)checkStat:(NSString *)staName{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"sta" forKey:@"m"];
    [dict setObject:self.type forKey:@"type"];
    [dict setObject:staName forKey:@"keyWord"];
    
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
    
    [manger POST:CheckUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_dataArray removeAllObjects];
        NSLog(@"%@",dic);
        
        if ([dic[0][@"code"] floatValue]==20000) {
            for (NSDictionary *dicd in dic[1]) {
                if ([self.type integerValue]==1) {
                    [_dataArray addObject:dicd[@"county_name"]];

                }else{
                    [_dataArray addObject:dicd[@"Station_Name"]];
                }
            }
            [_resultView updateWithArr:_dataArray];
            
        }else{
            [SVProgressHUD showErrorWithStatus:dic[0][@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];

    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_searchField resignFirstResponder];
    
    [self search];
    
    return YES;
}

- (IBAction)back:(id)sender {
    if ([self.type integerValue]==1) {
        [[DataDefault shareInstance]setAroundArray:_pointArray];
    }else{
        [[DataDefault shareInstance]setPointArray:_pointArray];
        
    }
    
    if (self.actionSelectPoint) {
        self.actionSelectPoint(_pointArray);
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
