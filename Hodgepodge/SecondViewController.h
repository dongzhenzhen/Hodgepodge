//
//  SecondViewController.h
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/6/15.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "testDelegate.h"
typedef void (^colorBlock)(UIColor *color);
@interface SecondViewController : UIViewController
@property (nonatomic, copy)colorBlock colorB;
@property (nonatomic, assign)id<testDelegate >delegate;

@end
