//
//  INTakeVideoView.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INTakeVideoView.h"
#import "UIColor+Addition.h"

static CGFloat kTakeToolHeight = 170.0;
static CGFloat kFocusSize = 50.0;
static CGFloat kCloseBtnSize = 30.0;
static CGFloat kTPhotoBtnSize = 60.0;
static CGFloat kPPadding = 15.0;

static CGFloat kProgressHeight = 64.0;
static CGFloat kFlastBtnSize = 50.0;
static CGFloat kChangedBtnSize = 50.0;

#define INRECORD_TIMER_INTERVAL 0.01f  // 定时器记录视频间隔
#define INRECORD_MAX_TIME 10.0f  // 视频最大时长 (单位/秒)

@interface INTakeVideoView ()<INTakeVideoShowViewDelegate>

@end

@implementation INTakeVideoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.cameraConfig = [[INCameraConfig alloc] initWithSuperView:self];

        [self addSubview:self.focusView];
        self.focusView.hidden = YES;
        
        [self addSubview:self.takeBGImageView];
        [self.takeBGImageView addSubview:self.progressView];
        [self.takeBGImageView addSubview:self.closeButton];
        [self.takeBGImageView addSubview:self.videoButton];
        
        [self addSubview:self.flashButton];
        [self addSubview:self.changedButton];
        
        [self addSubview:self.showVideoView];
        self.showVideoView.hidden = YES;
        self.showVideoView.subDelegate = self;
        
        [self addGestureRecognizer];
        [self configVideoRecordBlock];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.takeBGImageView.frame = CGRectMake(0.0, CGRectGetHeight(self.bounds) - kTakeToolHeight,  CGRectGetWidth(self.bounds), kTakeToolHeight);
    
    self.progressView.frame = CGRectMake(kPPadding, kPPadding, CGRectGetWidth(self.takeBGImageView.frame) - 2*kPPadding, kProgressHeight);
    
    self.closeButton.frame = CGRectMake(kPPadding, CGRectGetMaxY(self.progressView.frame) + (CGRectGetHeight(self.takeBGImageView.frame) - CGRectGetMaxY(self.progressView.frame) - kCloseBtnSize)/2, kCloseBtnSize, kCloseBtnSize);
    
    self.videoButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - kTPhotoBtnSize)/2, CGRectGetMaxY(self.progressView.frame) + (CGRectGetHeight(self.takeBGImageView.frame) - CGRectGetMaxY(self.progressView.frame) - kTPhotoBtnSize)/2, kTPhotoBtnSize, kTPhotoBtnSize);
    
    self.flashButton.frame = CGRectMake(kPPadding, KSysStatusBarHeight + kPPadding, kFlastBtnSize, kFlastBtnSize);
    
    self.changedButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - kChangedBtnSize - kPPadding, KSysStatusBarHeight + kPPadding, kChangedBtnSize, kChangedBtnSize);
    
    self.showVideoView.frame = self.bounds;
}

- (void)setSubDelegate:(id)subDelegate {
    _subDelegate = subDelegate;
}

#pragma mark - Add TapGesture
- (void)addGestureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGestureAction:)];
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *toolTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolTapGestureAction:)];
    [self.takeBGImageView addGestureRecognizer:toolTapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(videoLongPressGestureAction:)];
    [self.videoButton addGestureRecognizer:longPressGesture];
}

- (void)toolTapGestureAction:(UITapGestureRecognizer*)gesture {
    // 防止点击底部控件都有响应，不做任何事情
}

- (void)focusGestureAction:(UITapGestureRecognizer*)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusForTouchPoint:point];
}

