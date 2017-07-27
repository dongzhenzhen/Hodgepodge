//
//  FlowViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/18.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "FlowViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "myFlowLayout.h"
#import "FlowCell.h"
#import "Photos.h"
#import <MJExtension/MJExtension.h>
#import "UIImageView+WebCache.h"
#import "MGWaterflowLayout.h"
@interface FlowViewController ()<MGWaterflowLayoutDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic,strong) NSArray *itemArray;
@end

@implementation FlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < 10; i++) {
        [self.photoArray addObject:[NSString stringWithFormat:@"image%.2d.jpg",i]];
    
    }
    self.itemArray = @[@(1.416321),@(0.731667),@(0.533333),@(1.250000),@(1.362500),@(0.665000),@(1.998333),@(0.800601),@(0.500000),@(0.800000),@(1.250000),@(0.665000),@(0.704750),@(1.000000),@(1.523611),@(1.000000),@(0.625000),@(1.250000),@(0.704750)];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.photoArray removeAllObjects];
//     NSArray *PhotosArray = [Photos mj_objectArrayWithFilename:@"1.plist"];
//    [self.photoArray addObjectsFromArray:PhotosArray];
   
    [self setUpLayout];
//     [self.collectionView reloadData];
//    [self setupRefresh];
//    [self.collectionView.mj_header beginRefreshing];
}
- (void)setUpLayout{
    MGWaterflowLayout *flowLayout = [[MGWaterflowLayout alloc]init];
    flowLayout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
  
//    [collectionView registerNib:[UINib nibWithNibName:@"FlowCell" bundle:nil] forCellWithReuseIdentifier:@"FlowCell"];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FlowCell class]) bundle:nil] forCellWithReuseIdentifier:@"FlowCell"];
    
    self.collectionView = collectionView;
    [self.collectionView reloadData];
    [self.view addSubview:self.collectionView];
   
    
    
}
- (void)setupRefresh{
    // 上拉刷新
    self.collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *shops = [Photos mj_objectArrayWithFilename:@"1.plist"];
            [self.photoArray removeAllObjects];
            [self.photoArray addObjectsFromArray:shops];
            
            // 刷新数据
            [self.collectionView reloadData];
            
            [self.collectionView.mj_header endRefreshing];
        });
    }];
    
    // 下拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *shops = [Photos mj_objectArrayWithFilename:@"1.plist"];
            [self.photoArray addObjectsFromArray:shops];
            
            // 刷新数据
            [self.collectionView reloadData];
            
            [self.collectionView.mj_footer endRefreshing];
        });
    }];
    
    self.collectionView.mj_footer.hidden = YES;
}
#pragma mark -<UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
      self.collectionView.mj_footer.hidden = self.photoArray.count == 0;
    return self.photoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlowCell" forIndexPath:indexPath];
//    Photos *p = self.photoArray[indexPath.item];
//    NSURL *url = [NSURL URLWithString:p.imageUrl];
//    [cell.cellImageView sd_setImageWithURL:url];
    NSString *imageN = self.photoArray[indexPath.item];
    cell.cellImageView.image = [UIImage imageNamed:imageN];
    return cell;
}

#pragma mark -<CustomWaterflowlayoutDelegate>
- (CGFloat)waterflowLayout:(myFlowLayout *)waterflowLayout heightForItemAtIndex:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
//    Photos *photo = self.photoArray[indexPath.item];
//    
//    return itemWidth *  photo.height/ photo.width;
    UIImage *image = self.photoArray[indexPath.item];
    return itemWidth *2;
//    CGFloat he = self.itemArray[indexPath.item];
//    return itemWidth * image.size.height/image.size.width;
}

- (CGFloat)rowMarginInWaterflowLayout:(myFlowLayout *)waterflowLayout{

    return 10;
}
- (CGFloat)columnCounInWaterflowLayout:(myFlowLayout *)waterflowLayout{
    
    if (self.photoArray.count <= 50) return 2;
    return 3;
    
}
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(myFlowLayout *)waterflowLayout{
    return UIEdgeInsetsMake(10, 20, 30, 10);
}
- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc]init];
    }
    return _photoArray;
}

@end
