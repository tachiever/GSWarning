//
//  PersonalController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/9/28.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "PersonalController.h"

@interface PersonalController ()<UITextFieldDelegate>{
    
    BOOL isEdit;
    BOOL isChange;
    NSMutableDictionary *userDic;
}

@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (nonatomic )  UIScrollView *scrlloView;
@property (strong, nonatomic) IBOutlet UIView *detView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *fax;
@property (weak, nonatomic) IBOutlet UITextField *unity;
@property (weak, nonatomic) IBOutlet UITextField *post;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *county;
@property (weak, nonatomic) IBOutlet UITextField *town;
@property (weak, nonatomic) IBOutlet UITextField *other;

@property (strong, nonatomic) IBOutlet UIView *passChangeView;
@property (weak, nonatomic) IBOutlet UITextField *oldPass;
@property (weak, nonatomic) IBOutlet UITextField *nePas
;

@property (nonatomic ) UIView *maskView;

@end

@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self stup];
    [self createMaskView];
    
}

- (void)stup{
    isChange=NO;
    _scrlloView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 204, SCREEN_WIDTH, SCREEN_HEIGHT-204)];
    _scrlloView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrlloView.pagingEnabled = NO; //是否翻页
    _scrlloView.bounces=YES;
    _scrlloView.backgroundColor = [UIColor clearColor];
    _scrlloView.showsHorizontalScrollIndicator=NO;
    _scrlloView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scrlloView];
    _scrlloView.contentSize=CGSizeMake(0, 560);
    
    _detView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 560);
    [_scrlloView addSubview:_detView];
    userDic=[[NSMutableDictionary alloc]init];
    userDic=[[[DataDefault shareInstance]userInfor] mutableCopy];
    
    _name.delegate=self;
    _fax.delegate=self;
    _unity.delegate=self;
    _post.delegate=self;
    _city.delegate=self;
    _county.delegate=self;
    _town.delegate=self;
    _other.delegate=self;
    
    if ([[userDic allKeys]  containsObject: @"name"]){
        _name.text=userDic[@"name"];
        
    }
    if ([[userDic allKeys]  containsObject: @"phone"]){
        _countLab.text=userDic[@"phone"];
        
    }
    if ([[userDic allKeys]  containsObject: @"fax_number"]){
        _fax.text=userDic[@"fax_number"];
        
    }
    if ([[userDic allKeys]  containsObject: @"work_unit"]){
        _unity.text=userDic[@"work_unit"];
        
    }
    if ([[userDic allKeys]  containsObject: @"post"]){
        _post.text=userDic[@"post"];
        
    }
    if ([[userDic allKeys]  containsObject: @"city"]){
        _city.text=userDic[@"city"];
        
    }
    if ([[userDic allKeys]  containsObject: @"county"]){
        _county.text=userDic[@"county"];
        
    }
    if ([[userDic allKeys]  containsObject: @"cnty"]){
        _county.text=userDic[@"cnty"];
        
    }
    if ([[userDic allKeys]  containsObject: @"town"]){
        _town.text=userDic[@"town"];
        
    }  if ([[userDic allKeys]  containsObject: @"other"]){
        _other.text=userDic[@"other"];
        
    }
    
    if ([userDic[@"data_type"] floatValue]==2) {
        _name.enabled=NO;
        _fax.enabled=NO;
        _unity.enabled=NO;
        _post.enabled=NO;
        _city.enabled=NO;
        _county.enabled=NO;
        _town.enabled=NO;
        _other.enabled=NO;
        isEdit=NO;
    }else{
        
        isEdit=YES;
    }
}

- (void)createMaskView{
    
    CGFloat h=SCREEN_WIDTH>321?(SCREEN_WIDTH>376?0:50):70;
    
    _maskView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-0)];
    _maskView.backgroundColor=RGBACOLOR(44, 44, 44, 0.5);
    [self.view addSubview:_maskView];
    
    _passChangeView.frame=CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH*3/8-h, SCREEN_WIDTH, SCREEN_WIDTH*3/4);
    
    [_maskView addSubview:_passChangeView];
    _oldPass.delegate=self;
    _nePas.delegate=self;
    
    _maskView.hidden=YES;
    
}


