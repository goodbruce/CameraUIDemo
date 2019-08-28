//
//  INTakePhotoPresenter.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INTakePhotoPresenter.h"

@implementation INTakePhotoPresenter

#pragma mark - INTakePhotoViewDelegate 代理方法
/**
 close 关闭界面
 */
- (void)closeButtonDidAction {
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SETTER/GETTER
- (INTakePhotoConfig *)photoConfig {
    if (!_photoConfig) {
        _photoConfig = [[INTakePhotoConfig alloc] init];
    }
    return _photoConfig;
}

- (INTakePhotoInteractor *)photoInteractor {
    if (!_photoInteractor) {
        _photoInteractor = [[INTakePhotoInteractor alloc] init];
    }
    return _photoInteractor;
}

- (INTakePhotoView *)photoView {
    if (!_photoView) {
        _photoView = [[INTakePhotoView alloc] initWithFrame:CGRectZero];
    }
    return _photoView;
}

@end
