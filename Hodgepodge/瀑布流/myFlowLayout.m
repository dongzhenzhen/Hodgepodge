//
//  myFlowLayout.m
//  Hodgepodge
//
//  Created by 董真真 on 2017/7/21.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "myFlowLayout.h"
//默认的列数
static const NSInteger DefaultColumnCount = 3;
//每一列之间的间距
static const CGFloat DefaultColumnMargin = 10;
//每一行之间的间距
static const CGFloat DefaultRowMargin = 10;
//边缘间距
static const UIEdgeInsets DefaultEdgeInsets = {10,10,10,10};
@interface myFlowLayout()
//存放cell 的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;
//存放所有列的当前高度
@property (nonatomic, strong) NSMutableArray *columnHeights;
- (NSInteger)columnCount;
- (CGFloat)columnMargin;
- (UIEdgeInsets)edgeInsets;
@end
@implementation myFlowLayout
//列数
- (NSInteger)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
      return [self.delegate columnCountInWaterflowLayout:self];
    }else{
        return DefaultColumnCount;
    }
}
//行间距
- (CGFloat)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
    return [self.delegate rowMarginInWaterflowLayout:self];
    }else{
        return DefaultRowMargin;
    }
}

//列间距
- (CGFloat)columnMargin{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
       return [self.delegate columnMarginInWaterflowLayout:self];
    }else{
        return DefaultColumnMargin;
    }
}
- (UIEdgeInsets)edgeInsets{

    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
     return [self.delegate edgeInsetsInWaterflowLayout:self];
        
    }else{
        return DefaultEdgeInsets;
    }
}








- (NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc]init];
    }
    return _attrsArray;
}
- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [[NSMutableArray alloc]init];
    }
    return _columnHeights;
}
- (void)prepareLayout{
    [super prepareLayout];
    //清除之前所有的高度
    [self.columnHeights removeAllObjects];
    //清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    
    for (NSInteger i = 0; i < self.columnCount; i ++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
        
    }
    //获取cell的个数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //遍历cell把每个布局添加到数组中
    for (NSInteger i = 0; i < count; i++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];//获取每个cell的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
    
}
//创建布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat x,y,w,h;
    w = (self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin)/self.columnCount;
    //通过代理可以设置高度
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:heightForItemAtIndex:itemWidth:)]) {
       h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath itemWidth:w];
    }else{
        h = 70 + arc4random_uniform(100);
    }
    //取得所有列中高度最短的列
    NSInteger minHeightColumn = [self maxHeightColumn];
    x = self.edgeInsets.left + minHeightColumn * (w + self.columnMargin);
    y = self.edgeInsets.top + [self.columnHeights[minHeightColumn]floatValue];
    //更改为最短的列
    [self.columnHeights replaceObjectAtIndex:minHeightColumn withObject:@(y+h)];
    attrs.frame = CGRectMake(x, y, w, h);
    return attrs;
}
//决定cell的排布，第一次显示时会调用一次，用力拖拽时也会调用一次
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}
//设置collectionView的滚动范围
- (CGSize)collectionViewContentSize{
    if (self.columnHeights.count == 0) {
        return CGSizeMake(0, 0);
    }
    //获取最高的列
    NSInteger maxColum = [self maxHeightColumn];
    CGFloat height = [self.columnHeights[maxColum]floatValue] + DefaultEdgeInsets.bottom;
    CGFloat width = self.collectionView.frame.size.width;
    return CGSizeMake(width, height);
}
//获取所有列中高度最短的列
- (NSInteger)minHeightColumn{
 //找出columnHeights的最小值
    NSInteger minHeightColumn = 0;
    CGFloat minColumHeight = [self.columnHeights[0]floatValue];
    for (NSInteger i = 1; i < self.columnHeights.count; i++) {
        CGFloat tempHeight = [self.columnHeights[i] floatValue];
        if (tempHeight < minColumHeight) {
            minColumHeight = tempHeight;
            minHeightColumn = i;
        }
    }
    return minHeightColumn;
}
//获取所有列中高度最高的列
- (NSInteger)maxHeightColumn{
    NSInteger maxHeightColumn = 0;
    CGFloat maxColumnHeight = [self.columnHeights[0]floatValue];
    for (NSInteger i = 1; i < self.columnHeights.count; i++) {
      CGFloat  temHeight = [self.columnHeights[i]floatValue];
        if (temHeight > maxColumnHeight) {
            maxColumnHeight = temHeight;
            maxHeightColumn = i;
        }
    }
    return maxHeightColumn;
}
@end
