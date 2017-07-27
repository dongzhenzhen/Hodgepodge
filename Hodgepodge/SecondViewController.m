//
//  SecondViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/6/15.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "SecondViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface SecondViewController ()

@end

@implementation SecondViewController
+(void)load{
    NSLog(@"loadloadload");
}
+ (void)initialize{
    NSLog(@"initialize");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
   
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 300, 50, 50)];
    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchDown];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {

        if ([self.delegate respondsToSelector:@selector(changeBackGroundColor)]) {
            [self.delegate changeBackGroundColor];
        }
    }];
    [self.view addGestureRecognizer:tap];
}
- (void)buttonClick{
   
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    
    
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
