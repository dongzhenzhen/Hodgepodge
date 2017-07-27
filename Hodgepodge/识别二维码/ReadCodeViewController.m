//
//  ReadCodeViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/6.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "ReadCodeViewController.h"
#import <CoreImage/CoreImage.h>
@interface ReadCodeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *imageViewCode;

@end

@implementation ReadCodeViewController{
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(10, 100, 100, 30);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(myAlbum) forControlEvents:UIControlEventTouchDown];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"code"]];
    imageView.frame = CGRectMake(10, 150, 277, 277);
    imageView.userInteractionEnabled = YES;
//    [self.view addSubview:imageView];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
    [imageView addGestureRecognizer:recognizer];
    self.imageViewCode = [[UIImageView alloc]initWithFrame:CGRectMake(50, 150, 200, 200)];
    self.imageViewCode.backgroundColor = [UIColor redColor];
    [self create];
    [self.view addSubview:self.imageViewCode];
    self.imageViewCode.userInteractionEnabled = YES;
    [self.imageViewCode addGestureRecognizer:recognizer];
   self.textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 400, 200, 30)];
    [self.view addSubview:self.textField];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
    [self create];
}

//打开相册
- (void)myAlbum{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //相册拾取器
        UIImagePickerController *controller = [[UIImagePickerController alloc]init];
        //设置代理
        controller.delegate = self;
        //设置资源
        controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //一个转场动画
        controller.modalTransitionStyle = UIModalPresentationNone;
        [self presentViewController:controller animated:YES completion:NULL];
        
    }else{
    
    }
}
//imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //初始化一个监测器
    CIDetector *detetor = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    [picker dismissViewControllerAnimated:YES completion:^{
       //监测到的结果数组
        NSArray *features = [detetor featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >= 1) {
            /**
             *  结果对象
             */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:scannedResult preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil
                             ]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
//长按识别二维码
- (void)dealLongPress:(UIGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
//        _timer.fireDate = [NSDate distantFuture];
        UIImageView *tempImageView = (UIImageView *)gesture.view;
        if (tempImageView.image) {
            //初始化扫描仪 设置识别类型和识别质量
            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
            //扫描获取的特征组
            NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:tempImageView.image.CGImage]];
            //获取扫描结果
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedReslut = feature.messageString;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:scannedReslut preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        
        }
    }else if(gesture.state == UIGestureRecognizerStateEnded){
//        _timer.fireDate = [NSDate distantFuture];
//        [_timer invalidate];
    }
}
//生成二维码
- (void)create{

    
//创建过滤对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复默认设置
    [filter setDefaults];
    //设置数据
    NSString *str;
    if (self.textField.text.length == 0) {
        str = @"https://www.baidu.com";
        
    }else{
        str = self.textField.text;
    }
    NSData *infoData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:infoData forKey:@"inputMessage"];
    //生成二维码
    CIImage *outputImage = [filter outputImage];
    self.imageViewCode.image = [self createNonInterpolatedUIIamgeFormCIImage:outputImage withSize:200];
    
}
//生成清晰的二维码
/**
 *  根据CIImage生成指定大小的UIImage 生成清晰的二维码
 
 */
- (UIImage *)createNonInterpolatedUIIamgeFormCIImage:(CIImage *)image withSize:(CGFloat )size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), CGRectGetHeight(extent));
    //创建bitmap
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceCMYK();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    //保存bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
@end
