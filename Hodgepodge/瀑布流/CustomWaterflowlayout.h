//
//  CustomWaterflowlayout.h
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/18.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomWaterflowlayout;
@protocol CustomWaterflowlayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(CustomWaterflowlayout *)waterflowLayout heightForItemAtIndex:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@optional
- (CGFloat)columnCounInWaterflowLayout:(CustomWaterflowlayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(CustomWaterflowlayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(CustomWaterflowlayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(CustomWaterflowlayout *)waterflowLayout;
@end
@interface CustomWaterflowlayout : UICollectionViewLayout
@property (nonatomic, weak)id<CustomWaterflowlayoutDelegate>delegate;
@end
