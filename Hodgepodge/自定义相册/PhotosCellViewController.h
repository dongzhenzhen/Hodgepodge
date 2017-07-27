//
//  PhotosCellViewController.h
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/14.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface PhotosCellViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *iamgeArray;
@property (nonatomic, strong) PHFetchResult *fatchResult;
@property (nonatomic, assign) BOOL isBeforeIOS8;
@end
