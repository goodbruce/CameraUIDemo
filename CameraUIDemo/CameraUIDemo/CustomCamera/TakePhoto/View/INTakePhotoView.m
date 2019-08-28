//
//  INTakePhotoView.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INTakePhotoView.h"
#import "UIColor+Addition.h"

static CGFloat kTakeToolHeight = 130.0;
static CGFloat kFocusSize = 50.0;
static CGFloat kCloseBtnSize = 30.0;
static CGFloat kTPhotoBtnSize = 60.0;
static CGFloat kPPadding = 15.0;

static CGFloat kFlastBtnSize = 50.0;
static CGFloat kChangedBtnSize = 50.0;

@interface INTakePhotoView ()<INTakePhotoShowViewDelegate>

@end

@implementation INTakePhotoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.cameraConfig = [[INCameraConfig alloc] initWithSuperView:self];

        [self addSubview:self.focusView];
        self.focusView.hidden = YES;
        
        [self addSubview:self.takeBGImageView];
        [self.takeBGImageView addSubview:self.closeButton];
        [self.takeBGImageView addSubview:self.photoButton];
        
        [self addSubview:self.flashButton];
        [self addSubview:self.changedButton];
        
        [self addSubview:self.showPhotoView];
        self.showPhotoView.hidden = YES;
        self.showPhotoView.subDelegate = self;
        
        [self addGestureRecognizer];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.takeBGImageView.frame = CGRectMake(0.0, CGRectGetHeight(self.bounds) - kTakeToolHeight,  CGRectGetWidth(self.bounds), kTakeToolHeight);
    
    self.closeButton.frame = CGRectMake(kPPadding, (CGRectGetHeight(self.takeBGImageView.frame) - kCloseBtnSize)/2, kCloseBtnSize, kCloseBtnSize);
    
    self.photoButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - kTPhotoBtnSize)/2, (CGRectGetHeight(self.takeBGImageView.frame) - kTPhotoBtnSize)/2, kTPhotoBtnSize, kTPhotoBtnSize);
    
    self.flashButton.frame = CGRectMake(kPPadding, KSysStatusBarHeight + kPPadding, kFlastBtnSize, kFlastBtnSize);
    
    self.changedButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - kChangedBtnSize - kPPadding, KSysStatusBarHeight + kPPadding, kChangedBtnSize, kChangedBtnSize);
    
    self.showPhotoView.frame = self.bounds;
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
- (void)takePhotoButtonAction {
    AVCaptureConnection *videoConnection = [self.cameraConfig.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.cameraConfig.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            weakSelf.showPhotoView.photoImageView.image = [UIImage imageWithData:imageData];
            weakSelf.showPhotoView.hidden = NO;
            
            // 停止
            [weakSelf.cameraConfig.session stopRunning];
        }
    }];
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
    if ([self.cameraConfig.device lockForConfiguration:nil]) {
        // 转换顺序，关闭OFF - > 开启ON - >  自动AUTO - > 关闭OFF
        switch (self.cameraConfig.flashMode) {
            case INCameraConfigFlashModeOff: {
                // 当前闪光灯关闭，切换到 开启
                self.cameraConfig.flashMode = INCameraConfigFlashModeOn;
                [self.cameraConfig.device setFlashMode:AVCaptureFlashModeOn];
                
                // 更改显示按钮
                [self.flashButton setImage:[UIImage imageNamed:@"ic_flash_03_36x36_"] forState:UIControlStateNormal];
            }
                break;
                
            case INCameraConfigFlashModeOn: {
                // 当前闪光灯开启，切换到 自动
                self.cameraConfig.flashMode = INCameraConfigFlashModeAuto;
                [self.cameraConfig.device setFlashMode:AVCaptureFlashModeAuto];
                
                // 更改显示按钮
                [self.flashButton setImage:[UIImage imageNamed:@"ic_flash_02_36x36_"] forState:UIControlStateNormal];
            }
                break;
                
            case INCameraConfigFlashModeAuto: {
                // 当前闪光灯自动，切换到 关闭
                self.cameraConfig.flashMode = INCameraConfigFlashModeOff;
                [self.cameraConfig.device setFlashMode:AVCaptureFlashModeOff];
                
                // 更改显示按钮
                [self.flashButton setImage:[UIImage imageNamed:@"ic_flash_04_36x36_"] forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        
        [self.cameraConfig.device unlockForConfiguration];
    }
}

/**
 代理方法
 */
#pragma mark - 显示图片，确认是否需要重拍或者使用该图片
/**
 使用图片
 */
- (void)useButtonDidAction {
    
}

/**
 重拍按钮
 */
- (void)retakeButtonDidAction {
    self.showPhotoView.hidden = YES;
    self.showPhotoView.photoImageView.image = nil;
    
    // 重新启动
    [self.cameraConfig.session startRunning];
}

#pragma mark - SETTER/GETTER
- (UIImageView *)takeBGImageView {
    if (!_takeBGImageView) {
        _takeBGImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _takeBGImageView.userInteractionEnabled = YES;
        _takeBGImageView.backgroundColor = [UIColor clearColor];
//        _takeBGImageView.backgroundColor = [UIColor colorWithHexString:@"39ADED"];
    }
    return _takeBGImageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"video_cancel_40x40_"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)photoButton {
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(takePhotoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
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
        [_flashButton addTarget:self action:@selector(flashButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashButton;
}

- (INTakePhotoShowView *)showPhotoView {
    if (!_showPhotoView) {
        _showPhotoView = [[INTakePhotoShowView alloc] initWithFrame:CGRectZero];
    }
    return _showPhotoView;
}

@end
