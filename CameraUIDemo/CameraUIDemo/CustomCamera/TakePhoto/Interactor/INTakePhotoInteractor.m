//
//  INTakePhotoInteractor.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INTakePhotoInteractor.h"

@implementation INTakePhotoInteractor

#pragma mark - SETTER/GETTER
- (INTakePhotoConfig *)photoConfig {
    if (!_photoConfig) {
        _photoConfig = [[INTakePhotoConfig alloc] init];
    }
    return _photoConfig;
}

@end
