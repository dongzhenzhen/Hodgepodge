//
//  chainReactionPictureTableViewCell.h
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/6/16.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chainReactionPictureTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGPoint imageOffSet;
- (void)updateBackImageViewYForTableView:(UITableView *)tableView andView:(UIView *)view;
@end
