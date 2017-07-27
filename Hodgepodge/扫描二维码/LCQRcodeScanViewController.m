//
//  LCQRcodeScanViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/6/15.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "LCQRcodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define TOP (SCREEN_HEIGHT-220)/2
#define LEFT (SCREEN_WIDTH -220)/2
#define kScanRect CGRectMake(LEFT,TOP,220,220)
@interface LCQRcodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer *timer;
    CAShapeLayer *cropLayer;
}
@property (nonatomic, strong) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureDeviceInput *input;

@property (nonatomic, strong) AVCaptureMetadataOutput *output;

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) UIImageView *line;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@end

@implementation LCQRcodeScanViewController{
    BOOL on;
    UIButton *openButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    on = YES;
    [self configView];
    
}
- (void)configView{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    openButton = [[UIButton alloc]initWithFrame:CGRectMake(LEFT, 500, 100, 50)];
    [openButton setTitle:@"开灯" forState:UIControlStateNormal];
  
    [self.view addSubview:openButton];
    [openButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(turnTorchOn) forControlEvents:UIControlEventTouchUpInside];
    
    upOrdown = NO;
    num = 0;
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT, TOP+10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}
- (void) turnTorchOn{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]) {
            [device lockForConfiguration:nil];
            if (on) {
                
                [device setTorchMode:AVCaptureTorchModeOn];
               
                 [openButton setTitle:@"关灯" forState:UIControlStateNormal];
                on = NO;
            }else{
                [device setTorchMode:AVCaptureTorchModeOff];
                 [openButton setTitle:@"开灯" forState:UIControlStateNormal];
                on = YES;
            }
            [device unlockForConfiguration];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [self setCropRect:kScanRect];
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
}
- (void)animation1{
    if (upOrdown == NO) {
        num++ ;
        _line.frame = CGRectMake(LEFT, TOP + 10 + 2*num, 220, 2);
        if (2*num == 220) {
            upOrdown = YES;
        }
    }else{
        num--;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}
- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc]init];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddRect(context, cropRect);
//    CGContextAddRect(context, self.view.bounds);
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
-(void)setupCamera{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    //Device获取摄像设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    _output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理在主线程里刷新
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描区域  （若不需要限制扫描区域，rectOfInterest不需要设置，此demo限制扫描区域宽高为）
    ///top 与 left 互换  width 与 height 互换 此处坐标不是传统意义上的坐标，而为比例关系的坐标，数值在[0,1]区间
    //    坐标原点为右上角，x,y,width,height坐标互换，也就是说设置此处坐标时，应为( y , x , height , width)
    //    这个CGRect参数和普通的Rect范围不太一样，它的四个值的范围都是0-1，表示比例。
    //    rectOfInterest都是按照横屏来计算的 所以当竖屏的情况下 x轴和y轴要交换一下。
    //    宽度和高度设置的情况也是类似。

    CGFloat top = TOP/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = 220/SCREEN_WIDTH;
    CGFloat height = 220/SCREEN_HEIGHT;
    
    [_output setRectOfInterest:CGRectMake(top, left, height, width)];
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    //条码类型 AVMetadataObjectTypeQRCode 设置扫码支持的编码格式（设置条形码与二维码兼容）
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,
                                     AVMetadataObjectTypeEAN8Code,
                                     AVMetadataObjectTypeCode128Code, nil]];
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    //开始捕获
    [_session startRunning];
    
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if ([metadataObjects count] > 0) {
        //停止扫描
        [_session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:stringValue preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (_session != nil && timer != nil) {
                [_session startRunning];
                [timer setFireDate:[NSDate date]];
            }
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:@"无扫描信息" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            return ;
//        }]];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
