//
//  AtmoDetailController.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/8/8.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "AtmoDetailController.h"

@interface AtmoDetailController ()<UIScrollViewDelegate>{
    
    UIWebView *webView;
}
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (nonatomic)UIScrollView *scroll;

@end

@implementation AtmoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrellow];
    if ([self.kind isEqualToString:@"qixiang"]) {
        [self downLoadQiXiangData];

    }else{
        [self downLoadData];

    }
}

- (void)createScrellow{
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT-64)];
    [self.view addSubview:_scroll];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [_scroll addSubview:webView];
    _scroll.backgroundColor=[UIColor whiteColor];
    _scroll.contentSize = webView.frame.size;
    _scroll.showsVerticalScrollIndicator=NO;
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.delegate = self;
    _scroll.minimumZoomScale = 1;
    _scroll.maximumZoomScale = 5;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired=2;
    [_scroll addGestureRecognizer:tapGesture];
    
}

-(void)handleTapGesture:(UIGestureRecognizer*)sender{
    if(_scroll.zoomScale > 1.0){
        
        [_scroll setZoomScale:1.0 animated:YES];
    }else{
        [_scroll setZoomScale:5.0 animated:YES];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return webView;
}

- (void)downLoadQiXiangData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"details" forKey:@"m"];
    [dict setObject:self.infDic[@"id"] forKey:@"id"];
    
    
        [dict setObject:[NSString timeStr] forKey:@"time"];
        [dict setObject:[[DataDefault shareInstance]userInfor][@"token"] forKey:@"token"];
        [dict setObject:[NSString signStrWithToken:[[DataDefault shareInstance]userInfor][@"token"] tim:[NSString timeStr]] forKey:@"sign"];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    [manger POST:QiXiangBK parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[0][@"code"] isEqualToString:@"20000"]) {
            NSArray *arr=dic[1];
            [webView loadHTMLString:[NSString stringWithFormat:@"%@",arr[0][@"description"]] baseURL:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了！"];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
    }];
}

- (void)downLoadData{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"diteals" forKey:@"type"];
    [dict setObject:self.infDic[@"product_type"]forKey:@"product_type"];
    [dict setObject:self.infDic[@"id"] forKey:@"id"];
    if ([self.infDic[@"product_type"] isEqualToString:@"pdf"]) {
        [dict setObject:self.infDic[@"file_path"] forKey:@"file_path"];
        [dict setObject:self.infDic[@"title"] forKey:@"title"];
    }
    [dict setObject:[NSString timeStr] forKey:@"time"];
    [dict setObject:[[DataDefault shareInstance]userInfor][@"token"] forKey:@"token"];
    [dict setObject:[NSString signStrWithToken:[[DataDefault shareInstance]userInfor][@"token"] tim:[NSString timeStr]] forKey:@"sign"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    [manger POST:Service parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        if ([self.infDic[@"product_type"] isEqualToString:@"pdf"]) {
            [webView loadData:responseObject MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:nil];
            
        }else{
            
            [webView loadData:responseObject MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
    }];

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
