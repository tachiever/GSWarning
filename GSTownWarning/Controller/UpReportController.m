//
//  UpReportController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/9/29.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "UpReportController.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "UpReportListController.h"

@interface UpReportController ()<UITextViewDelegate,DateTimePickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>{
    
    NSInteger num;
    BOOL _isFin;
    NSString *_locationCity;
    NSString *_locationCnty;
    NSString *_locationTown;
    NSString *_kindOfWarn;
    
}
@property (nonatomic, strong) DateTimePickerView *datePickerView;

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UIView *uploadView1;
@property (weak, nonatomic) IBOutlet UIButton *timLab1;
@property (weak, nonatomic) IBOutlet UIButton *locaLab1;
@property (weak, nonatomic) IBOutlet UIButton *zrbtn1;
@property (weak, nonatomic) IBOutlet UIButton *ggBtn1;
@property (weak, nonatomic) IBOutlet UIButton *sgBtn1;
@property (weak, nonatomic) IBOutlet UIButton *aqBtn1;
@property (weak, nonatomic) IBOutlet UIImageView *addImage11;
@property (weak, nonatomic) IBOutlet UIImageView *addImage12;
@property (weak, nonatomic) IBOutlet UIImageView *addImage13;
@property (weak, nonatomic) IBOutlet UITextView *disfield1;

@property (strong, nonatomic) IBOutlet UIView *uploadView2;
@property (weak, nonatomic) IBOutlet UIButton *timLab2;
@property (weak, nonatomic) IBOutlet UIButton *locaLab2;
@property (weak, nonatomic) IBOutlet UIButton *zrbtn2;
@property (weak, nonatomic) IBOutlet UIButton *ggBtn2;
@property (weak, nonatomic) IBOutlet UIButton *sgBtn2;
@property (weak, nonatomic) IBOutlet UIButton *aqBtn2;
@property (weak, nonatomic) IBOutlet UIImageView *addImage21;
@property (weak, nonatomic) IBOutlet UIImageView *addImage22;
@property (weak, nonatomic) IBOutlet UIImageView *addImage23;
@property (weak, nonatomic) IBOutlet UITextView *disfield2;
@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UITextView *fieldView;

@property (weak, nonatomic) IBOutlet UIButton *ipList;
@property (nonatomic ) UIView *maskView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic ) NSMutableArray *kinArrray;


@property(nonatomic,retain)CLLocationManager *locationManager;

@end

@implementation UpReportController

- (UIImagePickerController *)imagePicker{
    if (nil == _imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalPresentationStyle = UIModalPresentationCustom;
        
        _imagePicker.view.backgroundColor = [UIColor whiteColor];
        [_imagePicker.navigationBar setBackgroundImage:[UIImage imageNamed:@"headBg"] forBarMetrics:UIBarMetricsDefault];
        _imagePicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
    }
    return _imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    num=0;
    _kinArrray=[[NSMutableArray alloc]init];
    _isFin=NO;
    [self createUI];
    [self createMaskView];
    
    [self locate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openLoca) name:@"OpenLoca" object:nil];
    
}
- (void)openLoca{
    
    [self locate];
    
}

