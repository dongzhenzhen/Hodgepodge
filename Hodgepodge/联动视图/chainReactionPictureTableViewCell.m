//
//  chainReactionPictureTableViewCell.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/6/16.
//  Copyright © 2017年 董真真. All rights reserved.
// 联动视图

#import "chainReactionPictureTableViewCell.h"
@interface chainReactionPictureTableViewCell()
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation chainReactionPictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createImageView];
    }
    return self;
    
}
- (void)createImageView{
    self.clipsToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 400)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    self.imageView = imageView;
    [self addSubview:self.imageView];
}
- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}
- (void)updateBackImageViewYForTableView:(UITableView *)tableView andView:(UIView *)view {
    // 1.cell在view坐标系上的frame
    CGRect frameOnView = [tableView convertRect:self.frame toView:view];
    // 2.cell 和 view 的中心距离差
    CGFloat distanceOfCenterY = CGRectGetHeight(view.frame) * 0.5 - CGRectGetMinY(frameOnView);
    // 3.cell 和 backImageView的高度差
    CGFloat distanceH = CGRectGetHeight(self.imageView.frame) - CGRectGetHeight(self.frame);
    // 4.计算图片Y值偏移量
    CGFloat distanceWillMove = distanceOfCenterY / CGRectGetHeight(view.frame) * distanceH;
    
    // 5.更新图片的Y值
    CGRect backImageFrame = self.imageView.frame;
    backImageFrame.origin.y = distanceWillMove - distanceH * 0.5;
    self.imageView.frame = backImageFrame;
    
}
- (void)setImageOffSet:(CGPoint)imageOffSet{
    _imageOffSet = imageOffSet;
    CGRect oldFrame = self.frame;
    CGRect newFrame = CGRectOffset(oldFrame, imageOffSet.x, imageOffSet.y/100);
    self.frame = newFrame;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
