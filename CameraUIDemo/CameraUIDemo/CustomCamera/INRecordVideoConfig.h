//
//  INRecordVideoConfig.h
//  AppDemo
//
//  Created by 1 on 2019/3/8.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//引入相机框架
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "INVideoModel.h"

#define KVRScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KVRScreenHeight  [UIScreen mainScreen].bounds.size.height
#define KVRStatusBarHeight  CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)

/**
 录制视频配置
 */
@interface INRecordVideoConfig : NSObject

/**
 录制视频队列
 */
@property (nonatomic) dispatch_queue_t recordQueue;

/**
 输入输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession *videoSession;

/**
 图片预览层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

/**
 视频input
 */
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;

/**
 语音input
 */
@property (nonatomic, strong) AVCaptureDeviceInput *audioDeviceInput;

/**
 输入设备(麦克风,相机等)
 */
@property (nonatomic, strong) AVCaptureDevice *videoDevice;

/**
 视频data输出
 */
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

/**
 音频data输出
 */
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;

/**
 AVassetReader 的输出(AVAssetReaderTrackOutput) 通过回调 写成文件.
 */
@property (nonatomic, strong) AVAssetWriter *assetWriter;

/**
 BufferAdaptor
 */
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *writerInputPixelBufferAdaptor;

/**
 视频输入
 */
@property (nonatomic, strong) AVAssetWriterInput *assetWriterVideoInput;

/**
 音频输入
 */
@property (nonatomic, strong) AVAssetWriterInput *assetWriterAudioInput;

/**
 CMTime
 */
@property (nonatomic) CMTime currentSampleTime;

/**
 是否是在录制中
 */
@property (nonatomic, assign) BOOL isInRecording;

/**
 多段视频的model
 */
@property (nonatomic, strong) NSMutableArray *videoModels;

/**
 合成多个视频的目标地址
 */
@property (nonatomic, strong) NSString *mergeVideoTargetUrl;

/**
 合成背景音乐的视频的目标地址
 */
@property (nonatomic, strong) NSString *mergeBackgroundMusicVideoTargetUrl;

/**
 聚焦

 @param point point
 */
- (void)focusForTouchPoint:(CGPoint)point;

/**
 切换设备的摄像头
 */
- (void)changedDeviceCamera;

/**
 根据前置或者后置摄像头 获取device
 
 @param postion posttion
 @return device
 */
- (AVCaptureDevice *)deviceWithPostion:(AVCaptureDevicePosition)postion;

/**
 根据前置或者后置摄像头 获取device
 
 @param postion posttion
 @return device
 */
- (AVCaptureDevice *)deviceAudioWithPostion:(AVCaptureDevicePosition)postion;

/**
 配置手电筒开关
 
 @param on 是否开启
 */
- (void)configFlashlightOn:(BOOL)on;

/**
 双击是放大，缩小录制
 */
- (void)doubleClickZoomVideo;

/**
 开始session running
 */
- (void)startSessionRunning;

/**
 结束session running
 */
- (void)stopSessionRunning;

/**
 开始录制

 @param model model
 */
- (void)startRecordAssetWriter:(INVideoModel *)model;

/**
 结束录制，保存

 @param model model
 @param completion 完成
 */
- (void)stopRecordAssetWriter:(INVideoModel *)model completion:(void (^)(void))completion;


/**
 合成视频

 @param videos 多个视频
 @param targetUrl 合成的目标url
 @param completion 完成
 */
- (void)mergeVideoWithVideos:(NSArray *)videos targetUrl:(NSString *)targetUrl completion:(void (^)(void))completion;

/**
 合成视频的背景音乐

 @param outputVideoURL 合成后的视频本地地址
 @param sourceVideoUrl 视频本地地址
 @param musicUrl 音乐本地地址
 @param completion 完成
 */
- (void)mergeVideoBackgroupMusic:(NSString *)outputVideoURL sourceVideoUrl:(NSString *)sourceVideoUrl musicUrl:(NSString *)musicUrl completion:(void (^)(void))completion;

/**
 将合成的视频保存到相册

 @param videoUrl 本地视频地址
 @param completion 完成
 */
- (void)saveMergeVideoToAblum:(NSString *)videoUrl completion:(void (^)(void))completion;

@end
