//
//  INRecordVideoToolView.m
//  AppDemo
//
//  Created by 1 on 2019/3/7.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INRecordVideoToolView.h"

static CGFloat KTTImeWidth = 60.0;
static CGFloat KTTImeHeight = 30.0;
static CGFloat kRecordHeight = 130.0;
static CGFloat kProgressHeight = 6.0;
static CGFloat kRecordBtnSize = 60.0;
static CGFloat kProgressPadding = 1.0;

static CGFloat kDeleteWidth = 50.0;
static CGFloat kDeleteHeight = 40.0;

static CGFloat kConfirmWidth = 50.0;
static CGFloat kConfirmHeight = 40.0;

@interface INRecordVideoToolView ()

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger videoSecond;

@end

@implementation INRecordVideoToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.timeLabel];
        [self addSubview:self.bgImageView];
        
        [self addSubview:self.recordButton];
        [self addSubview:self.deleteButton];
        [self addSubview:self.confirmButton];
        [self addSubview:self.progressView];
        [self.progressView startFlickAnimation];
        
        self.number = 0;
        self.videoSecond = 0;
        self.isEndRecord = NO;
        
        [self addGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.timeLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - KTTImeWidth)/2, 0.0, KTTImeWidth, KTTImeHeight);
    
    CGFloat originY = CGRectGetMaxY(self.timeLabel.frame);
    self.bgImageView.frame = CGRectMake(0.0, originY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - originY);
    
    self.progressView.frame = CGRectMake(0.0, originY + kProgressPadding, CGRectGetWidth(self.bounds), kProgressHeight);
    
    self.recordButton.frame = CGRectMake((CGRectGetWidth(self.bgImageView.frame) - kRecordBtnSize)/2, originY + (CGRectGetHeight(self.bgImageView.frame) - kRecordBtnSize)/2, kRecordBtnSize, kRecordBtnSize);
    
    CGFloat width = CGRectGetMinX(self.recordButton.frame);
    self.deleteButton.frame = CGRectMake((width - kDeleteWidth)/2, originY + (CGRectGetHeight(self.bgImageView.frame) - kDeleteHeight)/2, kDeleteWidth, kDeleteHeight);
    
    self.confirmButton.frame = CGRectMake(CGRectGetMaxX(self.recordButton.frame) + (width - kDeleteWidth)/2, originY + (CGRectGetHeight(self.bgImageView.frame) - kDeleteHeight)/2, kDeleteWidth, kDeleteHeight);
}

- (void)addGestureRecognizer {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(videoLongPressGestureAction:)];
    [self.recordButton addGestureRecognizer:longPressGesture];
}

/**
 长按录制视频
 
 @param gesture 长按录制视频
 */
- (void)videoLongPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    if (self.isEndRecord) {
        [self stopRecordTimer];
        [self.progressView stopProgressAnimation];
        return;
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            if (self.videoSecond < INVIDEO_RECORD_MAX_TIME) {
                // 开始录制视频
                if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(startGestureDidAction)]) {
                    [self.subDelegate startGestureDidAction];
                }
                [self.progressView startFlickAnimation];
                [self.progressView addProgressView];
                [self startRecordTimer];
            }
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
            if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(stopGestureDidAction)]) {
                [self.subDelegate stopGestureDidAction];
            }
            
            [self stopRecordTimer];
            [self.progressView stopProgressAnimation];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ACTIONS 事件
- (void)recordButtonAction {
    if (self.number % 2 == 0) {
        [self.progressView startFlickAnimation];
        [self.progressView addProgressView];
        [self startRecordTimer];
    } else {
        [self stopRecordTimer];
    }
    
    self.number++;
}

- (void)confirmButtonAction {
    if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(confirmButtonDidAction)]) {
        [self.subDelegate confirmButtonDidAction];
    }
}

- (void)deleteButtonAction {
    
    [self.progressView deleteLastProgressImageView];
    self.isEndRecord = [self.progressView checkEndRecord];

//    if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(deleteButtonDidAction)]) {
//        [self.subDelegate deleteButtonDidAction];
//    }
    
    self.videoSecond = [self.progressView getRecondSecond];
    self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",(long)self.videoSecond];
}

#pragma mark - RecordTimer 定时器
- (void)startRecordTimer {
    self.timeLength = 0;
    self.recordTimer = [NSTimer timerWithTimeInterval:INVIDEO_RECORD_TIMER_INTERVAL target:self selector:@selector(recordTimerAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopRecordTimer {
    [self.recordTimer invalidate];
}

/**
 开启定时器，定时器动画
 */
- (void)recordTimerAction {
    // 时间大于INRECORD_MAX_TIME则停止录制
    if (self.timeLength > INVIDEO_RECORD_MAX_TIME) {
        //[self.cameraConfig stopVideoRecord];
    }
    
    self.timeLength += INVIDEO_RECORD_TIMER_INTERVAL;
    
    CGFloat progress = self.timeLength / INVIDEO_RECORD_MAX_TIME;
    [self.progressView startProgressAnimation:progress];
    
    self.videoSecond = [self.progressView getRecondSecond];
    
    self.isEndRecord = [self.progressView checkEndRecord];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",(long)self.videoSecond];
    if (self.videoSecond >= INVIDEO_RECORD_MAX_TIME) {
        // 到达15s后，结束录制
        if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(stopGestureDidAction)]) {
            [self.subDelegate stopGestureDidAction];
        }
        
        [self stopRecordTimer];
        [self.progressView stopProgressAnimation];
        self.isEndRecord = YES;
        return;
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

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, KTTImeWidth, KTTImeHeight)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.layer.cornerRadius = KTTImeHeight/2;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.text = @"0\"";
    }
    return _timeLabel;
}

- (INRecordVideoProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[INRecordVideoProgressView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
        //[_recordButton addTarget:self action:@selector(recordButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordButton;
}

+ (CGFloat)toolHeight {
    return kRecordHeight + KTTImeHeight;
}

@end
