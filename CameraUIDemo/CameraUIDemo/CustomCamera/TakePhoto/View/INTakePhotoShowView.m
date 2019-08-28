//
//  INTakePhotoShowView.m
//  AppDemo
//
//  Created by 1 on 2019/3/1.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INTakePhotoShowView.h"

static CGFloat kTPadding = 15.0f;

static CGFloat kButtonWidth = 100.0f;
static CGFloat kButtonHeight = 50.0f;

static CGFloat kToolBarHeight = 130.0f;

@implementation INTakePhotoShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.photoImageView];
        [self addSubview:self.toolbarImageView];
        [self.toolbarImageView addSubview:self.useButton];
        [self.toolbarImageView addSubview:self.retakeButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.photoImageView.frame = self.bounds;
    
    self.toolbarImageView.frame = CGRectMake(0.0, CGRectGetHeight(self.bounds) - kToolBarHeight,  CGRectGetWidth(self.bounds), kToolBarHeight);
    
    self.retakeButton.frame = CGRectMake(kTPadding, (CGRectGetHeight(self.toolbarImageView.frame) - kButtonHeight)/2, kButtonWidth, kButtonHeight);
    
    self.useButton.frame = CGRectMake(CGRectGetWidth(self.toolbarImageView.frame) - kTPadding - kButtonWidth, (CGRectGetHeight(self.toolbarImageView.frame) - kButtonHeight)/2, kButtonWidth, kButtonHeight);
}

#pragma mark - Actions
/**
 使用图片
 */
- (void)useButtonAction {
    if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(useButtonDidAction)]) {
        [self.subDelegate useButtonDidAction];
    }
}

/**
 重拍按钮
 */
- (void)retakeButtonAction {
    if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(retakeButtonDidAction)]) {
        [self.subDelegate retakeButtonDidAction];
    }
}

#pragma mark - SETTER/GETTER
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _photoImageView;
}

- (UIImageView *)toolbarImageView {
    if (!_toolbarImageView) {
        _toolbarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _toolbarImageView.userInteractionEnabled = YES;
        _toolbarImageView.backgroundColor = [UIColor clearColor];
//        _toolbarImageView.backgroundColor = [UIColor colorWithHexString:@"39ADDA"];
    }
    return _toolbarImageView;
}

- (UIButton *)useButton {
    if (!_useButton) {
        _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useButton setTitle:@"使用图片" forState:UIControlStateNormal];
        [_useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_useButton addTarget:self action:@selector(useButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useButton;
}

- (UIButton *)retakeButton {
    if (!_retakeButton) {
        _retakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retakeButton setTitle:@"重拍" forState:UIControlStateNormal];
        [_retakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_retakeButton addTarget:self action:@selector(retakeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retakeButton;
}

@end
