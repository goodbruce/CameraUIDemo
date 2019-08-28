//
//  INRecordVideoPresenter.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INRecordVideoPresenter.h"

@implementation INRecordVideoPresenter

#pragma mark - INRecordVideoViewDelegate

/**
 关闭
 */
- (void)closeButtonDidAction {
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SETTER/GETTER
- (INRecordVideoInteractor *)recordVInteractor {
    if (!_recordVInteractor) {
        _recordVInteractor = [[INRecordVideoInteractor alloc] init];
    }
    return _recordVInteractor;
}

- (INRecordVideoView *)recordVView {
    if (!_recordVView) {
        _recordVView = [[INRecordVideoView alloc] initWithFrame:CGRectZero];
    }
    return _recordVView;
}

@end
