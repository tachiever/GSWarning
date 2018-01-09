//
//  FeedBackController.m
//  GSTownWarning
//
//  Created by Tcy on 2017/9/29.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "FeedBackController.h"
#import "FeedListCell.h"
#import "FeedDetailController.h"

@interface FeedBackController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSInteger num;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *selControl;

@property (nonatomic ) NSMutableArray *dataArray;
@property (nonatomic ) NSMutableArray *dataArray1;

@end

@implementation FeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray1=[[NSMutableArray alloc]init];
    _dataArray=[[NSMutableArray alloc]init];
    num=0;
    [self createUI];
    [self createTableView];


}

- (IBAction)changeValue:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        num=0;
    }
    if (sender.selectedSegmentIndex==1) {
        num=1;
    }
}


- (void)createUI{
 
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
    [_selControl setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
    [_selControl setTitleTextAttributes:dics forState:UIControlStateNormal];
//    UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
//                                                           forKey:UITextAttributeFont];
//    [_selControl setTitleTextAttributes:attributes
//                               forState:UIControlStateNormal];


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
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedDetailController *fdvc=[[FeedDetailController alloc]init];
    [self.navigationController pushViewController:fdvc animated:YES];
}




- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, SCREEN_HEIGHT-105) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = RGBCOLOR(120, 120, 120);
    
    [self.view addSubview:_tableView];
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"FeedListCell" bundle:nil] forCellReuseIdentifier:@"FeedListCell"];//xib定制cell
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FeedListCell"];
    
//    CGFloat f= (SCREEN_HEIGHT>600? 17 :14);
//    
//    
//    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
//    //cell.textLabel.text=@"sss";
//    cell.backgroundColor=[UIColor clearColor];
//    cell.textLabel.textColor=[UIColor whiteColor];
//    cell.textLabel.font=[UIFont systemFontOfSize:f];
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    
//    cell.selectedBackgroundView.backgroundColor = RGBACOLOR(77, 77, 77, 1);
//
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
