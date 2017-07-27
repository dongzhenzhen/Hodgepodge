//
//  CustomWaterflowlayout.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/18.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "CustomWaterflowlayout.h"
/**
 *  默认的列数
 */
static const NSInteger CustomDefaultColumnCount = 3;
//每一列之间的间距
static const CGFloat CustomDefaultColumnMargin = 10;
//每一行之间的间距
static const CGFloat CustomDefaultRowMargin = 10;
//边缘间距
static const UIEdgeInsets CustomDefaultEdgeInsets = {10,10,10,10};
@interface CustomWaterflowlayout()
//存放cell的布局属性
@property (nonatomic, strong)NSMutableArray *attrsArray;
//存放所有列的当前高度
@property (nonatomic, strong) NSMutableArray *columnHeights;

//每一行之间的间距
- (CGFloat)rowMargin;
//每一列之间的间距
- (CGFloat)columnMargin;
//列数
- (NSInteger)columnCount;
//边缘间距
- (UIEdgeInsets)edgeInsets;

@end
@implementation CustomWaterflowlayout

- (CGFloat)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    }else{
        return CustomDefaultRowMargin;
    }
}
- (CGFloat)columnMargin{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
     return  [self.delegate columnMarginInWaterflowLayout:self];
    }else{
        return CustomDefaultColumnMargin;
    }
}
- (NSInteger)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return   [self.delegate columnCounInWaterflowLayout:self];
    }else{
        return CustomDefaultColumnCount;
    }
    
}
-(UIEdgeInsets)edgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
       return [self.delegate edgeInsetsInWaterflowLayout:self];
    }else{
        return CustomDefaultEdgeInsets;
    }
}
- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [[NSMutableArray alloc]init];
    }
    return _columnHeights;
}
- (NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc]init];
    }
    return _attrsArray;
}
//每次刷新都会调用
-(void)prepareLayout{
    [super prepareLayout];
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    //清除之前所有的布局
    [self.attrsArray removeAllObjects];
    //获取cell的个数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    // 遍历cell，把每一个布局添加到数组
    for (NSInteger i = 0; i < count; i++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attrs];
        
    }
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat x,y,w,h;
    w = (self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin)/ self.columnCount;
    //通过代理可以设置高度
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:heightForItemAtIndex:itemWidth:)]) {
        h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath itemWidth:w];
    }else{
        h = 70 + arc4random_uniform(100);
    }
    //取得所有列中高度最短的列（第几列)
    NSInteger minHeightColumn = [self minHeightColumn];
    x = self.edgeInsets.left + minHeightColumn * (w + self.columnMargin);
    //[self.columnHeights[minHeightColumn]floatValue]获取高度
    y = CustomDefaultEdgeInsets.top + [self.columnHeights[minHeightColumn]floatValue];
#warning 更改最短的一列
    [self.columnHeights replaceObjectAtIndex:minHeightColumn withObject:@(y + h)];
    attrs.frame = CGRectMake(x, y, w, h);
    return attrs;
    
}
//1.返回rect中的所有元素的布局属性  2.返回的是包含UICollectionViewLayoutAttributes的NSArray 3.  UICollectionViewLayoutAttributes可以是cell，追加视图或者装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSLog(@"%s",__func__);
    return self.attrsArray;
}
//返回collectionView的内容的尺寸
- (CGSize)collectionViewContentSize{
    if (self.columnHeights.count == 0) {
        return CGSizeMake(0, 0);
    }
    //获取最高列
    NSInteger maxColum = [self maxHeightColumn];
    CGFloat height = [self.columnHeights[maxColum] floatValue] + CustomDefaultEdgeInsets.bottom;
    CGFloat width = self.collectionView.frame.size.width;
    return CGSizeMake(width, height);
}
//获取列中高度最短的列
- (NSInteger)minHeightColumn{
//找出columnHeights的最小值
    NSInteger minHeightColum = 0;
    CGFloat minColumHeight = [self.columnHeights[0] floatValue];
    for (NSInteger i = 1; i < self.columnHeights.count; i++) {
        CGFloat tempHeight = [self.columnHeights[i] floatValue];
        if (tempHeight < minColumHeight) {
            minHeightColum = i;
            minColumHeight = tempHeight;
        }
    }
    return minHeightColum;
}
//获取列中高度最高的列
- (NSInteger)maxHeightColumn{
    NSInteger maxHeightColum = 0;
    CGFloat maxColumHeight = [self.columnHeights[0] floatValue];
    for (NSInteger i = 1; i < self.columnHeights.count; i++) {
        CGFloat tempHeight = [self.columnHeights[i] floatValue];
        if (tempHeight > maxColumHeight) {
            maxColumHeight = tempHeight;
            maxHeightColum = i;
        }
    }
    return maxColumHeight;
}
@end