- (void)createUI{
    _scroller.contentSize=CGSizeMake(0, 667);
    self.datePickerView = [[DateTimePickerView alloc] init];
    _datePickerView.delegate = self;
    _datePickerView.pickerViewMode = DatePickerViewDateTimeMode;
    [self.view addSubview:_datePickerView];
    if (SCREEN_WIDTH>380) {
        _uploadView1.frame=CGRectMake(0, 0, SCREEN_WIDTH, 667);
        [_scroller addSubview:_uploadView1];
        _disfield1.delegate=self;
        _disfield1.layer.masksToBounds=NO;
        _disfield1.layer.cornerRadius=4;
        _disfield1.layer.shadowColor=[UIColor grayColor].CGColor;
        _disfield1.layer.shadowOffset=CGSizeMake(0, 0);
        _disfield1.layer.shadowOpacity=0.7;
        _disfield1.layer.shadowRadius=2.f;
        
        _timLab1.layer.masksToBounds=NO;
        _timLab1.layer.cornerRadius=4;
        _timLab1.layer.shadowColor=[UIColor grayColor].CGColor;
        _timLab1.layer.shadowOffset=CGSizeMake(0, 0);
        _timLab1.layer.shadowOpacity=0.7;
        _timLab1.layer.shadowRadius=2.f;
        
        _locaLab1.layer.masksToBounds=NO;
        _locaLab1.layer.cornerRadius=4;
        _locaLab1.layer.shadowColor=[UIColor grayColor].CGColor;
        _locaLab1.layer.shadowOffset=CGSizeMake(0, 0);
        _locaLab1.layer.shadowOpacity=0.7;
        _locaLab1.layer.shadowRadius=2.f;
        
        _addImage12.hidden=YES;
        _addImage13.hidden=YES;
        
    }else{
        _uploadView2.frame=CGRectMake(0, 0, SCREEN_WIDTH, 667);
        [_scroller addSubview:_uploadView2];
        _disfield2.delegate=self;
        _disfield2.layer.masksToBounds=NO;
        _disfield2.layer.cornerRadius=4;
        _disfield2.layer.shadowColor=[UIColor grayColor].CGColor;
        _disfield2.layer.shadowOffset=CGSizeMake(0, 0);
        _disfield2.layer.shadowOpacity=0.7;
        _disfield2.layer.shadowRadius=2.f;
        
        
        _timLab2.layer.masksToBounds=NO;
        _timLab2.layer.cornerRadius=4;
        _timLab2.layer.shadowColor=[UIColor grayColor].CGColor;
        _timLab2.layer.shadowOffset=CGSizeMake(0, 0);
        _timLab2.layer.shadowOpacity=0.7;
        _timLab2.layer.shadowRadius=2.f;
        
        _locaLab2.layer.masksToBounds=NO;
        _locaLab2.layer.cornerRadius=4;
        _locaLab2.layer.shadowColor=[UIColor grayColor].CGColor;
        _locaLab2.layer.shadowOffset=CGSizeMake(0, 0);
        _locaLab2.layer.shadowOpacity=0.7;
        _locaLab2.layer.shadowRadius=2.f;
        
        CGFloat l1,l2;
        l1= SCREEN_WIDTH>321?190:154;
        l2= SCREEN_WIDTH>321?-46:-38;
        [_timLab2 setTitleEdgeInsets:UIEdgeInsetsMake(0, l2, 0, 0)];
        [_timLab2 setImageEdgeInsets:UIEdgeInsetsMake(0, l1, 0, 0)];
        
        _addImage22.hidden=YES;
        _addImage23.hidden=YES;
    }
    _ipList.layer.borderWidth=1;
    _ipList.layer.borderColor=[UIColor whiteColor].CGColor;
    
}

- (void)createMaskView{
    _maskView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-0)];
    _maskView.backgroundColor=RGBACOLOR(44, 44, 44, 0.5);
    [self.view addSubview:_maskView];
    
    _locationView.frame=CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH*3/8, SCREEN_WIDTH, SCREEN_WIDTH*3/4);
    
    [_maskView addSubview:_locationView];
    _fieldView.delegate=self;
    
    _fieldView.layer.masksToBounds=NO;
    _fieldView.layer.cornerRadius=4;
    _fieldView.layer.shadowColor=[UIColor grayColor].CGColor;
    _fieldView.layer.shadowOffset=CGSizeMake(0, 0);
    _fieldView.layer.shadowOpacity=0.7;
    _fieldView.layer.shadowRadius=2.f;
    
    _maskView.hidden=YES;
    
}
- (IBAction)showList:(id)sender {
            UpReportListController *uvc=[[UpReportListController alloc]init];
            uvc.useDic=[_useDic mutableCopy];
            [self.navigationController pushViewController:uvc animated:YES];
}

- (IBAction)finishInput:(UIButton *)sender {
    [_fieldView resignFirstResponder];
    _maskView.hidden=YES;
    
    if (_fieldView.text.length>0&&![_fieldView.text isEqualToString:@"例:(xx市xx区xx街道xx号)"]) {
        
        if (SCREEN_WIDTH>375) {
            [_locaLab1 setTitle:_fieldView.text forState:UIControlStateNormal];
        }else{
            [_locaLab2 setTitle:_fieldView.text forState:UIControlStateNormal];
        }
    }
    _fieldView.text = @"例:(xx市xx区xx街道xx号)";
    _fieldView.textColor = [UIColor lightGrayColor];
    
}