- (IBAction)changePass:(id)sender {
    
    if (isEdit) {
        [_oldPass becomeFirstResponder];
        _maskView.hidden=NO;
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"本类型用户不支持修改个人信息！"];
    }
}
- (IBAction)change:(UIButton *)sender {
    [_oldPass resignFirstResponder];
    [_nePas resignFirstResponder];
    if (sender.tag==0) {
        _maskView.hidden=YES;
    }else{
        if (_oldPass.text.length==0||_nePas.text.length==0) {
            if (_oldPass.text.length==0) {
                [SVProgressHUD showErrorWithStatus:@"密码错误"];
            }
            if (_nePas.text.length==0) {
                [SVProgressHUD showErrorWithStatus:@"新密码不能为空！"];
            }
        }else{
            
            [self changePass:_oldPass.text pass:_nePas.text];
        }
        
    }
}


- (void)changePass:(NSString *)oldPass pass:(NSString *)pass{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"uppass" forKey:@"m"];
    [dict setObject:oldPass forKey:@"oldpass"];
    [dict setObject:pass forKey:@"pass"];
    [dict setObject:userDic[@"ids"] forKey:@"ids"];
    
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
    
    [manger POST:LoginUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",dic);
        
        if ([dic[0][@"code"] floatValue]==20000) {
            NSMutableDictionary *diction=[[NSMutableDictionary alloc]init];
            [diction setObject:pass forKey:@"pass"];
            [diction setObject:userDic[@"phone"] forKey:@"phone"];
            [[DataDefault shareInstance]setPhoneAndPass:diction];
            _maskView.hidden=YES;
            _oldPass.text=nil;
            _nePas.text=nil;
            [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[0][@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"修改失败！"];

    }];
}
- (void)changePersonInform:(NSMutableDictionary *)dict{
    NSMutableDictionary *diction=[[NSMutableDictionary alloc]init];
    diction=[dict mutableCopy];
    [diction setValue:userDic[@"phone"] forKey:@"phone"];
    
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
    
    [manger POST:LoginUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        if ([dic[0][@"code"] floatValue]==20000) {
            
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
            [diction setObject:[[DataDefault shareInstance]userInfor][@"token"] forKey:@"token"];
            

            NSMutableArray *arr=[[NSMutableArray alloc]init];
            if ([[DataDefault shareInstance]pointArray]==nil) {
                [arr addObject:diction[@"cnty"]];
                [[DataDefault shareInstance]setPointArray:arr];
            }else{
                arr=[[[DataDefault shareInstance]pointArray] mutableCopy];
                [arr replaceObjectAtIndex:0 withObject:diction[@"cnty"]];
                [[DataDefault shareInstance]setPointArray:arr];
            }
            [[DataDefault shareInstance]setUserInfor:diction];
            if (self.actionchangeSuccess) {
                self.actionchangeSuccess(diction);
            }
            [self.navigationController popViewControllerAnimated:YES];
           // NSLog(@"----%@",[[DataDefault shareInstance]userInfor]);

        }else{
            [SVProgressHUD showErrorWithStatus:dic[0][@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];

    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_oldPass||textField==_nePas) {
        
        
    }else{
        CGFloat h=SCREEN_WIDTH>321?(SCREEN_WIDTH>376?271:258):253;
        [UIView animateWithDuration:0.3 animations:^{
            _scrlloView.frame=CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20-h);
        }];
        isChange=YES;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_oldPass||textField==_nePas) {
        
    }
    
    else{
        [UIView animateWithDuration:0.3 animations:^{
            _scrlloView.frame=CGRectMake(0, 204, SCREEN_WIDTH, SCREEN_HEIGHT-204);
        }];
    }
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)back:(id)sender {
    if (isChange) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存已修改信息？" preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"update" forKey:@"m"];
            [dict setObject:_county.text forKey:@"cnty"];
            [dict setObject:_fax.text forKey:@"fax_number"];
            [dict setObject:_town.text forKey:@"town"];
            [dict setObject:_name.text forKey:@"name"];
            [dict setObject:_unity.text forKey:@"work_unit"];
            [dict setObject:_post.text forKey:@"post"];
            [dict setObject:_other.text forKey:@"other"];
            [dict setObject:_city.text forKey:@"city"];
            [dict setObject:userDic[@"ids"] forKey:@"ids"];

            [self changePersonInform:dict];
            
            
        }]];
        [self presentViewController:alert animated:true completion:nil];

    }else{
    
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
