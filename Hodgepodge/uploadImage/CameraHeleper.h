//
//  CameraHeleper.h
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/7/7.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImagModel;
@interface CameraHeleper : NSObject
@property (nonatomic, strong) NSMutableArray *imageArray;

+ (instancetype)shareHeleper;

- (void)getAlbum;
- (void)isAuthoritys;
@end