- (IBAction)selectBtn:(UIButton *)sender {
    [_datePickerView showDateTimePickerView];
    
}

#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    if (SCREEN_WIDTH>375) {
        [_timLab1 setTitle:date forState:UIControlStateNormal];
    }else{
        [_timLab2 setTitle:date forState:UIControlStateNormal];
        
    }
}

- (IBAction)showLocation:(UIButton *)sender {
    
    _maskView.hidden=NO;
    
}

- (IBAction)selectInsdent:(UIButton *)sender {
    [self resetBtn];
    if (sender==_zrbtn1) {
        [_zrbtn1 setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        _kindOfWarn=[NSString stringWithFormat:@"自然灾害"];
    }if (sender==_ggBtn1) {
        [_ggBtn1 setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        _kindOfWarn=[NSString stringWithFormat:@"公共卫生事件"];
        
    }if (sender==_sgBtn1) {
        [_sgBtn1 setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        _kindOfWarn=[NSString stringWithFormat:@"事故灾难"];
        
    }if (sender==_aqBtn1) {
        [_aqBtn1 setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        _kindOfWarn=[NSString stringWithFormat:@"安全事件"];
    }
}

- (IBAction)selectIncident:(UIButton *)sender {
    [self resetBtn];
    if (sender==_zrbtn2) {
        [_zrbtn2 setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        _kindOfWarn=[NSString stringWithFormat:@"自然灾害"];
        
    }if (sender==_ggBtn2) {
        [_ggBtn2 setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        _kindOfWarn=[NSString stringWithFormat:@"公共卫生事件"];
        
    }if (sender==_sgBtn2) {
        [_sgBtn2 setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        _kindOfWarn=[NSString stringWithFormat:@"事故灾难"];
        
    }if (sender==_aqBtn2) {
        [_aqBtn2 setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        _kindOfWarn=[NSString stringWithFormat:@"安全事件"];
    }
}

- (void)resetBtn{
    if (SCREEN_WIDTH>375) {
        [_zrbtn1 setBackgroundImage:nil forState:UIControlStateNormal];
        [_ggBtn1 setBackgroundImage:nil forState:UIControlStateNormal];
        [_sgBtn1 setBackgroundImage:nil forState:UIControlStateNormal];
        [_aqBtn1 setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [_zrbtn2 setBackgroundImage:nil forState:UIControlStateNormal];
        [_ggBtn2 setBackgroundImage:nil forState:UIControlStateNormal];
        [_sgBtn2 setBackgroundImage:nil forState:UIControlStateNormal];
        [_aqBtn2 setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (IBAction)addImage11:(UITapGestureRecognizer *)sender {
    num=1;
    [self showActSheet];
}

- (IBAction)addImage12:(UITapGestureRecognizer *)sender {
    num=2;
    [self showActSheet];
}

- (IBAction)addImage113:(UITapGestureRecognizer *)sender {
    num=3;
    [self showActSheet];
}

- (IBAction)addimage21:(UITapGestureRecognizer *)sender {
    num=1;
    [self showActSheet];
}

- (IBAction)addImage22:(UITapGestureRecognizer *)sender {
    num=2;
    [self showActSheet];
}

- (IBAction)addimage23:(UITapGestureRecognizer *)sender {
    num=3;
    [self showActSheet];
}

- (void)showActSheet{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"添加图片／视频" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
  
        [mediaTypes addObject:( NSString *)kUTTypeImage];
    
        [mediaTypes addObject:( NSString *)kUTTypeMovie];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePicker.mediaTypes = [NSArray arrayWithObject:mediaTypes[0]];//设置媒体类型为public.image
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在iPhone的“设置-隐私”选项中，允许访问您的相册。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        BOOL hasPermission = YES;
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            hasPermission = NO;
        }
        if (!hasPermission) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在iPhone的“设置-隐私”选项中，允许访问您的相机。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.imagePicker.mediaTypes =[NSArray arrayWithObject:mediaTypes[0]];//设置媒体类型为public.image
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            } else {
                NSLog(@"camera is no available!");
            }
        }
        
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"拍视频" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        BOOL hasPermission = YES;
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            hasPermission = NO;
        }
        if (!hasPermission) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在iPhone的“设置-隐私”选项中，允许访问您的相机。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.imagePicker.mediaTypes = [NSArray arrayWithObject:mediaTypes[1]];//设置媒体类型为public.movie
                self.imagePicker.videoMaximumDuration = 9.0f;//30秒
                
                [self presentViewController:self.imagePicker animated:YES completion:nil];
                
                
            } else {
                NSLog(@"camera is no available!");
            }
        }
    }];
    [alertC addAction:action0];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [self presentViewController:alertC animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    if ([info[@"UIImagePickerControllerMediaType"] isEqualToString: @"public.movie"]) {
        NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSURL *newVideoUrl ; //一般.mp4
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *simpleImg = [UIImage simpleImage:orgImage];
        [self setImageWithNum:num image:simpleImg];
        [self addImage:simpleImg];
    }
}

- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         
         if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
             //handler(exportSession);
             //NSLog(@"OutPutUrl:---%@",outputURL);
             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 // 处理耗时操作的代码块...
                 [self addVideo:outputURL];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //回调或者说是通知主线程刷新，
                     [SVProgressHUD showWithStatus:@"视频转码中..."];
                     UIImage *simpleImg = [UIImage simpleImage:[self getVideoPreViewImageWithPath:outputURL]];
                     [self setImageWithNum:num image:simpleImg];
                 });
             });
         }else{
             NSLog(@"转换失败,值为:%li,可能的原因:%@",(long)[exportSession status],[[exportSession error] localizedDescription]);
         }
     }];
}

