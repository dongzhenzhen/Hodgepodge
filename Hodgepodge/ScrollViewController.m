//
//  ScrollViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/6/16.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "ScrollViewController.h"
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ScrollViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ScrollViewController{
    NSInteger _currentPage;
    NSInteger _wholePages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _wholePages = 6;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = scrollView;
    [self.view addSubview:self.scrollView];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    
    scrollView.contentOffset = CGPointMake(_currentPage * WIDTH, 0);
    scrollView.contentSize = CGSizeMake(3 * WIDTH, HEIGHT);
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%02d.jpg",i]];
        CGFloat imgW = imageView.image.size.width;
        CGFloat imgH = imageView.image.size.height;
        
        imageView.frame = CGRectMake(0,0, imgW, imgH);
        [scrollView addSubview:imageView];
    }
    
}
- (void)refreshData{
    [self updateSubImageView:(_currentPage - 1) with:0];
    [self updateSubImageView:_currentPage with:1];
    [self updateSubImageView:(_currentPage + 1) with:2];
}
- (void)updateSubImageView:(NSInteger)imageName with:(NSInteger)index{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%02ld.jpg",((imageName + _wholePages)%_wholePages)]];
    UIImageView *imageView = self.scrollView.subviews[index];
    imageView.image = image;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger subViewIndex = scrollView.contentOffset.x / WIDTH;
    switch (subViewIndex) {
        case 0:{
            _currentPage = ((_currentPage - 1) % _wholePages);
            [self refreshData];
        }
            break;
        case 2:{
            _currentPage = ((_currentPage + 1) % _wholePages);
            [self refreshData];
        }
            break;
        default:
            break;
    }
    [self.scrollView setContentOffset:CGPointMake(WIDTH, 0)];
}
@end
