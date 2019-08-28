//
//  INCameraManager.h
//  AppDemo
//
//  Created by 1 on 2019/3/1.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//引入相机框架
#import <AVFoundation/AVFoundation.h>
//引入相册框架
#import <Photos/Photos.h>
#import "INDocPathUtils.h"

#define KSysScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KSysScreenHeight  [UIScreen mainScreen].bounds.size.height
#define KSysStatusBarHeight  CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)

/**
 视频录制结束的结果

 @param videoOutUrl 视频本地地址URL
 @param thumbnailImage 缩略图
 */
typedef void(^INVideoRecordCompletion)(NSURL *videoOutUrl, UIImage *thumbnailImage);

/**
 闪光灯，关闭，开启，自动
 */
typedef NS_ENUM(NSUInteger, INCameraConfigFlashMode) {
    INCameraConfigFlashModeOff  = 0,    // 闪光灯关闭
    INCameraConfigFlashModeOn   = 1,    // 闪光灯开启
    INCameraConfigFlashModeAuto = 2,    // 闪光灯自动
} ;

@interface INCameraConfig : NSObject

/**
 闪光灯，关闭，开启，自动
 */
@property (nonatomic, assign) INCameraConfigFlashMode flashMode;

/**
 捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
 */
@property (nonatomic, strong) AVCaptureDevice *device;

/**
 AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;

/**
 视频文件URL地址
 */
@property (nonatomic, strong) NSURL *movieFileOutURL;

/**
 视频文件输出
 */
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;

/**
 视频录制结果实现
 */
@property (nonatomic, copy) INVideoRecordCompletion videoRecordCompletion;


/**
 照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;

/**
 session 把输入输出结合在一起，并开始启动捕获设备（摄像头）
 */
@property (nonatomic, strong) AVCaptureSession *session;

/**
 图像预览层，实时显示捕获的图像
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


/**
 创建manager

 @param superView 父控件
 @return id 对象
 */
- (instancetype)initWithSuperView:(UIView *)superView;

/**
 根据前置或者后置摄像头 获取device

 @param postion posttion
 @return device
 */
- (AVCaptureDevice *)deviceWithPostion:(AVCaptureDevicePosition)postion;


/**
 开始视频录制
 */
- (void)startVideoRecord;

/**
 停止视频录制
 */
- (void)stopVideoRecord;

#pragma mark- 手电筒开关
/**
 配置手电筒开关
 
 @param on 是否开启
 */
- (void)configFlashlightOn:(BOOL)on;

#pragma mark- 获取视频帧图
/**
 获取第一帧图
 
 @param videoURL videoUrl
 @return image
 */
- (UIImage *)getVideoThumbImage:(NSURL *)videoURL;

@end
