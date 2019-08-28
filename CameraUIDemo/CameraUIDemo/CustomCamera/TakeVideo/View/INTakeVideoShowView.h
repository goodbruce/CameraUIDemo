//
//  INTakeVideoShowView.h
//  AppDemo
//
//  Created by 1 on 2019/3/1.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Addition.h"
#import "INCameraConfig.h"
#import "INVideoPlayerConfig.h"
#import "SAVideoRangeSlider.h"
#import "INVideoUtils.h"

@protocol INTakeVideoShowViewDelegate;
@interface INTakeVideoShowView : UIView

@property (nonatomic, weak) id<INTakeVideoShowViewDelegate>subDelegate;

/**
 视频帧
 */
@property (strong, nonatomic) SAVideoRangeSlider *mySAVideoRangeSlider;


/**
 显示拍照的图片
 */
@property (nonatomic, strong) UIImageView *photoImageView;

/**
 显示工具栏的背景
 */
@property (nonatomic, strong) UIImageView *toolbarImageView;

/**
 使用图片按钮
 */
@property (nonatomic, strong) UIButton *useButton;

/**
 播放按钮
 */
@property (nonatomic, strong) UIButton *playerButton;

/**
 重新拍摄
 */
@property (nonatomic, strong) UIButton *retakeButton;

/**
 视频的第一帧缩略图
 */
@property (nonatomic, strong) UIImage *videoThumbImage;

/**
 视频的输出地址outURL
 */
@property (nonatomic, strong) NSURL *videoOutURL;

/**
 视频的AVURLAsset
 */
@property (nonatomic, strong) AVURLAsset *videoAVURLAsset;

/**
 视频播放配置
 */
@property (nonatomic, strong) INVideoPlayerConfig *videoPlayer;


/**
 开始时间
 */
@property (nonatomic, assign) CGFloat startTime;

/**
 结束时间
 */
@property (nonatomic, assign) CGFloat endTime;


/**
 开始播放视频
 */
- (void)startVideoPlayer;

/**
 暂停播放视频
 */
- (void)pauseVideoPlayer;

@end

/**
 代理方法
 */
@protocol INTakeVideoShowViewDelegate <NSObject>

/**
 使用图片
 */
- (void)useButtonDidAction;

/**
 重拍按钮
 */
- (void)retakeButtonDidAction;

@end

