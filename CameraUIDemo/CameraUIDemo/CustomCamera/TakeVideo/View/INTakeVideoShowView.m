//
//  INTakeVideoShowView.m
//  AppDemo
//
//  Created by 1 on 2019/3/1.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INTakeVideoShowView.h"

static CGFloat kTPadding = 15.0f;

static CGFloat kButtonWidth = 100.0f;
static CGFloat kButtonHeight = 50.0f;

static CGFloat kToolBarHeight = 170.0f;

static CGFloat kSliderHeight = 60.0f;

@interface INTakeVideoShowView () <SAVideoRangeSliderDelegate>

@end

@implementation INTakeVideoShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self addSubview:self.photoImageView];
        [self addSubview:self.toolbarImageView];
        [self.toolbarImageView addSubview:self.useButton];
        [self.toolbarImageView addSubview:self.retakeButton];
        
        // 设置开始和结束时间的初始值
        self.startTime = 0.0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.photoImageView.frame = self.bounds;
    
    self.toolbarImageView.frame = CGRectMake(0.0, CGRectGetHeight(self.bounds) - kToolBarHeight,  CGRectGetWidth(self.bounds), kToolBarHeight);
    
    CGFloat silderMAXY = kSliderHeight + kTPadding;
    
    self.retakeButton.frame = CGRectMake(kTPadding, silderMAXY + (CGRectGetHeight(self.toolbarImageView.frame) - kButtonHeight - silderMAXY)/2, kButtonWidth, kButtonHeight);
    
    self.useButton.frame = CGRectMake(CGRectGetWidth(self.toolbarImageView.frame) - kTPadding - kButtonWidth, silderMAXY + (CGRectGetHeight(self.toolbarImageView.frame) - kButtonHeight - silderMAXY)/2, kButtonWidth, kButtonHeight);
}

- (void)setVideoThumbImage:(UIImage *)videoThumbImage {
    _videoThumbImage = videoThumbImage;
    self.photoImageView.image = videoThumbImage;
    [self setNeedsLayout];
}

- (void)setVideoOutURL:(NSURL *)videoOutURL {
    _videoOutURL = videoOutURL;
    if (!videoOutURL) {
        return;
    }
    
    // 设置结束时间
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoOutURL options:opts];
    NSUInteger dTotalSeconds = CMTimeGetSeconds(urlAsset.duration);
    self.endTime = dTotalSeconds;
    self.videoAVURLAsset = urlAsset;
    
    if (!_mySAVideoRangeSlider) {
        _mySAVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, kTPadding, CGRectGetWidth(self.bounds), kSliderHeight) videoUrl:videoOutURL];
        _mySAVideoRangeSlider.bubleText.font = [UIFont systemFontOfSize:12];
        [_mySAVideoRangeSlider setPopoverBubbleSize:120 height:60];
        [self.toolbarImageView addSubview:_mySAVideoRangeSlider];
    }
    
    // Yellow
    self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.996 green: 0.951 blue: 0.502 alpha: 1];
    self.mySAVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.992 green: 0.902 blue: 0.004 alpha: 1];
    self.mySAVideoRangeSlider.delegate = self;
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

/**
 播放按钮
 */
- (void)playerButtonAction {
    
}

/**
 开始播放视频
 */
- (void)startVideoPlayer {
    [self.videoPlayer playWithUrl:self.videoOutURL superView:self frame:self.bounds];
}

/**
 暂停播放视频
 */
- (void)pauseVideoPlayer {
    [self.videoPlayer stopPlay];
}

#pragma mark - SAVideoRangeSliderDelegate视频 剪切控件
- (void)videoRange:(SAVideoRangeSlider *)videoRange isLeft:(BOOL)isLeft didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    NSLog(@"%f ---- %f",leftPosition,rightPosition);
    
    float f = 0;
    if (isLeft) {
        f = leftPosition;
    }else {
        f = rightPosition;
    }
    
    self.startTime = leftPosition;
    self.endTime = rightPosition;
    
    // 快进 / 快退
    CMTime time = CMTimeMakeWithSeconds(f, self.videoPlayer.player.currentTime.timescale);
    [self.videoPlayer.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)videoRange:(SAVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    
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
        [_useButton setTitle:@"确定选取" forState:UIControlStateNormal];
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


- (UIButton *)playerButton {
    if (!_playerButton) {
        _playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playerButton setImage:[UIImage imageNamed:@"feed_icon_video_54x54_"] forState:UIControlStateNormal];
        [_playerButton addTarget:self action:@selector(playerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playerButton;
}

- (INVideoPlayerConfig *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [[INVideoPlayerConfig alloc] init];
    }
    return _videoPlayer;
}

@end
