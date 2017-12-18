//
//  AtmBaikeController.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/9/11.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "AtmBaikeController.h"
#import "AtmoDetailController.h"
#import "AtmoSeverCell.h"

@interface AtmBaikeController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    
    NSInteger _project;
}
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (nonatomic ) NSMutableArray *dataArray;
@property (nonatomic ) NSMutableArray *dataArray0;

@property (nonatomic) BOOL isrefresh;

@property (nonatomic) CGFloat cellHigh;
@property (nonatomic) NSMutableDictionary *useDic;
@property (nonatomic) NSInteger page;

@end

@implementation AtmBaikeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _dataArray=[[NSMutableArray alloc]init];
    _dataArray0=[[NSMutableArray alloc]init];
    _useDic=[[NSMutableDictionary alloc]init];
    _project=1;
    _page=1;
    _isrefresh=YES;
    
    _cellHigh=100;
    [self createHeader];
    [self createTableView];
    [self downLoadData];
    
    
}

- (void)downLoadData{
    _useDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"baike" forKey:@"m"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    [dict setObject:@"10" forKey:@"size"];
        [dict setObject:[NSString timeStr] forKey:@"time"];
        [dict setObject:[[DataDefault shareInstance]userInfor][@"token"] forKey:@"token"];
        [dict setObject:[NSString signStrWithToken:[[DataDefault shareInstance]userInfor][@"token"] tim:[NSString timeStr]] forKey:@"sign"];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    [manger POST:QiXiangBK parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        if (_isrefresh) {
            [_dataArray removeAllObjects];
        }
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
       // NSLog(@"---%@",dic);
        if ([dic[0][@"code"] isEqualToString:@"20000"]) {
            NSArray *arr=dic[1];
            for (NSDictionary *dicti in arr) {
                [_dataArray addObject:dicti];
            }
            [_tableView reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了！"];
            
        }
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
    }];
}


- (void)downLoadSearchData:(NSString *)keyWord{
    _useDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"search" forKey:@"m"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    [dict setObject:@"10" forKey:@"size"];
    [dict setObject:keyWord forKey:@"keyword"];
    
        [dict setObject:[NSString timeStr] forKey:@"time"];
        [dict setObject:[[DataDefault shareInstance]userInfor][@"token"] forKey:@"token"];
        [dict setObject:[NSString signStrWithToken:[[DataDefault shareInstance]userInfor][@"token"] tim:[NSString timeStr]] forKey:@"sign"];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    [manger POST:QiXiangBK parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
      //asNSLog(@"---%@",dic);

        if ([dic[0][@"code"] isEqualToString:@"20000"]) {
            NSArray *arr=dic[1];
            for (NSDictionary *dicti in arr) {
                [_dataArray0 addObject:dicti];
            }
            [_tableView reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了！"];
            
        }
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
    }];
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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00080;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_project==0) {
        return _dataArray0.count;
        
    }
    if (_project==1) {
        return _dataArray.count;
        //return 30;
        
    }else   {
        return _dataArray.count;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AtmoDetailController *advc=[[AtmoDetailController alloc]init];
    if (_project==0) {
        advc.infDic=_dataArray0[indexPath.row];
        
    }else{
        advc.infDic=_dataArray[indexPath.row];
        
    }
    advc.kind=@"qixiang";
    [self.navigationController pushViewController:advc animated:YES];
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH*31/69, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH*31/69) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"AtmoSeverCell" bundle:nil] forCellReuseIdentifier:@"AtmoSeverCell"];//xib定制cell
    [_tableView addHeaderWithTarget:self action:@selector(loadNewData) dateKey:@"refresh"];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    [_tableView setFooterRefreshingText:@"正在加载..."];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AtmoSeverCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AtmoSeverCell"];
    cell.timLab.hidden=YES;
    if (_project==0) {
        [cell setBaiKeInf:_dataArray0[indexPath.row]];
        
    }else{
        [cell setBaiKeInf:_dataArray[indexPath.row]];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHigh;
}

- (void)loadNewData{
    _searchField.text=nil;
    _isrefresh=YES;
    _page=1;
    _project=1;
    
    [self downLoadData];
    
    
}
- (void)loadMoreData{
    _page++;
    _isrefresh=NO;
    
    if (_project==1) {
        [self downLoadData];
    }
    
    if (_project==0) {
        [self downLoadSearchData:_searchField.text];
    }
    
}
- (void)search{
    _project=0;
    _page=1;
    [_dataArray0 removeAllObjects];
    if (_searchField.text.length>0) {
        
        [self downLoadSearchData:_searchField.text];
        
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"搜索内容不能为空！"];
        
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    _project=0;
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_searchField resignFirstResponder];
    
    [self search];
    
    return YES;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
