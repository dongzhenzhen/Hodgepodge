//
//  CameraController.m
//  Hodgepodge
//
//  Created by 董真真 on 2017/7/26.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "CameraController.h"

@interface CameraController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@end

@implementation CameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePicker.delegate = self;
    self.imageView.frame = CGRectMake(20, 100, self.view.frame.size.width - 40, 200);
    [self.view addSubview:self.imageView];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 360, 50, 30)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(openCarema:) forControlEvents:UIControlEventTouchDown];
}
- (void)openCarema:(id)sender{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要真机运行，才能打开相机" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else{
        _imagePicker.allowsEditing = false;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}
- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
    }
    return _imagePicker;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self faceDetect];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)faceDetect{
    NSDictionary *imageOptions = [NSDictionary dictionaryWithObject:@(5) forKey:CIDetectorImageOrientation];
    CIImage *personciImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    NSArray *features = [faceDetector featuresInImage:personciImage options:imageOptions];
    if (features.count > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到了人脸" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        CIImage *faceImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
        CGSize inputImageSize = [faceImage extent].size;
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
        //将图片上移
        transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
        //取出所有人脸
        for (CIFaceFeature *faceFeature in features) {
            //获取人脸的frame
            CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
            CGSize viewSize = self.imageView.bounds.size;
            CGFloat scale = MIN(viewSize.width / inputImageSize.width,
                                viewSize.height / inputImageSize.height);
            CGFloat offsetX = (viewSize.width - inputImageSize.width * scale) / 2;
            CGFloat offsetY = (viewSize.height - inputImageSize.height * scale) / 2;
            // 缩放
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
            // 修正
            faceViewBounds = CGRectApplyAffineTransform(faceViewBounds,scaleTransform);
            faceViewBounds.origin.x += offsetX;
            faceViewBounds.origin.y += offsetY;
            //描绘人脸区域
            UIView *faceView = [[UIView alloc]initWithFrame:faceViewBounds];
            faceView.layer.borderColor =[ UIColor yellowColor].CGColor;
            faceView.layer.borderWidth = 1;
            [self.imageView addSubview:faceView];
        }
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未监测到人脸" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
