//
//  ViewController.m
//  Hodgepodge
//
//  Created by 董真真 on 2017/7/19.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "ViewController.h"

#import "SecondViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FlowViewController.h"
//间距
#define CCP_Margin 5.0f
//每排显示的个数
#define CCP_count 3
//屏幕宽度
#define CCPScreenW  [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<testDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSDictionary *dictionary;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"source" ofType:@"plist"];
    self.dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"xxxxxxxxxxxx");
    UICollectionViewFlowLayout *loyout = [[UICollectionViewFlowLayout alloc]init];
    loyout.minimumLineSpacing = 10;
    loyout.minimumInteritemSpacing = 0;
    CGFloat w = (CCPScreenW - (CCP_count + 1)*CCP_Margin)/CCP_count;
    loyout.itemSize = CGSizeMake(w, w);
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:loyout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [_collectionView reloadData];
    [self.view addSubview:_collectionView];
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    label.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:label];
    label.text = self.dictionary.allKeys[indexPath.row];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = [UIColor blackColor];
    return cell;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(2, 2, 2, 2);
//}
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dictionary.allKeys.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 50);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *stringClass = [self.dictionary valueForKey:self.dictionary.allKeys[indexPath.row]];
    UIViewController *conVC = [[NSClassFromString(stringClass) alloc]init];
//    FlowViewController *viewC = [[FlowViewController alloc]init];
    [self.navigationController pushViewController:conVC animated:YES];
//    [self presentViewController:viewC animated:YES completion:nil];
}

- (void)buttonClick{
    __weak typeof(&*self) weakSelf = self;
    SecondViewController *second = [[SecondViewController alloc]init];
    if (second.colorB) {
        second.colorB = ^(UIColor *color) {
            weakSelf.view.backgroundColor = color;
        };
    }
    second.delegate = self;
    [self.navigationController pushViewController:second animated:NO];
    
    
}
- (void)changeBackGroundColor{
    [self.navigationController popViewControllerAnimated:YES
     ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

