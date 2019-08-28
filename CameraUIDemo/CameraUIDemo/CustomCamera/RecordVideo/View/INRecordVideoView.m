//
//  INRecordVideoView.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INRecordVideoView.h"
#import "UIColor+Addition.h"

static CGFloat kVideoFocusSize = 50.0;

@interface INRecordVideoView ()<INRecordVideoToolViewDelegate>

@end

@implementation INRecordVideoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        self.recordVideoConfig = [[INRecordVideoConfig alloc] init];
        [self.layer addSublayer:self.recordVideoConfig.videoPreviewLayer];
        [self addSubview:self.focusView];
        self.focusView.hidden = YES;
        
        [self addSubview:self.navigationBar];
        [self addSubview:self.toolBar];
        self.toolBar.subDelegate = self;
        
        self.navigationBar.subDelegate = self;

        // 启动
        [self.recordVideoConfig startSessionRunning];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.navigationBar.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), [INRecordVideoNavigationView navigationHeight]);
    self.toolBar.frame = CGRectMake(0.0, CGRectGetHeight(self.bounds) - [INRecordVideoToolView toolHeight], CGRectGetWidth(self.bounds), [INRecordVideoToolView toolHeight]);
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}

#pragma mark - Add TapGesture
- (void)addGestureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGestureAction:)];
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureAction:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    doubleTapGesture.delaysTouchesBegan = YES;
    [self addGestureRecognizer:doubleTapGesture];
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    UITapGestureRecognizer *toolTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolTapGestureAction:)];
    [self.toolBar addGestureRecognizer:toolTapGesture];
    
    UITapGestureRecognizer *navigationTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationTapGestureAction:)];
    [self.navigationBar addGestureRecognizer:navigationTapGesture];
}

- (void)toolTapGestureAction:(UITapGestureRecognizer*)gesture {
    // 防止点击底部控件都有响应，不做任何事情
}

- (void)navigationTapGestureAction:(UITapGestureRecognizer*)gesture {
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
    
    [self.recordVideoConfig focusForTouchPoint:focusPoint];
    
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

- (void)doubleTapGestureAction:(UITapGestureRecognizer*)gesture {
    [self.recordVideoConfig doubleClickZoomVideo];
}

/**
 代理方法
 */
#pragma mark - INRecordVideoToolViewDelegate
/**
 开始长按手势
 */
- (void)startGestureDidAction {
    // 开始录制视频
    INVideoModel *videoModel = [INVideoModel createVideoModel];
    [self.recordVideoConfig.videoModels addObject:videoModel];
    [self.recordVideoConfig startRecordAssetWriter:videoModel];
    
    self.recordVideoConfig.isInRecording = YES;
}

/**
 结束长按手势
 */
- (void)stopGestureDidAction {
    self.recordVideoConfig.isInRecording = NO;
    // 结束录制视频
    INVideoModel *videoModel = nil;
    if (self.recordVideoConfig.videoModels.count > 0) {
        videoModel = [self.recordVideoConfig.videoModels lastObject];
    }
    
    if (videoModel) {
        [self.recordVideoConfig stopRecordAssetWriter:videoModel completion:^{
            // 录制结束
        }];
    }
}

/**
 确认，合成视频
 */
- (void)confirmButtonDidAction {
    __weak typeof(self) weakSelf = self;
    __block NSString *targetUrl = [INDocPathUtils getMergeVideoUrl];
    [weakSelf.recordVideoConfig mergeVideoWithVideos:self.recordVideoConfig.videoModels targetUrl:targetUrl completion:^{
        // 合并视频完成
        weakSelf.recordVideoConfig.mergeVideoTargetUrl = targetUrl;
        [weakSelf.recordVideoConfig saveMergeVideoToAblum:targetUrl completion:^{
            // 存储到相册
        }];
    }];
}

/**
 删除视频
 */
- (void)deleteButtonDidAction {
    
    __weak typeof(self) weakSelf = self;
    __block NSString *musicVideoTargetUrl = [INDocPathUtils getMergeBackgroundMusicVideoUrl];
    __block NSString *musicUrl = [[NSBundle mainBundle] pathForResource:@"tianxiawushuang" ofType:@"mp3"];
    [weakSelf.recordVideoConfig mergeVideoBackgroupMusic:musicVideoTargetUrl sourceVideoUrl:weakSelf.recordVideoConfig.mergeVideoTargetUrl musicUrl:musicUrl completion:^{
        // 合并视频，音频 完成
        weakSelf.recordVideoConfig.mergeBackgroundMusicVideoTargetUrl = musicVideoTargetUrl;
        [weakSelf.recordVideoConfig saveMergeVideoToAblum:musicVideoTargetUrl completion:^{
            // 存储到相册
        }];
    }];
}


#pragma mark - INRecordVideoNavigationViewDelegate 导航代理方法
/**
 关闭
 */
- (void)closeButtonDidAction {
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(closeButtonDidAction)]) {
        [self.actionDelegate closeButtonDidAction];
    }
}

/**
 更换摄像头
 */
- (void)changedButtonDidAction {
    [self.recordVideoConfig changedDeviceCamera];
}

/**
 灯管
 */
- (void)lightButtonDidAction {
    self.navigationBar.lightButton.selected = !self.navigationBar.lightButton.selected;
    
    BOOL hasFlightOn = self.navigationBar.lightButton.selected;
    [self.recordVideoConfig configFlashlightOn:hasFlightOn];
}

#pragma mark - SETTER/GETTER
- (INRecordVideoNavigationView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[INRecordVideoNavigationView alloc] initWithFrame:CGRectZero];
        _navigationBar.userInteractionEnabled = YES;
    }
    return _navigationBar;
}

- (INRecordVideoToolView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[INRecordVideoToolView alloc] initWithFrame:CGRectZero];
        _toolBar.userInteractionEnabled = YES;
    }
    return _toolBar;
}

- (UIView *)focusView{
    if (!_focusView) {
        _focusView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _focusView.frame = CGRectMake(0.0, 0.0, kVideoFocusSize, kVideoFocusSize);
        _focusView.userInteractionEnabled = YES;
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor = [UIColor colorWithHexString:@"55dd87"].CGColor;
    }
    return _focusView;
}


@end
