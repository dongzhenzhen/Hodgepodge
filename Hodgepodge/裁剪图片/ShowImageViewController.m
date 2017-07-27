//
//  ShowImageViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/12.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "ShowImageViewController.h"
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define TOP (SCREEN_HEIGHT-220)/2
#define LEFT (SCREEN_WIDTH -220)/2
#define kScanRect CGRectMake(LEFT,TOP,220,220)
@interface ShowImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    self.imageView.backgroundColor = [UIColor blueColor];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0);
    //渲染截图
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //获取新图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    self.imageView.image = newImage;
    //写入手机内存
    NSData *data = UIImagePNGRepresentation(newImage);
    NSArray *paths
    =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    [data writeToFile:path atomically:YES];
    UIGraphicsEndImageContext();
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
