//
//  FeedDetailController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/9.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "FeedDetailController.h"
#import "FlowCell.h"

@interface FeedDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{

    UITableView *_tableView;
    CGFloat hig;
}

@property (strong, nonatomic) IBOutlet UIView *feedHeader;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (strong, nonatomic) IBOutlet UIView *opinionView;
@property (weak, nonatomic) IBOutlet UIView *fieldView;
@property (nonatomic ) UIView *maskView;
@property (weak, nonatomic) IBOutlet UITextView *opinionText;

@property (nonatomic ) NSMutableArray *imageArr;
@end

@implementation FeedDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArr=[[NSMutableArray alloc]init];
    [self updateUI];
    [self createTableView];
    [self createMaskView];

}


- (void)updateUI{
    NSString *sss=@"ssjsjajsl挨打了肯德基肯德基肯德基肯德基肯德基肯德基肯德基肯德基肯德基肯德基肯德基啊DJ阿卡设计大赛；德鲁克";
    hig=[self hightWithString:sss];
    UILabel *ditLab = [[UILabel alloc] initWithFrame:CGRectMake(13, 52, SCREEN_WIDTH-26-16, hig)];
    ditLab.text =sss;
    ditLab.numberOfLines=0;
    ditLab.textAlignment=NSTextAlignmentLeft;
    ditLab.font = [UIFont systemFontOfSize:13];
    ditLab.textColor=RGBCOLOR(99, 99, 99);
    [_feedHeader addSubview:ditLab];
    
    if (_imageArr.count>0) {

    }else{
        for (int i=0; i<3; i++) {
                UIImageView *hBg=[[UIImageView alloc]initWithFrame:CGRectMake(17+((SCREEN_WIDTH-80)/3+15)*i, hig+54, (SCREEN_WIDTH-80)/3, (SCREEN_WIDTH-80)/3)];
                [hBg setContentMode:UIViewContentModeScaleToFill];
                [hBg setImage:[UIImage imageNamed:@"zrzh.png"]];
                [_feedHeader addSubview:hBg];
        }
        hig=hig+(SCREEN_WIDTH-80)/3;

    }
    
    UILabel *zhishuLab = [[UILabel alloc] initWithFrame:CGRectMake(13,hig+56, SCREEN_WIDTH-26-16, 20)];
    zhishuLab.text =@"时间:2017/10／10      位置:莲花乡池水沟子";
    zhishuLab.textAlignment=NSTextAlignmentRight;
    zhishuLab.font = [UIFont systemFontOfSize:13];
    zhishuLab.textColor=RGBCOLOR(99, 99, 99);
    [_feedHeader addSubview:zhishuLab];
    
    
    
    _feedHeader.frame=CGRectMake(8, 70, SCREEN_WIDTH-16, 80+hig);
    _feedHeader.layer.masksToBounds=NO;
    _feedHeader.layer.cornerRadius=6;
    _feedHeader.layer.shadowColor=[UIColor grayColor].CGColor;
    _feedHeader.layer.shadowOffset=CGSizeMake(0, 0);
    _feedHeader.layer.shadowOpacity=0.7;
    _feedHeader.layer.shadowRadius=2.f;
    [self.view addSubview:_feedHeader];
    
}

- (void)createMaskView{
    _maskView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-0)];
    _maskView.backgroundColor=RGBACOLOR(44, 44, 44, 0.5);
    [self.view addSubview:_maskView];
    
    _opinionView.frame=CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH*3/8, SCREEN_WIDTH, SCREEN_WIDTH*3/4);
    
    [_maskView addSubview:_opinionView];
    _opinionText.delegate=self;
    
    _fieldView.layer.masksToBounds=NO;
    _fieldView.layer.cornerRadius=6;
    _fieldView.layer.shadowColor=[UIColor grayColor].CGColor;
    _fieldView.layer.shadowOffset=CGSizeMake(0, 0);
    _fieldView.layer.shadowOpacity=0.7;
    _fieldView.layer.shadowRadius=2.f;

    _maskView.hidden=YES;

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (num==0) {
    //        return _dataArray.count;
    //    } else {
    //        return _dataArray1.count;
    //    }
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}




- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 156+hig, SCREEN_WIDTH, SCREEN_HEIGHT-156-hig-44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = RGBCOLOR(120, 120, 120);
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"FlowCell" bundle:nil] forCellReuseIdentifier:@"FlowCell"];//xib定制cell
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlowCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FlowCell"];
    if (indexPath.row==3) {
        cell.lineDown.hidden=YES;
    }else{
        cell.lineDown.hidden=NO;
    }
    [cell setIconimageWith:indexPath.row];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (IBAction)decision:(UIButton *)sender {
    if (sender.tag==0) {
        NSLog(@"同意。。。。。");
        _maskView.hidden=NO;

    }
    if (sender.tag==1) {
        NSLog(@"驳回！！！！！");
        _maskView.hidden=NO;

    }
    if (sender.tag==2) {
        NSLog(@"继续上报————————");
    }
}

- (IBAction)opinionDis:(UIButton *)sender {
    if (sender.tag==0) {
        NSLog(@"确定。。。。。");
    }
    if (sender.tag==1) {
        NSLog(@"取消！！！！！");
        [_opinionText resignFirstResponder];
        _opinionText.text = @"请输入你的同意／不同意意见";
        _opinionText.textColor = [UIColor lightGrayColor];
        _maskView.hidden=YES;
        

    }
    
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(_opinionText.text.length < 1){
        _opinionText.text = @"请输入你的同意／不同意意见";
        _opinionText.textColor = [UIColor lightGrayColor];
    }
    if (SCREEN_WIDTH<400) {
        [UIView animateWithDuration:0.3 animations:^{
            _opinionView.frame=CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH*3/8, SCREEN_WIDTH, SCREEN_WIDTH*3/4);
            
        }];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([_opinionText.text isEqualToString:@"请输入你的同意／不同意意见"]){
        _opinionText.text=@"";
        _opinionText.textColor=[UIColor blackColor];
    }
    if (SCREEN_WIDTH<400) {
        [UIView animateWithDuration:0.3 animations:^{
            _opinionView.frame=CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH*3/8-70, SCREEN_WIDTH, SCREEN_WIDTH*3/4);
            
        }];
        
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (CGFloat)hightWithString:(NSString *)str{
    CGFloat h;
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-26-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    h=titleSize.height;
    return h;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
