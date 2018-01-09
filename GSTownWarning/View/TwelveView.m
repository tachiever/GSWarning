//
//  TwelveView.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/20.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "TwelveView.h"
#import "LineViewLayout.h"
#import "TwelCell.h"
#import "PlaceholdeCell.h"


@interface TwelveView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UICollectionView *collection;
    NSMutableArray *_dataArray;
    NSMutableArray *_temArray;
    NSMutableArray *_tem1Array;
    NSMutableArray *_timArray;
    NSMutableArray *_imageArray;
    NSInteger inte;
}

@end
@implementation TwelveView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        _imageArray=[[NSMutableArray alloc]init];
        _dataArray=[[NSMutableArray alloc]init];
        _temArray=[[NSMutableArray alloc]init];
        _tem1Array=[[NSMutableArray alloc]init];
        _timArray=[[NSMutableArray alloc]init];
        NSArray *falarr=@[@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴",@"晴 "];
        NSArray *tem=@[@"10",@"10",@"10",@"10",@"10",@"10",@"10",@"10",];
        NSArray *timarr=@[@"0/0 00:00",@"0/0 00:00",@"0/0 00:00",@"0/0 00:00",@"0/0 00:00",@"0/0 00:00",@"0/0 00:00",@"0/0 00:00"];

        [_imageArray addObjectsFromArray:falarr];
        [_dataArray addObjectsFromArray:falarr];
        [_temArray addObjectsFromArray:tem];
        [_tem1Array addObjectsFromArray:tem];
        [_timArray addObjectsFromArray:timarr];
        inte=2;
        [self setup];
        
    }
    return self;
}

- (void)setup {
    UIImageView *hBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    [hBg setContentMode:UIViewContentModeScaleToFill];
    [hBg setImage:[UIImage imageNamed:@"titBg"]];
    [self addSubview:hBg];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
    label.text =@"七天天气预报";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    [hBg addSubview:label];
    
    UIImageView *bBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 32, self.frame.size.width, self.frame.size.height-32)];
    [bBg setContentMode:UIViewContentModeScaleToFill];
    
    UIImage *image =[UIImage imageNamed:@"titBg"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [bBg setImage:image];
    [self addSubview:bBg];
    
    
    LineViewLayout *layout = [[LineViewLayout alloc] init];
    
    
    collection=[[UICollectionView alloc]initWithFrame:CGRectMake(8+(SCREEN_WIDTH-414)/2, 40, 414-16, self.frame.size.height-48) collectionViewLayout:layout];

    collection.delegate = self;
    collection.dataSource = self;
    [self addSubview:collection];
    collection.backgroundColor = [UIColor clearColor];
    collection.showsHorizontalScrollIndicator=NO;
    [collection registerNib:[UINib nibWithNibName:@"TwelCell" bundle:nil] forCellWithReuseIdentifier:@"TwelCell"];
    [collection registerClass:[PlaceholdeCell class] forCellWithReuseIdentifier:@"PlaceholdeCell"];

}


