//
//  INTakeVideoProgressVIew.m
//  AppDemo
//
//  Created by 1 on 2019/3/4.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INTakeVideoProgressView.h"

static CGFloat kPTimeHeight = 20.0;
static CGFloat kPTimeWidth = 80.0;
static CGFloat kPPPadding = 5.0;

#define kVideo_MAX_VIDEO_SECOND 60

@implementation INTakeVideoProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.timeLabel];
        [self addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.progressImageView];
        
        self.videoStartSecond = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.timeLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - kPTimeWidth)/2, 0.0, kPTimeWidth, kPTimeHeight);
    self.bgImageView.frame = CGRectMake(0.0, CGRectGetMaxY(self.timeLabel.frame) + kPPPadding, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetMaxY(self.timeLabel.frame) - 2*kPPPadding);
    self.progressImageView.frame = CGRectMake(0.0, 0.0, 0.0, CGRectGetHeight(self.bgImageView.frame));
}

- (void)setProgress:(CGFloat)progress {
    if (progress > 1) {
        progress = 1.0;
    }
    
    if (progress < 0) {
        progress = 0.0;
    }
    
    _progress = progress;
    
    CGRect progressFrame = self.progressImageView.frame;
    progressFrame.size.width = CGRectGetWidth(self.bgImageView.frame)*progress;
    self.progressImageView.frame = progressFrame;
}

- (void)videoTimerAction {
    self.videoStartSecond = self.videoStartSecond + 1;
    
    if (self.videoStartSecond > kVideo_MAX_VIDEO_SECOND) {
        self.videoStartSecond = kVideo_MAX_VIDEO_SECOND;
    }
    
    if (self.videoStartSecond > 10) {
        self.timeLabel.text = [NSString stringWithFormat:@"00:00:%ld",(long)self.videoStartSecond];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"00:00:0%ld",(long)self.videoStartSecond];
    }
}

/**
 开始显示时间
 */
- (void)startVideoTimer {
    self.videoTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(videoTimerAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.videoTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopVideoTimer {
    [self.videoTimer invalidate];
}

#pragma mark - SETTER/GETTER
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kPTimeWidth, kPTimeHeight)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        _timeLabel.text = @"00:00:00";
        _timeLabel.layer.cornerRadius = kPTimeHeight/2;
        _timeLabel.layer.masksToBounds = YES;
    }
    return _timeLabel;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1" alpha:0.5];
        _bgImageView.clipsToBounds = YES;
        _bgImageView.layer.cornerRadius = 6;
        _bgImageView.layer.masksToBounds = YES;
    }
    return _bgImageView;
}

- (UIImageView *)progressImageView {
    if (!_progressImageView) {
        _progressImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _progressImageView.backgroundColor = [UIColor colorWithHexString:@"ed5699" alpha:0.5];
        _progressImageView.clipsToBounds = YES;
    }
    return _progressImageView;
}

@end
