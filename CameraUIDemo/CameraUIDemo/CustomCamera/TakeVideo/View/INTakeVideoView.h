//
//  INTakeVideoView.h
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Addition.h"
#import "INCameraConfig.h"
#import "INTakeVideoShowView.h"
#import "INTakeVideoProgressView.h"


@protocol INTakeVideoViewDelegate;
@interface INTakeVideoView : UIView

@property (nonatomic, weak) id subDelegate;

@property (nonatomic, weak) id<INTakeVideoViewDelegate>actionDelegate;

@property (nonatomic, strong) INCameraConfig *cameraConfig;

/**
 拍照的背景图片
 */
@property (nonatomic, strong) UIImageView *takeBGImageView;

/**
 关闭
 */
@property (nonatomic, strong) UIButton *closeButton;

/**
 录制视频按钮
 */
@property (nonatomic, strong) UIButton *videoButton;

/**
 聚焦view
 */
@property (nonatomic, strong) UIView *focusView;

/**
 切换前后置摄像头
 */
@property (nonatomic, strong) UIButton *changedButton;

/**
 开启闪光灯按钮
 */
@property (nonatomic, strong) UIButton *flashButton;

/**
 时间长度
 */
@property (nonatomic, assign) CGFloat timeLength;

/**
 录制视频的定时器
 */
@property (nonatomic, strong) NSTimer *recordTimer;

/**
 录制视频进度控件
 */
@property (nonatomic, strong) INTakeVideoProgressView *progressView;

/**
 显示视频，使用该视频或者重新拍摄
 */
@property (nonatomic, strong) INTakeVideoShowView *showVideoView;

- (id)initWithFrame:(CGRect)frame;

@end

/**
 代理方法
 */
@protocol INTakeVideoViewDelegate <NSObject>

/**
 close 关闭界面
 */
- (void)closeButtonDidAction;

@end
