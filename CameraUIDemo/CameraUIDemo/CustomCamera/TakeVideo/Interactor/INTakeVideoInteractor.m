//
//  INTakeVideoInteractor.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INTakeVideoInteractor.h"

@implementation INTakeVideoInteractor

#pragma mark - SETTER/GETTER
- (INTakeVideoConfig *)videoConfig {
    if (!_videoConfig) {
        _videoConfig = [[INTakeVideoConfig alloc] init];
    }
    return _videoConfig;
}

@end