#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count+4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<2||indexPath.row>_dataArray.count+1) {
        PlaceholdeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceholdeCell" forIndexPath:indexPath];
        
        return cell;
    }
    else {
        TwelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TwelCell" forIndexPath:indexPath];
        
        if (inte==indexPath.row) {
            //[cell.bgImage setImage:[UIImage imageNamed:@"titBg"]];
            cell.bgImage.backgroundColor=RGBACOLOR(99, 99, 99, 0.4);
            cell.bgImage.layer.borderColor=RGBACOLOR(200, 200, 200, 0.6).CGColor;
            
        }else{
            // [cell.bgImage setImage:[UIImage imageNamed:@""]];
            
            cell.bgImage.backgroundColor=RGBACOLOR(9, 9, 9, 0.6);
            cell.bgImage.layer.borderColor=RGBACOLOR(120, 120, 120, 0.8).CGColor;
        }
        
        cell.weaLab.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.item-2]];
        cell.temLab.text=[NSString stringWithFormat:@"%@℃",_temArray[indexPath.item-2] ];
        cell.tem1Lab.text=[NSString stringWithFormat:@"%@℃",_tem1Array[indexPath.item-2]];
        cell.timLab.text=[NSString stringWithFormat:@"%@",_timArray[indexPath.item-2]];
        [cell.weaImage setImage:[UIImage imageNamed:[NSString weaIconWithWea:_imageArray[indexPath.item-2]]]];
        return cell;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point=scrollView.contentOffset;
    //NSLog(@"=====                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              %f,%f",point.x,point.y);
    inte=2+(point.x-1)/88;
    [collection reloadData];
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    inte=indexPath.item;
//    [collection reloadData];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        collection.contentOffset=CGPointMake((indexPath.item-2)*86+1, 0);
// 
//    } completion:^(BOOL finished) {
//
//    }];
//    NSLog(@"%ld %ld item被点击了",indexPath.section,indexPath.item);

}

- (void)updateWithArr:(NSMutableArray *)datArr tim:(NSMutableArray *)timArr tem1:(NSMutableArray *)tem1Arr tem:(NSMutableArray *)temArr imageArr:(NSMutableArray *)imageArr{

    [_dataArray removeAllObjects];
    [_temArray removeAllObjects];
    [_timArray removeAllObjects];
    [_tem1Array removeAllObjects];
    [_imageArray removeAllObjects];
    
    

    _imageArray=[imageArr mutableCopy];
    _dataArray=[datArr mutableCopy];
    _timArray=[timArr mutableCopy];
    _temArray=[temArr mutableCopy];
    _tem1Array=[tem1Arr mutableCopy];
   // NSLog(@"sosos%@%@",_temArray,imageArr[0]);

    [collection reloadData];
}

