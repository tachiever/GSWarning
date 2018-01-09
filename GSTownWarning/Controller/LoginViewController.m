//
//  LoginViewController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/9/28.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>{



}
@property (strong, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    [self createUI];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

}
- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}
- (void)createUI{
    CGFloat h;
    h=SCREEN_WIDTH>320?(SCREEN_WIDTH>375?64:56):50;
    UIImageView *hBg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-70*Rat, 70*Rat, 140*Rat, 145*Rat)];
    [hBg setContentMode:UIViewContentModeScaleToFill];
    [hBg setImage:[UIImage imageNamed:@"LOGO.png"]];
    [self.view addSubview:hBg];

    _countView.frame=CGRectMake(0, SCREEN_HEIGHT/2-80, SCREEN_WIDTH, 120);
    [self.view addSubview:_countView];
    
    _phoneField.delegate=self;
    [_phoneField setValue:[NSNumber numberWithInt:15] forKey:@"paddingLeft"];
    
    _passField.delegate=self;
    [_passField setValue:[NSNumber numberWithInt:15] forKey:@"paddingLeft"];
    
    UIButton * loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(40,SCREEN_HEIGHT/2+80,SCREEN_WIDTH-80,h)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"dl.png"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    if ([[DataDefault shareInstance]phoneAndPass]!=nil) {
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic=[[[DataDefault shareInstance]phoneAndPass] mutableCopy];
        _phoneField.text=dic[@"phone"];
        _passField.text=dic[@"pass"];
    }
    

}

- (void)login{
    
    if (_passField.text.length==0||_phoneField.text.length==0) {
        if (_passField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"密码错误"];
        }
        if (_phoneField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"账号错误"];
        }
    }else{
        
        [self login:_phoneField.text pass:_passField.text];
    }
}
- (void)login:(NSString *)phone pass:(NSString *)pass{
    //[SVProgressHUD showWithStatus:@"登录中..." ];
    [SVProgressHUD showWithStatus:@"登录中..."  maskType:SVProgressHUDMaskTypeGradient];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"login" forKey:@"m"];
    [dict setObject:phone forKey:@"phone"];
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"iostoken"];
    if (token.length>0) {
        [dict setObject:token forKey:@"iostoken"];
        // NSLog(@"token  %@",token);
    }
    [dict setObject:pass forKey:@"pass"];
    
//    [dict setObject:[NSString timeStr] forKey:@"time"];
//    [dict setObject:[[DataDefault shareInstance]userInfor][@"token"] forKey:@"token"];
//    [dict setObject:[NSString signStrWithToken:[[DataDefault shareInstance]userInfor][@"token"] tim:[NSString timeStr]] forKey:@"sign"];
//    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 20.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger POST:LoginUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       // NSLog(@"----%@",dic);
        if ([dic[0][@"code"] floatValue]==20000) {
            
            [[DataDefault shareInstance]setPhoneAndPass:dict];
            [[DataDefault shareInstance]setUserInfor:dic[1][0]];
            if (self.actionLoginSuccess) {
                self.actionLoginSuccess(dic[1][0]);
            }
            
            
            NSMutableArray *arr=[[NSMutableArray alloc]init];
            if ([[DataDefault shareInstance]pointArray]==nil) {
                [arr addObject:dic[1][0][@"county"]];
                [[DataDefault shareInstance]setPointArray:arr];
            }else{
                arr=[[[DataDefault shareInstance]pointArray] mutableCopy];
                [arr replaceObjectAtIndex:0 withObject:dic[1][0][@"county"]];
                [[DataDefault shareInstance]setPointArray:arr];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"登录成功！"];

        }else{
            [SVProgressHUD showErrorWithStatus:dic[0][@"msg"]];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"登录失败！"];
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_phoneField) {
        [_passField becomeFirstResponder];
    }else{
    
        [textField resignFirstResponder];

    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
