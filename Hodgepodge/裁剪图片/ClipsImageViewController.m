//
//  ClipsImageViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/11.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "ClipsImageViewController.h"
#import "ShowImageViewController.h"
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define TOP (SCREEN_HEIGHT-220)/2
#define LEFT (SCREEN_WIDTH -220)/2
#define kScanRect CGRectMake(LEFT,TOP,220,220)
@interface ClipsImageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *imageScrollView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGPoint point;
@end

@implementation ClipsImageViewController{
    CAShapeLayer *cropLayer;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.imageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT );
    self.imageScrollView.contentInset = UIEdgeInsetsMake(TOP- 64, LEFT, TOP, LEFT);
    self.imageScrollView.maximumZoomScale = 2.0;
    self.imageScrollView.minimumZoomScale = 0.5;
    self.imageScrollView.delegate = self;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.imageScrollView];
    self.imageView = imageView;
    [self.imageScrollView addSubview:self.imageView];
    
    imageView.image = [UIImage imageNamed:@"image000.jpg"];
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(LEFT, SCREEN_HEIGHT - 100, 50, 30)];
    [sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sureButton];
    
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"xxxxxxx%f yyyyyy%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)sureAction{
    //kScanRect.size 要截取成功后的图片的大小 NO不透明 0缩放比0
    UIGraphicsBeginImageContextWithOptions(kScanRect.size, NO, 0.0);
    //drawInRect 在指定的范围内
    [self.imageView.image drawInRect:CGRectMake((self.imageView.frame.origin.x - self.imageScrollView.contentOffset.x - LEFT), (self.imageView.frame.origin.y - self.imageScrollView.contentOffset.y - TOP) , self.imageView.frame.size.width, self.imageView.frame.size.height)];
    
    //获取新图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束新图
    UIGraphicsEndImageContext();
    ShowImageViewController *show = [[ShowImageViewController alloc]init];
    show.image = newImage;
    [self.navigationController pushViewController:show animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [self setCropRect:kScanRect];
    UIImage *bgImage = [UIImage imageNamed:@"image000.jpg"];
    
    //创建图形上下文
    UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, 0);
    [bgImage drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    UIImage *waterIma = [UIImage imageNamed:@"map_site_1Cur"];
    [waterIma drawInRect:CGRectMake(self.imageView.frame.size.width - 40 - 20, self.imageView.frame.size.height - 40 - 20, 13, 17)];
    //获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文
    UIGraphicsEndImageContext();
    self.imageView.image = newImage;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [cropLayer removeFromSuperlayer];
}
- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc]init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];//利用layer的FillRule属性生成一个空心的layer
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];//透明度，CALayer中的透明度使用opacity 中心点使用position   anchorPoint属性是图层的锚点，，永远可以同position重合，
    [cropLayer setNeedsDisplay];
    [self.view.layer addSublayer:cropLayer];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
