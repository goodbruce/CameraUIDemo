//
//  INRecordVideoToolView.h
//  AppDemo
//
//  Created by 1 on 2019/3/7.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INCameraConfig.h"
#import "INRecordVideoProgressView.h"

@protocol INRecordVideoToolViewDelegate;
@interface INRecordVideoToolView : UIView

@property (nonatomic, weak) id<INRecordVideoToolViewDelegate>subDelegate;

/**
 时间显示，多少秒
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 背景控件
 */
@property (nonatomic, strong) UIImageView *bgImageView;

/**
 录制进度条
 */
@property (nonatomic, strong) INRecordVideoProgressView *progressView;

/**
 删除按钮
 */
@property (nonatomic, strong) UIButton *deleteButton;

/**
 确认按钮
 */
@property (nonatomic, strong) UIButton *confirmButton;

/**
 录制视频按钮
 */
@property (nonatomic, strong) UIButton *recordButton;

/**
 时间长度
 */
@property (nonatomic, assign) CGFloat timeLength;

/**
 录制视频的定时器
 */
@property (nonatomic, strong) NSTimer *recordTimer;

/**
 是否结束录制
 */
@property (nonatomic, assign) BOOL isEndRecord;

+ (CGFloat)toolHeight;

@end

/**
 代理方法
 */
@protocol INRecordVideoToolViewDelegate <NSObject>

/**
 开始长按手势
 */
- (void)startGestureDidAction;

/**
 结束长按手势
 */
- (void)stopGestureDidAction;

/**
 确认，合成视频
 */
- (void)confirmButtonDidAction;

/**
 删除视频
 */
- (void)deleteButtonDidAction;

@end