- (void)focusForTouchPoint:(CGPoint)point {
    CGSize size = self.bounds.size;
    // focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
    CGPoint focusPoint = CGPointMake(point.y /size.height, 1 - point.x/size.width );
    
    if ([self.cameraConfig.device lockForConfiguration:nil]) {
        
        if ([self.cameraConfig.device isFocusPointOfInterestSupported]) {
            self.cameraConfig.device.focusPointOfInterest = focusPoint;
        }
        
        if ([self.cameraConfig.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.cameraConfig.device setFocusPointOfInterest:focusPoint];
            [self.cameraConfig.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.cameraConfig.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.cameraConfig.device setExposurePointOfInterest:focusPoint];
            //曝光量调节
            [self.cameraConfig.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        if ([self.cameraConfig.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            self.cameraConfig.device.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
        }
        
        [self.cameraConfig.device unlockForConfiguration];
        self.focusView.center = point;
        self.focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.focusView.hidden = YES;
            }];
        }];
    }
}

/**
 长按录制视频

 @param gesture 长按录制视频
 */
- (void)videoLongPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            // 开始录制视频
            [self.cameraConfig startVideoRecord];
            [self startRecordTimer];
            [self startRecordVideoUI];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            // 录制中
            // 暂时不做处理
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            // 结束录制
            [self.cameraConfig stopVideoRecord];
            [self stopRecordTimer];
            [self stopRecordVideoUI];
        }
            break;
            
        default:
            break;
    }
}

/**
 开启定时器，定时器动画
 */
- (void)recordTimerAction {
    // 时间大于INRECORD_MAX_TIME则停止录制
    if (self.timeLength > INRECORD_MAX_TIME) {
        [self.cameraConfig stopVideoRecord];
    }
    
    self.timeLength += INRECORD_TIMER_INTERVAL;
    
    self.progressView.progress = self.timeLength / INRECORD_MAX_TIME;
}

/**
 开始录制视频，隐藏视频播放控件
 */
- (void)startRecordVideoUI {
    [self.progressView startVideoTimer];
    
    self.showVideoView.hidden = YES;
    self.showVideoView.videoThumbImage = nil;
    self.showVideoView.videoOutURL = nil;
}

/**
 结束视频录制，显示视频播放控件
 */
- (void)stopRecordVideoUI {
    [self.progressView stopVideoTimer];
}

/**
 配置视频录制的block，视频录制完成显示空间
 */
- (void)configVideoRecordBlock {
    __weak typeof(self) weakSelf = self;
    self.cameraConfig.videoRecordCompletion = ^(NSURL *videoOutUrl, UIImage *thumbnailImage) {
        weakSelf.showVideoView.hidden = NO;
        weakSelf.showVideoView.videoThumbImage = [weakSelf.cameraConfig getVideoThumbImage:weakSelf.cameraConfig.movieFileOutURL];
        weakSelf.showVideoView.videoOutURL = weakSelf.cameraConfig.movieFileOutURL;
        [weakSelf.showVideoView startVideoPlayer];
    };
}

#pragma mark - Actions
/**
 关闭按钮
 */
- (void)closeButtonAction {
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(closeButtonDidAction)]) {
        [self.actionDelegate closeButtonDidAction];
    }
}

/**
 点击拍照
 */
- (void)takeVideoButtonAction {
    
}

/**
 切换摄像头
 */