- (UIImage*) getVideoPreViewImageWithPath:(NSURL *)videoPath{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    
    AVAssetImageGenerator *gen         = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.maximumSize = CGSizeMake(300, 169);
    CMTime time      = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error   = nil;
    
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img     = [[UIImage alloc] initWithCGImage:image];
    
    return img;
}

- (void)setImageWithNum:(NSInteger )inte image:(UIImage *)image{
    
    [SVProgressHUD dismiss];
    
    if (SCREEN_WIDTH>375) {
        if (num==1) {
            [_addImage11 setImage:image];
            _addImage12.hidden=NO;
        }
        if (num==2) {
            [_addImage12 setImage:image];
            _addImage13.hidden=NO;
            
        }
        if (num==3) {
            [_addImage13 setImage:image];
        }
    }else{
        if (num==1) {
            [_addImage21 setImage:image];
            _addImage22.hidden=NO;
            
        }
        if (num==2) {
            [_addImage22 setImage:image];
            _addImage23.hidden=NO;
        }
        if (num==3) {
            [_addImage23 setImage:image];
        }
    }
}

- (IBAction)upload:(UIButton *)sender {
    
  //  NSLog(@"%@",_kinArrray);
    
    NSString *pathStr = [_kinArrray componentsJoinedByString:@","];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval interval1;
    NSMutableDictionary *diction=[[NSMutableDictionary alloc]init];
    [diction setObject:@"report" forKey:@"m"];
    [diction setObject:_useDic[@"name"] forKey:@"name"];
    [diction setObject:_useDic[@"phone"] forKey:@"phone"];
    [diction setObject:_useDic[@"work_unit"] forKey:@"work_unit"];
    [diction setObject:_useDic[@"post"] forKey:@"post"];
    [diction setObject:pathStr forKey:@"filepath"];
    [diction setObject:_useDic[@"city"] forKey:@"city"];
    [diction setObject:_useDic[@"town"] forKey:@"town"];
    if ([[_useDic allKeys]  containsObject: @"county"]){
        [diction setObject:_useDic[@"county"] forKey:@"cnty"];
        
    }
    if ([[_useDic allKeys]  containsObject: @"cnty"]){
        [diction setObject:_useDic[@"cnty"] forKey:@"cnty"];
        
    }
    
    if (_kindOfWarn.length>0) {
        [diction setObject:_kindOfWarn forKey:@"type"];
        if (sender.tag==1) {
            NSDate *beg=[dateFormatter2 dateFromString:_timLab1.titleLabel.text];
            interval1 = [beg timeIntervalSince1970];
            NSTimeInterval interval2 = [[NSDate date] timeIntervalSince1970];
            if (interval2>=interval1) {
                if (_disfield1.text.length>6) {
                    if ([_locaLab1.titleLabel.text isEqualToString: @"请手动输入位置"]||_locaLab1.titleLabel.text.length<7) {
                        [SVProgressHUD showErrorWithStatus:@"请输入您的详细位置"];
                        
                    }else{
                        
                        [diction setObject:_locaLab1.titleLabel.text forKey:@"jqposition"];
                        [diction setObject:[NSString stringWithFormat:@"%.f",interval1*1000] forKey:@"times"];
                        [diction setObject:_disfield1.text forKey:@"content"];
                        [self uploadInfo:diction];
                        
                    }
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:@"上报内容过短！"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"时间选择有误"];
            }
            
        }else{
            NSDate *end=[dateFormatter2 dateFromString:_timLab2.titleLabel.text];
            interval1 = [end timeIntervalSince1970];
            
            NSTimeInterval interval2 = [[NSDate date] timeIntervalSince1970];
            if (interval2>interval1) {
                if (_disfield2.text.length>6) {
                    if ([_locaLab2.titleLabel.text isEqualToString: @"请手动输入位置"]||_locaLab2.titleLabel.text.length<7) {
                        [SVProgressHUD showErrorWithStatus:@"请输入您的详细位置"];
                        
                    }else{
                        
                        [diction setObject:_locaLab2.titleLabel.text forKey:@"jqposition"];
                        [diction setObject:[NSString stringWithFormat:@"%.f",interval1*1000] forKey:@"times"];
                        [diction setObject:_disfield2.text forKey:@"content"];
                        [self uploadInfo:diction];
                        
                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:@"上报内容过短！"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"时间选择有误"];
            }
        }
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择事件！"];

    
    }
    
}

- (void)uploadInfo:(NSMutableDictionary *)dict{
     NSLog(@"%@",dict);
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"android_client_sxphone_app" forHTTPHeaderField:@"User-Agent"];
    [manger.requestSerializer setValue:@"www.dfec.com" forHTTPHeaderField:@"Host"];
    [manger POST:WarnUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([dic[0][@"code"] integerValue]==20000) {
            [SVProgressHUD showSuccessWithStatus:@"上报成功！"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.actionUploadSuccess) {
                self.actionUploadSuccess();
            }
            
            
            
            
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传内容失败！"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)addImage:(UIImage *)image{
    NSData *imageData =UIImageJPEGRepresentation(image,0.5);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"si" forKey:@"filepath"];
    [dict setObject:_useDic[@"phone"] forKey:@"user_phone"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    
    [manager POST:UploadData parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"myFileName"
                                fileName:fileName
                                mimeType:@"image/jpeg"];//video/mpeg4
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
       // NSLog(@"%@",responseObject);
        if ([responseObject[0][@"code"] integerValue]==20000) {
            if (num>_kinArrray.count) {
                [_kinArrray addObject:responseObject[1][@"url"]];
            }else{
                [_kinArrray replaceObjectAtIndex:num-1 withObject:responseObject[1][@"url"]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传图片失败！"];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传图片失败！"];
        
    }];
}

-(void)addVideo:(NSURL *)filUrl{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"si" forKey:@"filepath"];
    [dict setObject:_useDic[@"phone"] forKey:@"user_phone"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    
    [manager POST:UploadData parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:filUrl name:@"myFileName" error:NULL];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) { // 上传成功
       // NSLog(@"%@",responseObject);
        
        if ([responseObject[0][@"code"] integerValue]==20000) {
            if (num>_kinArrray.count) {
                [_kinArrray addObject:responseObject[1][@"url"]];
            }else{
                [_kinArrray replaceObjectAtIndex:num-1 withObject:responseObject[1][@"url"]];
            }
            [self ClearMovieFromDoucments];
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传视频失败！"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { //上传失败
        [SVProgressHUD showErrorWithStatus:@"上传视频失败！"];
    }];
}

#pragma mark - 清除documents中的视频文件
-(void)ClearMovieFromDoucments{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        NSLog(@"%@",filename);
        if ([filename isEqualToString:@"tmp.PNG"]) {
            NSLog(@"删除%@",filename);
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
            continue;
        }
        if ([[[filename pathExtension] lowercaseString] isEqualToString:@"mp4"]||
            [[[filename pathExtension] lowercaseString] isEqualToString:@"mov"]||
            [[[filename pathExtension] lowercaseString] isEqualToString:@"png"]) {
            NSLog(@"删除%@",filename);
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView==_fieldView) {
        if(_fieldView.text.length < 1){
            _fieldView.text = @"例:(xx市xx区xx街道xx号)";
            _fieldView.textColor = [UIColor lightGrayColor];
        }
        if (SCREEN_WIDTH<400) {
            [UIView animateWithDuration:0.3 animations:^{
                _locationView.frame=CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH*3/8, SCREEN_WIDTH, SCREEN_WIDTH*3/4);
                
            }];
        }
    }
    else{
        if(textView.text.length < 1){
            textView.text = @"请输入上报内容";
            textView.textColor = [UIColor lightGrayColor];
        }
        if (SCREEN_WIDTH>375) {
            [UIView animateWithDuration:0.3 animations:^{
                _uploadView1.frame=CGRectMake(0, 0, SCREEN_WIDTH, 667);
            }];
            
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                _uploadView2.frame=CGRectMake(0, 0, SCREEN_WIDTH, 667);
            }];
            
        }}
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView==_fieldView) {
        if([_fieldView.text isEqualToString:@"例:(xx市xx区xx街道xx号)"]){
            _fieldView.text=@"";
            _fieldView.textColor=[UIColor blackColor];
        }
        if (SCREEN_WIDTH<400) {
            [UIView animateWithDuration:0.3 animations:^{
                _locationView.frame=CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH*3/8-70, SCREEN_WIDTH, SCREEN_WIDTH*3/4);
                
            }];
            
        }
    }else{
        if([textView.text isEqualToString:@"请输入上报内容"]){
            textView.text=@"";
            textView.textColor=[UIColor blackColor];
        }
        if (SCREEN_WIDTH>375) {
            
            [UIView animateWithDuration:0.3 animations:^{
                _uploadView1.frame=CGRectMake(0, -180, SCREEN_WIDTH, 667);
            }];
            
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                _uploadView2.frame=CGRectMake(0, -170, SCREEN_WIDTH, 667);
            }];
            
        }
        CGFloat offset = self.scroller.contentSize.height - self.scroller.bounds.size.height;
        if (offset > 0)
        {
            [self.scroller setContentOffset:CGPointMake(0, offset) animated:YES];
        }
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
                
                
                [self locate];
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
                
            }]];
            [self presentViewController:alert animated:true completion:nil];
            
        }
        
        
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法定位，请开启定位" preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (SCREEN_WIDTH>375) {
                [_locaLab1 setTitle:[NSString stringWithFormat:@"请手动输入位置"] forState:UIControlStateNormal];
                
            }else{
                [_locaLab2 setTitle:[NSString stringWithFormat:@"请手动输入位置"] forState:UIControlStateNormal];
                
            }
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
    if (!_isFin) {
        CLLocation *currentLocation = [locations lastObject];
        //NSLog(@"当前经纬度%.1f,%.1f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        
        //反编码
        [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count > 0) {
                CLPlacemark *placeMark = placemarks[0];
                
                
                //获取城市
                NSString *city = placeMark.locality;
//                 NSLog(@"当前位置%@",placeMark.subThoroughfare);
//                NSLog(@"当前位置%@",placeMark);
    
                if (!city) {
                    city = nil;
                    // city = placeMark.administrativeArea;
                }
                //NSLog(@"%@",placeMark.administrativeArea); //这就是当前的城市
                
                _locationCity=[NSString stringWithFormat:@"%@",city];
                _locationCnty=[NSString stringWithFormat:@"%@",placeMark.subLocality];
                if (placeMark.subThoroughfare!=nil) {
                    _locationTown=[NSString stringWithFormat:@"%@%@",placeMark.thoroughfare,placeMark.subThoroughfare];
                }else{
                    _locationTown=[NSString stringWithFormat:@"%@",placeMark.thoroughfare];

                }
                
                
                if (SCREEN_WIDTH>375) {
                    [_locaLab1 setTitle:[NSString stringWithFormat:@"%@%@%@",_locationCity,_locationCnty,_locationTown] forState:UIControlStateNormal];
                    
                }else{
                    [_locaLab2 setTitle:[NSString stringWithFormat:@"%@%@%@",_locationCity,_locationCnty,_locationTown] forState:UIControlStateNormal];
                    
                }
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
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
