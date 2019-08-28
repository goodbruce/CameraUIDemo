//
//  INRecordVideoProgressView.h
//  AppDemo
//
//  Created by 1 on 2019/3/7.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INCameraConfig.h"
#import "UIColor+Addition.h"

#define INVIDEO_RECORD_TIMER_INTERVAL 0.01f  // 定时器记录视频间隔
#define INVIDEO_RECORD_MAX_TIME 15.0f  // 视频最大时长 (单位/秒)

#define INVIDEO_SECONDS_INTERVAL 1.0f  // 描述的定时器

@interface INRecordVideoProgressImageView : UIImageView

/**
 是否删除选中
 */
@property (nonatomic, assign) BOOL hasDeleteSelected;

@end


@interface INRecordVideoProgressView : UIView

/**
 背景控件
 */
@property (nonatomic, strong) UIImageView *bgImageView;

/**
 闪动的图
 */
@property (nonatomic, strong) UIImageView *flickerImageView;

/**
 开始闪动动画
 */
- (void)startFlickAnimation;

/**
 结束闪动动画
 */
- (void)stopFlickAnimation;

/**
 新增录制进度控件
 */
- (void)addProgressView;

/**
 移除录制进度控件
 */
- (void)removeProgressView;

/**
 开始动画
 */
- (void)startProgressAnimation:(CGFloat)progress;

/**
 结束进度动画
 */
- (void)stopProgressAnimation;

/**
 删除最后一个进度控件
 */
- (void)deleteLastProgressImageView;

/**
 获取所有进度条的宽度

 @return 宽度
 */
- (CGFloat)getAllProgressWidth;

/**
 获取录制的秒数

 @return 秒数
 */
- (NSInteger)getRecondSecond;

/**
 判断是否结束录制了

 @return 是否结束录制视频
 */
- (BOOL)checkEndRecord;

/**
 进度控件

 @return view
 */
+ (INRecordVideoProgressImageView *)progressImageView;

/**
 永久闪烁的动画
 
 @param time 时间
 @return 动画
 */
+ (CABasicAnimation *)opacityAnimation:(float)time;

@end
