//
//  INRecordVideoProgressView.m
//  AppDemo
//
//  Created by 1 on 2019/3/7.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INRecordVideoProgressView.h"

static CGFloat kFlickerImageSizeWidth = 4.0;
static CGFloat kFlickerImageSizeHeight = 6.0;

static CGFloat kProgressLineWidth = 2.0;

/**
 进度图片控件
 */
@implementation INRecordVideoProgressImageView

- (void)setHasDeleteSelected:(BOOL)hasDeleteSelected {
    _hasDeleteSelected = hasDeleteSelected;
    if (hasDeleteSelected) {
        self.backgroundColor = [UIColor colorWithHexString:@"ed5555"];
    }
}

@end

@interface INRecordVideoProgressView ()

/**
 储存的线条的数组
 */
@property (nonatomic, strong) NSMutableArray *lineViews;

@end

@implementation INRecordVideoProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.flickerImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgImageView.frame = self.bounds;
}

/**
 开始闪动动画
 */
- (void)startFlickAnimation {
    CABasicAnimation *animation = [INRecordVideoProgressView opacityAnimation:0.5];
    [self.flickerImageView.layer addAnimation:animation forKey:@"flickerAnimation"];
}

/**
 结束闪动动画
 */
- (void)stopFlickAnimation {
    [self.flickerImageView.layer removeAnimationForKey:@"flickerAnimation"];
}

/**
 新增录制进度控件
 */
- (void)addProgressView {
    INRecordVideoProgressImageView *lastImageView = nil;
    if (self.lineViews.count > 0) {
        lastImageView = (INRecordVideoProgressImageView *)self.lineViews.lastObject;
    }
    
    INRecordVideoProgressImageView *newImageView = [INRecordVideoProgressView progressImageView];
    newImageView.frame = CGRectMake(lastImageView?CGRectGetMaxX(lastImageView.frame) + kProgressLineWidth:0.0, 0.0, 0.0, CGRectGetHeight(self.bounds));
    [self addSubview:newImageView];
    [self.lineViews addObject:newImageView];
    
    self.flickerImageView.hidden = YES;
}

/**
 移除录制进度控件
 */
- (void)removeProgressView {
    UIImageView *lastImageView = nil;
    if (self.lineViews.count > 0) {
        lastImageView = (UIImageView *)self.lineViews.lastObject;
    }
    
    if (lastImageView) {
        [lastImageView removeFromSuperview];
    }
}

/**
 开始动画
 */
- (void)startProgressAnimation:(CGFloat)progress {
    if (progress > 1) {
        progress = 1.0;
    }
    
    if (progress < 0) {
        progress = 0.0;
    }
    
    INRecordVideoProgressImageView *lastImageView = nil;
    if (self.lineViews.count > 0) {
        lastImageView = (INRecordVideoProgressImageView *)self.lineViews.lastObject;
    }
    
    if (lastImageView) {
        CGRect animationFrame = lastImageView.frame;
//        animationFrame.size.width = (CGRectGetWidth(self.bounds) - animationFrame.origin.x)*progress;
        animationFrame.size.width = CGRectGetWidth(self.bounds)*progress;
        lastImageView.frame = animationFrame;
    }
}

/**
 结束进度动画
 */
- (void)stopProgressAnimation {
    INRecordVideoProgressImageView *lastImageView = nil;
    if (self.lineViews.count > 0) {
        lastImageView = (INRecordVideoProgressImageView *)self.lineViews.lastObject;
    }
    
    self.flickerImageView.hidden = NO;
    CGRect flickRect = self.flickerImageView.frame;
    if (lastImageView) {
        flickRect.origin.x = CGRectGetMaxX(lastImageView.frame) + kProgressLineWidth;
    } else {
        flickRect.origin.x = 0;
    }
    self.flickerImageView.frame = flickRect;
    [self startFlickAnimation];
}

/**
 删除最后一个进度控件
 */
- (void)deleteLastProgressImageView {
    INRecordVideoProgressImageView *lastImageView = nil;
    if (self.lineViews.count > 0) {
        lastImageView = (INRecordVideoProgressImageView *)self.lineViews.lastObject;
    }
    
    if (!lastImageView.hasDeleteSelected) {
        lastImageView.hasDeleteSelected = YES;
        self.flickerImageView.hidden = YES;
        [self stopFlickAnimation];
    } else {
        [lastImageView removeFromSuperview];
        [self.lineViews removeObject:lastImageView];
        
        INRecordVideoProgressImageView *preLastImageView = nil;
        if (self.lineViews.count > 0) {
            preLastImageView = (INRecordVideoProgressImageView *)self.lineViews.lastObject;
        }
        
        self.flickerImageView.hidden = NO;
        CGRect flickRect = self.flickerImageView.frame;
        if (preLastImageView) {
            flickRect.origin.x = CGRectGetMaxX(preLastImageView.frame) + kProgressLineWidth;
        } else {
            flickRect.origin.x = 0;
        }
        self.flickerImageView.frame = flickRect;
        [self startFlickAnimation];
        
    }
}

/**
 获取所有进度条的宽度
 */
- (CGFloat)getAllProgressWidth {
    CGFloat progressWidth = 0.0;
    INRecordVideoProgressImageView *preLastImageView = nil;
    if (self.lineViews.count > 0) {
        preLastImageView = (INRecordVideoProgressImageView *)self.lineViews.lastObject;
    }
    
    if (preLastImageView) {
        progressWidth = CGRectGetMaxX(preLastImageView.frame);
    }
    
    return progressWidth;
}

/**
 获取录制的秒数
 
 @return 秒数
 */
- (NSInteger)getRecondSecond {
    // 计算描述
    CGFloat width = [self getAllProgressWidth];
    CGFloat progressWidth = CGRectGetWidth(self.frame);
    NSInteger currentSecond = floor(width*INVIDEO_RECORD_MAX_TIME/progressWidth);
    NSInteger allSecond = floor(INVIDEO_RECORD_MAX_TIME);
    
    NSInteger videoSecond = currentSecond % allSecond;
    if (currentSecond == allSecond) {
        videoSecond = currentSecond;
    }
    
    return videoSecond;
}

/**
 判断是否结束录制了
 
 @return 是否结束录制视频
 */
- (BOOL)checkEndRecord {
    NSInteger recondSecond = [self getRecondSecond];
    if (recondSecond == INVIDEO_RECORD_MAX_TIME) {
        return YES;
    }
    
    return NO;
}

#pragma mark - SETTER/GETTER
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.backgroundColor = [UIColor clearColor];
    }
    return _bgImageView;
}

- (UIImageView *)flickerImageView {
    if (!_flickerImageView) {
        _flickerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kFlickerImageSizeWidth, kFlickerImageSizeHeight)];
        _flickerImageView.userInteractionEnabled = YES;
        _flickerImageView.backgroundColor = [UIColor whiteColor];
        _flickerImageView.layer.opacity = 0.0;
    }
    return _flickerImageView;
}

- (NSMutableArray *)lineViews {
    if (!_lineViews) {
        _lineViews = [NSMutableArray arrayWithCapacity:0];
    }
    return _lineViews;
}

/**
 进度控件
 
 @return view
 */
+ (INRecordVideoProgressImageView *)progressImageView {
    INRecordVideoProgressImageView *imageView = [[INRecordVideoProgressImageView alloc] initWithFrame:CGRectZero];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.clipsToBounds = YES;
    imageView.hasDeleteSelected = NO;
    return imageView;
}

/**
 永久闪烁的动画

 @param time 时间
 @return 动画
 */
+ (CABasicAnimation *)opacityAnimation:(float)time {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

@end
