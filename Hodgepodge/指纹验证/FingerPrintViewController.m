//
//  FingerPrintViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/19.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "FingerPrintViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface FingerPrintViewController ()
@property (nonatomic, strong) UIButton *touchBtn;
@end

@implementation FingerPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.touchBtn setTitle:@"指纹验证" forState:UIControlStateNormal];
    [self.touchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.touchBtn];
    self.touchBtn.frame = CGRectMake(100, 300, 100, 50);
    [self.touchBtn addTarget:self action:@selector(touchBtnBeginSure:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)touchBtnBeginSure:(UIButton *)sender{
    LAContext *context = [[LAContext alloc]init];
    NSError *error = nil;
    //首先使用canEvaluatePolicy判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [self setAlertViewWithTitle:@"验证成功"];
            }else{
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        [self setAlertViewWithTitle:@"系统取消验证"];
                    }
                        break;
                    case LAErrorUserCancel:{
                        [self setAlertViewWithTitle:@"用户取消验证"];
                    }
                        break;
                    case LAErrorUserFallback:{
                        [self setAlertViewWithTitle:@"用户选择其他验证方式，切换主线程处理"];
                    }
                        break;
                        
                    default:{
                        [self setAlertViewWithTitle:@"其他情况"];
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            
                        }];
                    }
                        break;
                }
            }
        }];
    }else{
    //不支持指纹识别，LOG错误详情
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                [self setAlertViewWithTitle:@"未开启指纹识别"];
            }
                break;
            case LAErrorPasscodeNotSet:{
                [self setAlertViewWithTitle:@"未设置密码"];
            }
                break;
            default:{
                [self setAlertViewWithTitle:@"TouchID 无效"];
            }
                break;
        }
    }
}
- (void)setAlertViewWithTitle:(NSString *)str{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}
@end
