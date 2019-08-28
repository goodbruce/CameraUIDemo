//
//  INTakeVideoPresenter.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INTakeVideoPresenter.h"

@implementation INTakeVideoPresenter


#pragma mark - INTakeVideoViewDelegate 代理方法
/**
 close 关闭界面
 */
- (void)closeButtonDidAction {
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SETTER/GETTER
- (INTakeVideoConfig *)videoConfig {
    if (!_videoConfig) {
        _videoConfig = [[INTakeVideoConfig alloc] init];
    }
    return _videoConfig;
}

- (INTakeVideoInteractor *)videoInteractor {
    if (!_videoInteractor) {
        _videoInteractor = [[INTakeVideoInteractor alloc] init];
    }
    return _videoInteractor;
}

- (INTakeVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[INTakeVideoView alloc] initWithFrame:CGRectZero];
    }
    return _videoView;
}

@end
