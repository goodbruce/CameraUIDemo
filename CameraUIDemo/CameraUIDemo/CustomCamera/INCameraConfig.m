//
//  INCameraManager.m
//  AppDemo
//
//  Created by 1 on 2019/3/1.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INCameraConfig.h"

@interface INCameraConfig () <AVCaptureFileOutputRecordingDelegate>

/**
 显示的控件的superView
 */
@property (nonatomic, strong) UIView *superView;

@end

@implementation INCameraConfig

/**
 创建manager
 
 @param superView 父控件
 @return id 对象
 */
- (instancetype)initWithSuperView:(UIView *)superView {
    self = [super init];
    if (self) {
        self.flashMode = INCameraConfigFlashModeOff;
        self.superView = superView;
        [self.superView.layer addSublayer:self.previewLayer];
        
        // 默认闪光灯为关闭状态
        if ([self.device lockForConfiguration:nil]) {
            [self.device setFlashMode:AVCaptureFlashModeOff];
            [self.device unlockForConfiguration];
        }
    }
    return self;
}

/**
 根据前置或者后置摄像头 获取device
 
 @param postion posttion
 @return device
 */
- (AVCaptureDevice *)deviceWithPostion:(AVCaptureDevicePosition)postion {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *aDevice = nil;
    for (AVCaptureDevice *device in devices) {
        if (device.position == postion) {
            aDevice = device;
            break;
        }
    }
    return aDevice;
}

/**
 开始视频录制
 */
- (void)startVideoRecord {
    AVCaptureConnection *videoConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    //设置捕捉视频方向
    if([videoConnection isVideoOrientationSupported])  {
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    //    预览图层和视频方向保持一致
    //    videoConnection.videoOrientation = [self.previewLayer connection].videoOrientation;
    //    防抖
    //    if ([videoConnection isVideoStabilizationSupported ]) {
    //        videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    //    }
    
    //创建视频文件路径
    NSString *filepathName = [NSString stringWithFormat:@"%@",[INDocPathUtils getFilePathName]];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",filepathName];
    NSString *fileFolder = [INDocPathUtils creatFolder:@"INVideoRecord" at:[INDocPathUtils getDocumentPath]];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",fileFolder, fileName];
    [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath] recordingDelegate:self];
    //        //播放开始提示音
    //    AudioServicesPlaySystemSound(1117);
}

/**
 停止视频录制
 */
- (void)stopVideoRecord {
    [self.movieFileOutput stopRecording];
}

#pragma mark - 视频录制代理DELEGATE
/**
 视频录制结束录制，录制完成
 */
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    NSLog(@"outputFileURL:%@||error:%@",outputFileURL,error);
    self.movieFileOutURL = outputFileURL;
    UIImage *thumbnailImage = [self getVideoThumbImage:outputFileURL];
    NSLog(@"thumbnailImage:%@",thumbnailImage);
    if (self.videoRecordCompletion) {
        self.videoRecordCompletion(self.movieFileOutURL, thumbnailImage);
    }
}

/**
 视频录制开始录制
 */
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    // 视频录制开始录制
}

#pragma mark- 手电筒开关
/**
 配置手电筒开关

 @param on 是否开启
 */
- (void)configFlashlightOn:(BOOL)on {
    if ([self.device hasTorch] && [self.device hasFlash]) {
        [self.device lockForConfiguration:nil];
        if (on) {
            [self.device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [self.device setTorchMode:AVCaptureTorchModeOff];
        }
        [self.device unlockForConfiguration];
    }
}

#pragma mark- 获取视频帧图
/**
 获取第一帧图
 
 @param videoURL videoUrl
 @return image
 */
- (UIImage *)getVideoThumbImage:(NSURL *)videoURL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    return image;
}

#pragma mark- 检测相机权限
/**
 检测相机权限

 @return YES 有权限/
 */
- (BOOL)checkCameraPermission {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
    return YES;
}

#pragma mark - SETTER/GETTER
- (AVCaptureDevice *)device {
    if (!_device) {
        // 使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input {
    if (!_input) {
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    }
    return _input;
}

- (AVCaptureStillImageOutput *)imageOutput {
    if (!_imageOutput) {
        _imageOutput = [[AVCaptureStillImageOutput alloc] init];
    }
    return _imageOutput;
}

- (AVCaptureMovieFileOutput *)movieFileOutput {
    if (!_movieFileOutput) {
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    }
    return _movieFileOutput;
}

- (AVCaptureSession *)session {
    if (!_session) {
        //生成会话，用来结合输入输出
        _session = [[AVCaptureSession alloc]init];
//        if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
//            [_session setSessionPreset:AVCaptureSessionPreset1280x720];
//        }
        
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        
        // 输出图片
        if ([_session canAddOutput:self.imageOutput]) {
            [_session addOutput:self.imageOutput];
        }
        
        // 输出视频
        if ([_session canAddOutput:self.movieFileOutput]) {
            [_session addOutput:self.movieFileOutput];
        }
        
        //添加一个音频输入设备
        NSError *error = nil;
        AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
        if (error == nil) {
            [_session addInput:audioCaptureDeviceInput];
        }
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        _previewLayer.frame = CGRectMake(0, 0, KSysScreenWidth, KSysScreenHeight);
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

@end
