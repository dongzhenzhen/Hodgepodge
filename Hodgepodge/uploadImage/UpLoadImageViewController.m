//
//  UpLoadImageViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/7.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "UpLoadImageViewController.h"
#import <Photos/Photos.h>
#import "CameraHeleper.h"
#define frame [UIScreen mainScreen].bounds
@interface UpLoadImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)CameraHeleper *heleper;

@end

@implementation UpLoadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionView];
    
}
- (void)setCollectionView{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 10;
    layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layOut];
    layOut.itemSize = CGSizeMake(90, 90);
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.heleper = [CameraHeleper shareHeleper];
    [self.heleper getAlbum];
    [self.heleper isAuthoritys];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.heleper.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.heleper.imageArray[indexPath.row]];
    [cell.contentView addSubview:imageView];
    return cell;
}
@end
