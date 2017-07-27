//
//  DetailImageViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/14.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "DetailImageViewController.h"

@interface DetailImageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong) UIScrollView *scrollview;
@end

@implementation DetailImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}

- (UIScrollView *)scrollview{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _scrollview.delegate = self;
        _scrollview.pagingEnabled = YES;
        //设置最大伸缩比
        _scrollview.maximumZoomScale = 2;
        //设置最小伸缩比
        _scrollview.minimumZoomScale = 0.5;
        
    }
    return _scrollview;
}
- (void)makeUI{
    self.imageArray = [[NSMutableArray alloc]init];
    self.scrollview.contentSize = CGSizeMake(self.imageArray.count * self.view.frame.size.width, self.view.frame.size.height);
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;//图片的填充方式
    [self.view addSubview:self.scrollview];
    [self.scrollview addSubview:self.imageView];
    
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{

}
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