- (NSString *)weaIconWithWea:(NSString *)str{
    NSString *dayIconstr;
    if ([str isEqualToString:@"晴"]){
        dayIconstr=@"d_qing";
    }
    else if ([str isEqualToString:@"多云"]){
        dayIconstr=@"d_duoyun";
    }
    else if ([str isEqualToString:@"阴"]){
        dayIconstr=@"d_yin";
    }
    else if ([str isEqualToString:@"阵雨"]){
        dayIconstr=@"d_zhenyu";
    }
    else if ([str isEqualToString:@"雷阵雨"]){
        dayIconstr=@"d_leizhenyu";
    }
    else if ([str isEqualToString:@"冰雹"]){
        dayIconstr=@"d_leizhengyubanyoubingbao";
    }
    else if ([str isEqualToString:@"雨夹雪"]){
        dayIconstr=@"d_yujiaxue";
    }
    else if ([str isEqualToString:@"阵雪"]){
        dayIconstr=@"d_zhenxue";
    }
    else if ([str isEqualToString:@"雾"]){
        dayIconstr=@"d_wu";
    }
    else if ([str isEqualToString:@"冻雨"]){
        dayIconstr=@"d_dongyu";
    }
    else if ([str isEqualToString:@"沙尘暴"]){
        dayIconstr=@"d_shachenbao";
    }
    else if ([str isEqualToString:@"小雨"]){
        dayIconstr=@"d_xiaoyu";
    }
    else if ([str isEqualToString:@"中雨"]){
        dayIconstr=@"d_xiaoyu_zhongyu";
    }
    else if ([str isEqualToString:@"大雨"]){
        dayIconstr=@"d_zhongyu_dayu";
    }
    else if ([str isEqualToString:@"暴雨"]){
        dayIconstr=@"d_dayu_baoyu";
    }
    else if ([str isEqualToString:@"大暴雨"]){
        dayIconstr=@"d_baoyu_dabaoyu";
    }
    else if ([str isEqualToString:@"特大暴雨"]){
        dayIconstr=@"d_dabaoyu_tedabaoyu";
    }
    else if ([str isEqualToString:@"小雪"]){
        dayIconstr=@"d_xiaoxue";
    }
    else if ([str isEqualToString:@"中雪"]){
        dayIconstr=@"d_xiaoxue_zhongxue";
    }
    else if ([str isEqualToString:@"大雪"]){
        dayIconstr=@"d_zhongxue_daxue";
    }
    else if ([str isEqualToString:@"暴雪"]){
        dayIconstr=@"d_daxue_baoxue";
    }
    else if ([str isEqualToString:@"阵雪"]){
        dayIconstr=@"d_zhenxue";
    }
    else if ([str isEqualToString:@"浮尘"]){
        dayIconstr=@"d_fuchen";
    }
    else if ([str isEqualToString:@"扬沙"]){
        dayIconstr=@"d_yangsha";
    }
    else if ([str isEqualToString:@"强沙尘暴"]){
        dayIconstr=@"d_qiangshachenbao";
    }
    else if ([str isEqualToString:@"雨"]){
        dayIconstr=@"d_zhongyu";
    }
    else if ([str isEqualToString:@"雪"]){
        dayIconstr=@"d_zhongxue";
    }
    else if ([str isEqualToString:@"霾"]){
        dayIconstr=@"d_mai";
    }
    else{
        dayIconstr=@"d_qing";
    }
    
    return dayIconstr;
}
- (NSString *)dayWeatherChangeImage:(NSString *)weather{
    
    NSString *dayIconstr;
    NSInteger dayIcon=[weather integerValue];
    if (0==dayIcon){
        dayIconstr=@"d_qing";
    }
    else if (1==dayIcon){
        dayIconstr=@"d_duoyun";
    }
    else if (2==dayIcon){
        dayIconstr=@"d_yin";
        
    }
    else if (3==dayIcon){
        dayIconstr=@"d_zhenyu";
    }
    else if (4==dayIcon){
        dayIconstr=@"d_leizhenyu";
    }
    else if (5==dayIcon){
        dayIconstr=@"d_leizhengyubanyoubingbao";
    }
    else if (6==dayIcon){
        dayIconstr=@"d_yujiaxue";
    }
    else if (7==dayIcon){
        dayIconstr=@"d_xiaoyu";
    }
    else if (8==dayIcon){
        dayIconstr=@"d_zhongyu";
    }
    else if (9==dayIcon){
        dayIconstr=@"d_dayu";
    }
    else if (10==dayIcon){
        dayIconstr=@"d_baoyu";
    }
    else if (11==dayIcon){
        dayIconstr=@"d_dabaoyu";
    }
    else if (12==dayIcon){
        dayIconstr=@"d_tedabaoyu";
    }
    else if (13==dayIcon){
        dayIconstr=@"d_zhenxue";
    }
    else if (14==dayIcon){
        dayIconstr=@"d_xiaoxue";
    }
    else if (15==dayIcon){
        dayIconstr=@"d_zhongxue";
    }
    else if (16==dayIcon){
        dayIconstr=@"d_daxue";
    }
    else if (17==dayIcon){
        dayIconstr=@"d_baoxue";
    }
    else if (18==dayIcon){
        dayIconstr=@"d_wu";
    }
    else if (19==dayIcon){
        dayIconstr=@"d_dongyu";
    }
    else if (20==dayIcon){
        dayIconstr=@"d_shachenbao";
    }
    else if (21==dayIcon){
        dayIconstr=@"d_xiaoyu_zhongyu";
    }
    else if (22==dayIcon){
        dayIconstr=@"d_zhongyu_dayu";
    }
    else if (23==dayIcon){
        dayIconstr=@"d_dayu_baoyu";
    }
    else if (24==dayIcon){
        dayIconstr=@"d_baoyu_dabaoyu";
    }
    else if (25==dayIcon){
        dayIconstr=@"d_dabaoyu_tedabaoyu";
    }
    else if (26==dayIcon){
        dayIconstr=@"d_xiaoxue_zhongxue";
    }
    else if (27==dayIcon){
        dayIconstr=@"d_zhongxue_daxue";
    }
    else if (28==dayIcon){
        dayIconstr=@"d_daxue_baoxue";
    }
    else if (29==dayIcon){
        dayIconstr=@"d_fuchen";
    }
    else if (30==dayIcon){
        dayIconstr=@"d_yangsha";
    }
    else if (31==dayIcon){
        dayIconstr=@"d_qiangshachenbao";
    }
    
    else if (33==dayIcon){
        dayIconstr=@"d_zhongyu";
    }
    else if (33==dayIcon){
        dayIconstr=@"d_zhongxue";
    }
    else if (53==dayIcon){
        dayIconstr=@"d_mai";
    }
    else{
        dayIconstr=@"d_qing";
        
    }
    
    return dayIconstr;
}
- (NSString *)WeatherWithStr:(NSString *)weather{
    
    NSString *dayIconstr;
    NSInteger dayIcon=[weather integerValue];
    if (0==dayIcon){
        dayIconstr=@"晴";
    }
    else if (1==dayIcon){
        dayIconstr=@"多云";
    }
    else if (2==dayIcon){
        dayIconstr=@"阴";
        
    }
    else if (3==dayIcon){
        dayIconstr=@"阵雨";
    }
    else if (4==dayIcon){
        dayIconstr=@"雷阵雨";
    }
    else if (5==dayIcon){
        dayIconstr=@"冰雹";
    }
    else if (6==dayIcon){
        dayIconstr=@"雨夹雪";
    }
    else if (7==dayIcon){
        dayIconstr=@"小雨";
    }
    else if (8==dayIcon){
        dayIconstr=@"中雨";
    }
    else if (9==dayIcon){
        dayIconstr=@"大雨";
    }
    else if (10==dayIcon){
        dayIconstr=@"暴雨";
    }
    else if (11==dayIcon){
        dayIconstr=@"大暴雨";
    }
    else if (12==dayIcon){
        dayIconstr=@"特大暴雨";
    }
    else if (13==dayIcon){
        dayIconstr=@"阵雪";
    }
    else if (14==dayIcon){
        dayIconstr=@"小雪";
    }
    else if (15==dayIcon){
        dayIconstr=@"中雪";
    }
    else if (16==dayIcon){
        dayIconstr=@"大雪";
    }
    else if (17==dayIcon){
        dayIconstr=@"暴雪";
    }
    else if (18==dayIcon){
        dayIconstr=@"雾";
    }
    else if (19==dayIcon){
        dayIconstr=@"冻雨";
    }
    else if (20==dayIcon){
        dayIconstr=@"沙尘暴";
    }
    else if (21==dayIcon){
        dayIconstr=@"中雨";
    }
    else if (22==dayIcon){
        dayIconstr=@"大雨";
    }
    else if (23==dayIcon){
        dayIconstr=@"暴雨";
    }
    else if (24==dayIcon){
        dayIconstr=@"大暴雨";
    }
    else if (25==dayIcon){
        dayIconstr=@"特大暴雨";
    }
    else if (26==dayIcon){
        dayIconstr=@"中雪";
    }
    else if (27==dayIcon){
        dayIconstr=@"大雪";
    }
    else if (28==dayIcon){
        dayIconstr=@"暴雪";
    }
    else if (29==dayIcon){
        dayIconstr=@"浮尘";
    }
    else if (30==dayIcon){
        dayIconstr=@"扬沙";
    }
    else if (31==dayIcon){
        dayIconstr=@"强沙尘暴";
    }
    
    else if (33==dayIcon){
        dayIconstr=@"雨";
    }
    else if (33==dayIcon){
        dayIconstr=@"雪";
    }
    else if (53==dayIcon){
        dayIconstr=@"霾";
    }
    else{
        dayIconstr=@"晴";
        
    }
    return dayIconstr;
}

@end
