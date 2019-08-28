//
//  INRecordVideoNavigationView.m
//  AppDemo
//
//  Created by 1 on 2019/3/7.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INRecordVideoNavigationView.h"

static CGFloat kNBtnSize = 44.0;
static CGFloat kNPadding = 15.0;

@implementation INRecordVideoNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.closeButton];
        [self addSubview:self.lightButton];
        [self addSubview:self.changedButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgImageView.frame = self.bounds;
    self.closeButton.frame = CGRectMake(kNPadding, KSysStatusBarHeight, kNBtnSize, kNBtnSize);
    self.lightButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 2*kNPadding-2*kNBtnSize, KSysStatusBarHeight, kNBtnSize, kNBtnSize);
    self.changedButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - kNPadding-kNBtnSize, KSysStatusBarHeight, kNBtnSize, kNBtnSize);
}

#pragma mark - Action 事件处理
- (void)closeButtonAction {
    if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(closeButtonDidAction)]) {
        [self.subDelegate closeButtonDidAction];
    }
}

- (void)changedButtonAction {
    if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(changedButtonDidAction)]) {
        [self.subDelegate changedButtonDidAction];
    }
}

- (void)lightButtonAction {
    if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(lightButtonDidAction)]) {
        [self.subDelegate lightButtonDidAction];
    }
}

#pragma mark - SETTER/GETTER
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.backgroundColor = [UIColor blackColor];
        _bgImageView.alpha = 0.5;
    }
    return _bgImageView;
}


- (UIButton *)lightButton {
    if (!_lightButton) {
        _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lightButton setImage:[UIImage imageNamed:@"ic_flash_04_36x36_"] forState:UIControlStateNormal];
        [_lightButton setImage:[UIImage imageNamed:@"ic_flash_03_36x36_"] forState:UIControlStateSelected];
        [_lightButton addTarget:self action:@selector(lightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"ic_nav_white_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)changedButton {
    if (!_changedButton) {
        _changedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changedButton setImage:[UIImage imageNamed:@"video_turn_camera_on_40x40_"] forState:UIControlStateNormal];
        [_changedButton addTarget:self action:@selector(changedButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changedButton;
}

+ (CGFloat)navigationHeight {
    return KSysStatusBarHeight + 44.0;
}

@end
