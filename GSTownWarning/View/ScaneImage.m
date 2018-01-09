
//
//  ScaneImage.m
//  GSTownWarning
//
//  Created by Tcy on 2017/11/9.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "ScaneImage.h"
@interface ScaneImage ()<UIScrollViewDelegate>{
    
    UIScrollView *_scroll;
    
    
}
@property (nonatomic)UIImageView *imageView;

@end

@implementation ScaneImage
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor=RGBACOLOR(4, 4, 4, 0.95);
    
    [self createImage];
    return self;
}

- (void)createImage{
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width,self.frame.size.height)];
    [self addSubview:_scroll];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scroll addSubview:_imageView];
    
    _scroll.contentSize = _imageView.frame.size;
    _scroll.showsVerticalScrollIndicator=NO;
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.delegate = self;
    _scroll.minimumZoomScale = 1;
    _scroll.maximumZoomScale = 2;
    
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
//    tapGesture.numberOfTapsRequired=2;
//    [_scroll addGestureRecognizer:tapGesture];
//    
//    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
//    tapGesture1.numberOfTapsRequired=1;
//    [_scroll addGestureRecognizer:tapGesture1];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [_scroll addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [_scroll addGestureRecognizer:doubleTap];
    //这句代码是关键，当系统检测不到双击手势时执行再识别单击手势
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    
    

}


//单击手势事件
- (void)singleTap:(UITapGestureRecognizer*)gesture{
    if (self.hiddenView) {
        self.hiddenView();
    }
}
//双击手势事件
- (void)doubleTap:(UITapGestureRecognizer*)gesture{
    if(_scroll.zoomScale > 1.0){
        
        [_scroll setZoomScale:1.0 animated:YES];
    }else{
        [_scroll setZoomScale:2.0 animated:YES];
    }
}
- (void)back{
    
    if (self.hiddenView) {
        self.hiddenView();
    }
}
-(void)handleTapGesture:(UIGestureRecognizer*)sender{
    if(_scroll.zoomScale > 1.0){
        
        [_scroll setZoomScale:1.0 animated:YES];
    }else{
        [_scroll setZoomScale:2.0 animated:YES];
    }

}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}
- (void)setWithImage:(UIImage *)image{
    [_imageView setImage:image];

}

@end