- (void)changedButtonAction {
    // 获取摄像头数量
    NSInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount <= 1) {
        return;
    }
    
    AVCaptureDevice *newDevice = nil;
    AVCaptureDeviceInput *newInput = nil;
    
    //为摄像头的转换加转场动画
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.type = @"flip";

    // 获取当前摄像头的postion
    AVCaptureDevicePosition cameraPostion = [[self.cameraConfig.input device] position];
    switch (cameraPostion) {
        case AVCaptureDevicePositionFront: {
            //当前是前置摄像头，切换成后置摄像头
            newDevice = [self.cameraConfig deviceWithPostion:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }
            break;
            
        case AVCaptureDevicePositionBack: {
            //当前是后置摄像头，切换成前置摄像头
            newDevice = [self.cameraConfig deviceWithPostion:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
            break;
            
        default:
            break;
    }
    
    [self.cameraConfig.previewLayer addAnimation:animation forKey:nil];

    //输入流
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:nil];
    
    if (newInput) {
        [self.cameraConfig.session beginConfiguration];
        
        // 移除原先的input
        [self.cameraConfig.session removeInput:self.cameraConfig.input];
        
        if ([self.cameraConfig.session canAddInput:newInput]) {
            [self.cameraConfig.session addInput:newInput];
            self.cameraConfig.input = newInput;
        } else {
            // 如果不能添加新的input, 继续使用之前的input
            [self.cameraConfig.session addInput:self.cameraConfig.input];
        }
        
        [self.cameraConfig.session commitConfiguration];
    }
}

/**
 闪光灯光
 */
- (void)flashButtonAction {
    self.flashButton.selected = !self.flashButton.selected;
    
    BOOL hasFlightOn = self.flashButton.selected;
    [self.cameraConfig configFlashlightOn:hasFlightOn];
}

/**
 代理方法
 */
#pragma mark - 显示图片，确认是否需要重拍或者使用该图片
/**
 使用图片
 */
- (void)useButtonDidAction {
    // 剪切视频
    [INVideoUtils cutVideoWithAVAsset:self.showVideoView.videoAVURLAsset startTime:self.showVideoView.startTime endTime:self.showVideoView.endTime completion:^(NSURL *outputURL) {
        NSLog(@"outputURL:%@",outputURL);
    }];
}

/**
 重拍按钮
 */
- (void)retakeButtonDidAction {
    self.showVideoView.hidden = YES;
    self.showVideoView.videoThumbImage = nil;
    self.showVideoView.videoOutURL = nil;
    self.showVideoView.mySAVideoRangeSlider = nil;
    [self.showVideoView startVideoPlayer];
    
    // 初始化录制进度progress
    self.progressView.progress = 0.0;
    
    // 重新启动
    [self.cameraConfig.session startRunning];
}

#pragma mark - SETTER/GETTER
- (UIImageView *)takeBGImageView {
    if (!_takeBGImageView) {
        _takeBGImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _takeBGImageView.userInteractionEnabled = YES;
        _takeBGImageView.backgroundColor = [UIColor clearColor];
//        _takeBGImageView.backgroundColor = [UIColor colorWithHexString:@"39ADED" alpha:1.0];
    }
    return _takeBGImageView;
}

- (INTakeVideoProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[INTakeVideoProgressView alloc] initWithFrame:CGRectZero];
    }
    return _progressView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"video_cancel_40x40_"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)videoButton {
    if (!_videoButton) {
        _videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoButton setImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
    }
    return _videoButton;
}

- (UIView *)focusView{
    if (!_focusView) {
        _focusView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _focusView.frame = CGRectMake(0.0, 0.0, kFocusSize, kFocusSize);
        _focusView.userInteractionEnabled = YES;
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor = [UIColor colorWithHexString:@"55dd87"].CGColor;
    }
    return _focusView;
}

- (UIButton *)changedButton {
    if (!_changedButton) {
        _changedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changedButton setImage:[UIImage imageNamed:@"ic_rotate_36x36_"] forState:UIControlStateNormal];
        [_changedButton addTarget:self action:@selector(changedButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changedButton;
}

- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashButton setImage:[UIImage imageNamed:@"ic_flash_04_36x36_"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"ic_flash_03_36x36_"] forState:UIControlStateSelected];
        [_flashButton addTarget:self action:@selector(flashButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashButton;
}

- (INTakeVideoShowView *)showVideoView {
    if (!_showVideoView) {
        _showVideoView = [[INTakeVideoShowView alloc] initWithFrame:CGRectZero];
    }
    return _showVideoView;
}

- (void)startRecordTimer {
    self.timeLength = 0;
    self.recordTimer = [NSTimer timerWithTimeInterval:INRECORD_TIMER_INTERVAL target:self selector:@selector(recordTimerAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopRecordTimer {
    [self.recordTimer invalidate];
}

@end
