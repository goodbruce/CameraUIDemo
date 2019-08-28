//
//  INTakeVideoProgressVIew.h
//  AppDemo
//
//  Created by 1 on 2019/3/4.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Addition.h"

/**
 视频录制的进度状态
 */
typedef NS_ENUM(NSInteger, INTakeVideoProgressState) {
    INTakeVideoProgressStateNone = 0,
    INTakeVideoProgressStateRecording,
    INTakeVideoProgressStateEnd,
} ;

@interface INTakeVideoProgressView : UIView

/**
 时间控件
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 背景控件
 */
@property (nonatomic, strong) UIImageView *bgImageView;

/**
 录制进度控件
 */
@property (nonatomic, strong) UIImageView *progressImageView;

/**
 录制进度
 */
@property (nonatomic, assign) CGFloat progress;

/**
 开始时间，开始时间为0秒
 */
@property (nonatomic, assign) NSInteger videoStartSecond;

/**
 录制视频时间
 */
@property (nonatomic, strong) NSTimer *videoTimer;

/**
 开始显示时间
 */
- (void)startVideoTimer;

/**
 结束视频定时器
 */
- (void)stopVideoTimer;

@end
