//
//  MoreWarnSViewController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/30.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "MoreWarnSViewController.h"
#import "YuJingDetail.h"
#import "YujingCell.h"

#import "DingZhiController.h"


@interface MoreWarnSViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray0;
    NSInteger _page;
    NSInteger _page0;
    BOOL _isFresh;
    BOOL _isAround;
    NSMutableArray *_readArray;

}
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titLab;


@property (nonatomic ) NSMutableArray *pointArray;

@end

@implementation MoreWarnSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isAround=NO;
    _page=1;
    _page0=1;
    _isFresh=NO;
    _dataArray0=[[NSMutableArray alloc]init];
    _dataArray=[[NSMutableArray alloc]init];
    _pointArray=[[NSMutableArray alloc]init];

    _readArray =[[NSMutableArray alloc]init];
    if ([[DataDefault shareInstance]readIdArr]!=nil) {
        _readArray=[[[DataDefault shareInstance]readIdArr] mutableCopy];
        
    }
    
    
    if ([[DataDefault shareInstance]aroundArray]==nil) {
        if ([[[[DataDefault shareInstance]userInfor] allKeys]  containsObject: @"county"]){
            [ _pointArray addObject:[[DataDefault shareInstance]userInfor][@"county"] ];
        }
        if ([[[[DataDefault shareInstance]userInfor] allKeys]  containsObject: @"cnty"]){
            [_pointArray addObject:[[DataDefault shareInstance]userInfor][@"cnty"]];
        }
        [[DataDefault shareInstance]setAroundArray:_pointArray];
    }else{
        _pointArray=[[[DataDefault shareInstance]aroundArray] mutableCopy];
    }
    
    [self createTableView];

    _dataArray =[[NSMutableArray alloc]init];
    _dataArray0 =[[NSMutableArray alloc]init];

    
    [self createTableView];
    //18139722829
    [self downLoadData:_userInf];


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
    
    if (!_isAround) {
        return [_dataArray count];
    }else{
        return [_dataArray0 count];
    }
    //return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YuJingDetail *yjdvc=[[YuJingDetail alloc]init];
    
    [yjdvc setReadInform:^{
        [_tableView reloadData];
    }];
    NSDictionary *dic;
    
    if (!_isAround) {
        dic= _dataArray[indexPath.row];
    }else{
        dic= _dataArray0[indexPath.row];
    }
    if (![_readArray containsObject: dic[@"ID"]]) {
        [_readArray addObject:dic[@"ID"]];
    }
    
    yjdvc.dic=dic;
    yjdvc.userDic=_userInf;
    [self.navigationController pushViewController:yjdvc animated:YES];
    
}




- (void)createTableView{
    _changeBtn.layer.borderWidth=1;
    _changeBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"YujingCell" bundle:nil] forCellReuseIdentifier:@"YujingCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(refresh)];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
    [_tableView setFooterRefreshingText:@"加载更多..."];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YujingCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YujingCell"];
    NSDictionary *dic;
    if (!_isAround) {
        dic= _dataArray[indexPath.row];
    }else{
        dic= _dataArray0[indexPath.row];
    }
    
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
    _isFresh=YES;
    if (!_isAround) {
        _page=1;
    }else{

        _page0=1;
    }
    [self downLoadData:_userInf];
}
- (void)loadMore{
    [self downLoadData:_userInf];
}


- (void)downLoadData:(NSMutableDictionary *)userInf{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"list" forKey:@"m"];
    if ([[userInf allKeys]  containsObject: @"cnty"]){
        [dict setObject:[NSString stringWithFormat:@"%@气象局",userInf[@"cnty"]] forKey:@"cnty"];
        
    }
    if ([[userInf allKeys]  containsObject: @"county"]){
        [dict setObject:[NSString stringWithFormat:@"%@气象局",userInf[@"county"]] forKey:@"cnty"];
        
    }
    
    if (_isAround) {
        NSMutableArray *pArr=[[NSMutableArray alloc]init];
        pArr=[_pointArray mutableCopy];
        [pArr removeObjectAtIndex:0];
        NSString *pathStr = [pArr componentsJoinedByString:@","];
        [dict setObject:pathStr forKey:@"staNam"];
        
        [dict setObject:[NSString stringWithFormat:@"%ld",(long)_page0] forKey:@"page"];
    }else{

        [dict setObject:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];

    }
    [dict setObject:@"10" forKey:@"size"];

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
        if (_isFresh) {
            if (!_isAround) {
                 [_dataArray removeAllObjects];
                
                _page=1;
            }else{
                 [_dataArray0 removeAllObjects];
                _page0=1;

            }
        }
        // NSLog(@"--%@",dic);
        if ([dic[0][@"code"] floatValue]==20000) {
            for (NSDictionary *dict in dic[1]) {
                
                if (!_isAround) {
                    [_dataArray addObject:dict];
                }else{
                    [_dataArray0 addObject:dict];
                }
            }
            if (!_isAround) {
                _page++;
            }else{
                _page0++;
            }
            _isFresh=NO;
        }else{
            [SVProgressHUD showErrorWithStatus:dic[0][@"msg"]];
        }
        [_tableView reloadData];

        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];

    }];
}






- (IBAction)changModel:(UIButton *)sender {
    if (!_isAround) {
        _isAround=YES;

        _titLab.text=@"周边预警";
        [_changeBtn setTitle:@"本地预警" forState:UIControlStateNormal];
        if (_dataArray0.count<1) {
            [self refresh];
        }
        
            [_tableView  reloadData];

        
        
        NSLog(@"zhoubian");
    }else{
        _isAround=NO;

        _titLab.text=@"本地预警";
        [_changeBtn setTitle:@"周边预警" forState:UIControlStateNormal];
        [_tableView  reloadData];
        
        NSLog(@"bengdi");
    }
}


- (IBAction)addPoint:(id)sender {
    
    DingZhiController *uvc=[[DingZhiController alloc]init];
    uvc.type=@"1";
    uvc.pointArray=[_pointArray mutableCopy];
    [uvc setActionSelectPoint:^(NSMutableArray *arr) {
        _pointArray=[arr mutableCopy];
        
        if (_pointArray.count==1) {
            [SVProgressHUD showErrorWithStatus:@"您未定制周边站点！"];
        }
        

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
