//
//  DingzhiView.m
//  GSTownWarning
//
//  Created by Tcy on 2017/10/11.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "DingzhiView.h"
#import "IconBtn.h"
@interface DingzhiView (){
    UIScrollView *scrollView;
    
    NSInteger _l;
    CGFloat _w;
    
}
@property (nonatomic ) NSMutableArray *titArray;
@end
@implementation DingzhiView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        _titArray=[[NSMutableArray alloc]init];
        _w=10;
        _l=0;
//        NSArray *arr=@[@"晴dlddl",@"晴少数",@"晴水",@"晴撒d实况",@"晴撒连",@"阿克苏酒店asked实况",@"酒店asked实况",@"sakd 实况"];
//        
//        [_titArray addObjectsFromArray:arr];
    }
    return self;
}

- (void)setup {
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.bounces=YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:scrollView];

    
}

- (void)drawRect:(CGRect)rect{
    
    [self setup];

    for (int i=0; i<_titArray.count; i++) {
        CGFloat sw=[NSString stringWidth:[NSString stringWithFormat:@"%@",_titArray[i]] font:14]+34;
        if (_w+sw>self.frame.size.width-20) {
            _w=10;
            _l++;
            
        }
        
        IconBtn *iconView=[[IconBtn alloc]initWithFrame:CGRectMake(_w, 6+(48)*_l, sw, 45)];
        [iconView.titLab setText:[NSString stringWithFormat:@"%@",_titArray[i]]];
        if (self.model==0) {
            [iconView.closeBtn setImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
        }else{
            [iconView.closeBtn setImage:[UIImage imageNamed:@"selectBtn.png"] forState:UIControlStateNormal];

        }
        iconView.tag=i;
        [scrollView addSubview:iconView];
        _w=_w+sw;
        
        [iconView setActionClose:^(NSInteger ta) {
            if (self.actionCloseView) {
                self.actionCloseView(ta);
            }
        }];

    }
    scrollView.contentSize = CGSizeMake(0,(_l+1)*48+20);

}

- (void)updateWithArr:(NSMutableArray *)titArr{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _w=10;
    _l=0;
    [_titArray removeAllObjects];
    _titArray =[titArr mutableCopy];
    [self setNeedsDisplay];
}
@end
