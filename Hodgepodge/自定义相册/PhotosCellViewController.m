//
//  PhotosCellViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/14.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "PhotosCellViewController.h"
#import "PhotoCollectionViewCell.h"
#import "DetailImageViewController.h"
//间距
#define CCP_Margin 5.0f
//每排显示的个数
#define CCP_count 3
//屏幕宽度
#define CCPScreenW  [UIScreen mainScreen].bounds.size.width

@interface PhotosCellViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PhotosCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 3;
        CGFloat w = (CCPScreenW - (CCP_count - 1)*CCP_Margin)/CCP_count;
        flowLayout.itemSize = CGSizeMake(w, w);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
//        _collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
//        [_collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    }
    return _collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.iamgeArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    cell.cellImageView.image = self.iamgeArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tag = indexPath.item;
    DetailImageViewController *detail = [[DetailImageViewController alloc]init];
    [detail.imageArray addObjectsFromArray:self.iamgeArray];
    detail.tag = tag;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)setFatchResult:(PHFetchResult *)fatchResult{
    
    [self.iamgeArray removeAllObjects];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeNone;// 属性控制图像的剪裁，不知道为什么 PhotoKit 会在请求图像方法（requestImageForAsset）中已经有控制图像剪裁的参数后（contentMode），还在 options 中加入控制剪裁的属性，但如果两个地方所控制的剪裁结果有所冲突，PhotoKit 会以 resizeMode 的结果为准
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;//则用于控制请求的图片质量
    for (int i = 0; i < fatchResult.count; i++) {
        PHAsset *asset = fatchResult[i];
        [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:CGSizeMake(125, 125) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [self.iamgeArray addObject:result];
            //主线程中更新UI
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
        }];
    }

}
- (NSMutableArray *)iamgeArray{
    if (!_iamgeArray) {
        _iamgeArray = [[NSMutableArray alloc]init];
    }
    return _iamgeArray;
}
@end
