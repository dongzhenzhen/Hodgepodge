//
//  myFlowLayout.h
//  Hodgepodge
//
//  Created by 董真真 on 2017/7/21.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import <UIKit/UIKit.h>
@class myFlowLayout;
@protocol myFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(myFlowLayout *)waterflowLayout heightForItemAtIndex:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@optional
//列数
- (CGFloat)columnCountInWaterflowLayout:(myFlowLayout *)waterFlowLayout;
//列之间的间距
- (CGFloat)columnMarginInWaterflowLayout:(myFlowLayout *)waterFlowLayout;
//行之间的间距
- (CGFloat)rowMarginInWaterflowLayout:(myFlowLayout *)waterFlowLayout;
//距离四周的间距
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(myFlowLayout *)waterFlowLayout;

@end
@interface myFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) id<myFlowLayoutDelegate>delegate;
@end
