//
//  CameraHeleper.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/7.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "CameraHeleper.h"
#import <AssetsLibrary/AssetsLibrary.h>//iphone 中的资源库（包含所有的photo，video），可以这么认为AssetsLibrary带包Iphone中的相册应用，
#import <AssetsLibrary/ALAsset.h>// 对应相册中的一张照片或者视频，ALAsset包含了照片或视频的详细信息，可以通过ALAsset获取缩略图。另一方面可以使用ALAsset的实例方法保存照片或视频
#import <AssetsLibrary/ALAssetsGroup.h>//映射照片库AssetsLibrary的一个相册，通过ALAssetsGroup可以获取相册相应的信息，同时获取可以通过相册ALAssetsGroup获取相册下的资源，同时也在当前相册下保存资源
#import <AssetsLibrary/ALAssetRepresentation.h>//可以理解成是对ALAsset的封装（但不是其子类），可以更方便地获取 ALAsset 中的资源信息。通过ALAssetRepresentation可以获取原图、全屏图。每个 ALAsset 都有至少有一个 ALAssetRepresentation 对象，可以通过 defaultRepresentation 获取。而例如使用系统相机应用拍摄的 RAW + JPEG 照片，则会有两个 ALAssetRepresentation，一个封装了照片的 RAW 信息，另一个则封装了照片的 JPEG 信息。
//AssetsLibrary一般用于定制一个图片选择器，图片选择器相应的可以实现多选、自定义界面。相应的思路应该是：

//1.实例化照片库,列出所有相册
//2.展示相册中的所有图片
//3.对选图片或则点击图片预览大图。
#import <Photos/Photos.h>
#import "ImagModel.h"
@implementation CameraHeleper
+ (instancetype)shareHeleper{
    static CameraHeleper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CameraHeleper alloc]init];
    });
    return instance;
}
- (void)isAuthoritys{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机相册没有访问权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:action];
    }
}
//获取所有图片
- (void)getAlbum{
    
    //获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    NSArray *mediaType = @[@(PHAssetMediaTypeImage)];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@",mediaType];
    //获取相机胶卷所有图片
    PHFetchResult *assets = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsWithOptions:options];
    NSDictionary *dic = @{@"title":@"全部照片",@"fetchResult":assetsFetchResult};
    [self.imageArray addObject:dic];
    for (PHCollection *collection in assets) {
        if ([collection isKindOfClass:[PHAssetCollection class]] && ![collection.localizedTitle isEqualToString:@"Videos"]) {
            PHFetchOptions *options = [[PHFetchOptions alloc]init];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@",mediaType];
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            if (assetsFetchResult.count > 0) {
                NSDictionary *dic1 = @{@"title":assetCollection.localizedTitle,@"fetchResult":assetsFetchResult};
                [self.imageArray addObject:dic1];
            }
        }
    }
    /**
     *  设置显示设置
     PHImageRequestOptionsResizeModeNone  //选了这个就不会管传如的size了 ，要自己控制图片的大小，建议还是选Fast
     PHImageRequestOptionsResizeModeFast     //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像 
     PHImageRequestOptionsResizeModeExact     //精确的加载与传入size相匹配的图像 
     
//     */
//    option.resizeMode = PHImageRequestOptionsResizeModeFast;
//    option.synchronous = NO;
//    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//    
//    CGFloat scale = [UIScreen mainScreen].scale;
//    CGSize size = [UIScreen mainScreen].bounds.size;
//    typeof (self)weakSelf = self;
//    for (PHAsset *asset in assets) {
//        [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:CGSizeMake(size.width * scale, size.height * scale) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            ImagModel *model = [[ImagModel alloc]init];
//            model.localIdentifier = asset.burstIdentifier;
//            model.image = [UIImage imageWithData:UIImageJPEGRepresentation(result, 0.5)];
//            [weakSelf.imageArray addObject:model.image];
//            
//        }];
//    }
}
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
@end
