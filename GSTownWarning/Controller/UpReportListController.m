//
//  UpReportListController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/30.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "UpReportListController.h"
#import "SpecialWeaCell.h"
#import "UpRepotrDetController.h"

#import "UpReportController.h"

@interface UpReportListController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSInteger _page;
    BOOL _isRefresh;
    
}
@property (nonatomic ) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;

@end

@implementation UpReportListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _dataArray=[[NSMutableArray alloc]init];
    _useDic=[[NSMutableDictionary alloc]init];
    _page=1;
    _isRefresh=YES;
    
    [self createTableView];
    [self downLoadData];
  //  [self loadNewData];
    
}

- (void)downLoadData{
    _useDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"reportlist" forKey:@"m"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    [dict setObject:@"10" forKey:@"size"];
    if ([[_useDic allKeys]  containsObject: @"county"]){
        [dict setObject:_useDic[@"county"]forKey:@"cnty"];
        
    }
    if ([[_useDic allKeys]  containsObject: @"cnty"]){
        [dict setObject:_useDic[@"cnty"]forKey:@"cnty"];
        
    }
    [dict setObject:_useDic[@"town"]forKey:@"town"];
    
    
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    [manger POST:WarnUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        if (_isRefresh) {
            [_dataArray removeAllObjects];
        }
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

//        NSLog(@"%@",dic);
        if ([dic[0][@"code"] floatValue]==20000) {
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
    
    return _dataArray.count;
    //return 30;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UpRepotrDetController *udvc=[[UpRepotrDetController alloc]init];
    udvc.infDic=_dataArray[indexPath.row];
    [self.navigationController pushViewController:udvc animated:YES];
    
}

- (void)createTableView{
    _upBtn.layer.borderWidth=1;
    _upBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerNib:[UINib nibWithNibName:@"SpecialWeaCell" bundle:nil] forCellReuseIdentifier:@"SpecialWeaCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(loadNewData) dateKey:@"refresh"];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    [_tableView setFooterRefreshingText:@"正在加载..."];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SpecialWeaCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SpecialWeaCell"];
    
    
     [cell setInf:_dataArray[indexPath.row]];
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h=SCREEN_WIDTH>330?180:150;
    return h;
}

- (void)loadNewData{
    _isRefresh=YES;
    _page=1;
    
    [self downLoadData];
    
    
}
- (void)loadMoreData{
    _page++;
    _isRefresh=NO;
    
    [self downLoadData];
    
    
}

- (IBAction)upInfor:(id)sender {
     UpReportController *uvc=[[UpReportController alloc]init];
    uvc.useDic=[_useDic mutableCopy];
    [uvc setActionUploadSuccess:^{
        [self loadNewData];
    }];
    
    [self.navigationController pushViewController:uvc animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
