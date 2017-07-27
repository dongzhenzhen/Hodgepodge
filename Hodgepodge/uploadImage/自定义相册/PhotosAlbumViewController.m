//
//  PhotosAlbumViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/13.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "PhotosAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "PhotosCellViewController.h"
@interface PhotosAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
//代表整个设备中的资源库（照片库），通过 AssetsLibrary 可以获取和包括设备中的照片和视频
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
//相册数组
@property (nonatomic, strong) NSMutableArray *albumArray;
//相册名数组
@property (nonatomic, strong) NSMutableArray *albumNameArray;
//照片数组
@property (nonatomic, strong) NSMutableArray *photoArray;
//封面图片数组，取的是照片数组中的第一张
@property (nonatomic, strong) NSMutableArray *posterImageArray;

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation PhotosAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.albumArray = [[NSMutableArray alloc]init];
    self.albumNameArray = [[NSMutableArray alloc]init];
    self.posterImageArray = [[NSMutableArray alloc]init];
    self.photoArray = [[NSMutableArray alloc]init];
    if ([self iosIsBefore_ios8]) {
        [self iosBefore_ios8];
    }else{
        [self iosAfter_ios8];
    }
    [self setUpSubViews];
}
- (void)setUpSubViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    self.tableView.rowHeight = 80;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumNameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.albumNameArray[indexPath.row];
    cell.imageView.image = self.posterImageArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotosCellViewController *photoCell = [[PhotosCellViewController alloc]init];

    if ([self iosIsBefore_ios8]) {
        [self iosSelectBefore_ios8:indexPath.row];
        photoCell.isBeforeIOS8 = YES;
    }else{
        photoCell.fatchResult = self.albumArray[indexPath.row];
        photoCell.isBeforeIOS8 = NO;
    }
    
      
    [self.navigationController pushViewController:photoCell animated:YES];
}
//判断系统版本
- (BOOL)iosIsBefore_ios8{
     return [[[UIDevice currentDevice] systemVersion] floatValue] <= 8.0 ?1:0;
}
//系统版本 < 8.0
- (void)iosBefore_ios8{
    NSString *tipTitle = nil;
//相册的访问权限
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    /**
     *ALAuthorizationStatusDenied   用户已拒绝该应用程序访问照片数据
     ALAuthorizationStatusRestricted    这个应用程序没有被授权访问照片数据
     ALAuthorizationStatusAuthorized  有权限访问
     ALAuthorizationStatusNotDetermined     用户还没有做出选择这个应用程序的问候
     
     */
    if (authorizationStatus == ALAuthorizationStatusDenied || authorizationStatus == ALAuthorizationStatusRestricted) {
        NSDictionary *mainDictionAry = [[NSBundle mainBundle]infoDictionary];
        //获取当前APP文件名
        NSString *myAppName = [mainDictionAry objectForKey:@"CFBundleDisplayName"];
        tipTitle = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册",myAppName];
    }else{
        //遍历资源库获取相册
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //遍历所有相册列表，并把相册中资源不为空的相册ALAssetsGroup对象的引用储存到一个数组中
        if (group) {
         //设置过滤器，控制只获取相册中的照片或者只获取视频
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (group.numberOfAssets > 0) {
                //把相册储存到数组中，方便后面展示相册时使用
                [self.albumArray addObject:group];
                //把各个不同的相册所对应的名字存入数组
                [self.albumNameArray addObject:[group valueForProperty:ALAssetsGroupPropertyName]];
                //获取相册封面图
                UIImage *posterImage = [UIImage imageWithCGImage:[group posterImage]];
                //相册封面放到封面数组组
                [self.posterImageArray addObject:posterImage];
            }
        }else{
            if (self.albumArray.count > 0) {
                //所有的相册储存完毕，可以展示相册列表
            }else{
            
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Asset group not found!\n");
    }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}
- (void)iosSelectBefore_ios8:(NSInteger )tag{
    [self.photoArray removeAllObjects];
    if (self.albumArray.count > 0) {
        [self.albumArray[tag] enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                ALAssetRepresentation *representation = [result defaultRepresentation];
                UIImage *contentImage = [UIImage imageWithCGImage:[representation fullScreenImage]];
                [self.photoArray addObject:contentImage];
            }else{
            
            }
        }];
    }
}
- (void)iosSelectAfter_ios8:(NSInteger )tag{
    }
- (void)iosAfter_ios8{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle]infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *alerString = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"%@",alerString);
            
        });
    }else{
        //获取资源时的参数，可以传 nil，即使用系统默认值
        PHFetchOptions *option = [[PHFetchOptions alloc]init];
        //排序方式
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
        //列出所有相册智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
            //获取一个相册（PHAssetCollection）
            PHCollection *collection = smartAlbums[i];
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                //从每一个智能相册中获取到的PHFetchResult中包含的才是真正的资源（PHAsset）
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                if (fetchResult.count > 0) {
                    [self.albumArray addObject:fetchResult];
                    [self.albumNameArray addObject:assetCollection.localizedTitle];
                    PHAsset *asset = (PHAsset *)fetchResult.firstObject;
                    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
                    // 默认的是异步加载,这里选择了同步 因为只获取一张照片，不会对界面产生很大的影响
                    options.synchronous = YES;
                    [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        //获取封面图片
                        [self.posterImageArray addObject:result];
                    }];
                }
            }else{
                NSAssert(NO, @"Fetch collection not PHCollection:%@",collection);
            }
        }
        //在主线程更新UI界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}
@end
