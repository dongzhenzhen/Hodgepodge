//
//  FaceViewController.m
//  Hodgepodge
//
//  Created by 董真真 on 2017/7/25.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "FaceViewController.h"
#import <CoreImage/CoreImage.h>
#import "CameraController.h"
//#define imageName   [NSString stringWithFormat:@"face-%d",_imageTag]
@interface FaceViewController ()
@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, assign) int imageTag;

@property (nonatomic,strong)UILabel *label;
@end

@implementation FaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 200)];
    [self.view addSubview:self.imageView];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 360, 50, 30)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchDown];
    self.imageTag = 1;
    NSString *imageName = [NSString stringWithFormat:@"face-%d.jpg",self.imageTag];
    
    self.imageView.image = [UIImage imageNamed:imageName];
    [self faceDetectWithImage:[UIImage imageNamed:imageName]];
}
- (void)next:(id)sender{
    CameraController *camrea = [[CameraController alloc]init];
    
    [self.navigationController pushViewController:camrea animated:YES];
}
- (void)faceDetectWithImage:(UIImage *)image{

   //图像识别能力：可以在CIDetectorAccuracyHigh(较强的处理能力)与CIDetectorAccuracyLow(较弱的处理能力)中选择，因为想让准确度高一些在这里选择CIDetectorAccuracyHigh
    NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    //将图像转换为CIImage
    CIImage *faceImage = [CIImage imageWithCGImage:image.CGImage];
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    //识别出人脸数组
    NSArray *features = [faceDetector featuresInImage:faceImage];
    //得到图片的尺寸
    CGSize inputImageSize = [faceImage extent].size;
    //将image沿y轴对称
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    //将图片上移
    transform = CGAffineTransformTranslate(transform, 0,-inputImageSize.height);
    //取出所有脸
    for (CIFaceFeature *faceFeature in features) {
        //获取人脸的frame
        CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
        CGSize viewSize = self.imageView.bounds.size;
        CGFloat scale = MIN(viewSize.width/inputImageSize.width, viewSize.height/inputImageSize.height);
        CGFloat offsetX = (viewSize.width - inputImageSize.width * scale)/2;
        CGFloat offsetY = (viewSize.height - inputImageSize.height * scale)/2;
        //缩放
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        //修正
        faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, scaleTransform);
        faceViewBounds.origin.x += offsetX;
        faceViewBounds.origin.y += offsetY;
        //描绘人脸区域
        UIView *faceView = [[UIView alloc]initWithFrame:faceViewBounds];
        faceView.layer.borderWidth = 2;
        faceView.layer.borderColor = [[UIColor yellowColor]CGColor];
        [self.imageView addSubview:faceView];
        //判断是否有左眼位置
        if (faceFeature.hasLeftEyePosition) {
            
        }if (faceFeature.hasRightEyePosition) {
            
        }if (faceFeature.hasMouthPosition) {
        
        }
    }
}
@end
