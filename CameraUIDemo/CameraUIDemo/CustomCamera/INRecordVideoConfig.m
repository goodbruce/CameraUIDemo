//
//  INRecordVideoConfig.m
//  AppDemo
//
//  Created by 1 on 2019/3/8.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INRecordVideoConfig.h"

@interface INRecordVideoConfig ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@end

@implementation INRecordVideoConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isInRecording = NO;
        [self setupRecordVideo];
    }
    return self;
}

- (void)setupRecordVideo {
    self.recordQueue = dispatch_queue_create("com.video.record", DISPATCH_QUEUE_SERIAL);
    
    NSArray *deviceVideo = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    NSArray *deviceAudio = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:deviceVideo[0] error:nil];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:deviceAudio[0] error:nil];
    
    self.videoDevice = deviceVideo[0];
    
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoDataOutput.videoSettings = @{(__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.recordQueue];
    
    
    self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    [self.audioDataOutput setSampleBufferDelegate:self queue:self.recordQueue];

    
    self.videoSession = [[AVCaptureSession alloc] init];
    if ([self.videoSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        self.videoSession.sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    if ([self.videoSession canAddInput:videoInput]) {
        [self.videoSession addInput:videoInput];
    }
    if ([self.videoSession canAddInput:audioInput]) {
        [self.videoSession addInput:audioInput];
    }
    if ([self.videoSession canAddOutput:self.videoDataOutput]) {
        [self.videoSession addOutput:self.videoDataOutput];
    }
    if ([self.videoSession canAddOutput:self.audioDataOutput]) {
        [self.videoSession addOutput:self.audioDataOutput];
    }
    
    self.videoDeviceInput = videoInput;
    self.audioDeviceInput = audioInput;

    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.videoSession];
    self.videoPreviewLayer.frame = CGRectMake(0.0, 0.0, KVRScreenWidth, KVRScreenHeight);
    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

/**
 开始session running
 */
- (void)startSessionRunning {
    [self.videoSession startRunning];
}

/**
 结束session running
 */
- (void)stopSessionRunning {
    [self.videoSession stopRunning];
}

/**
 聚焦
 
 @param point point
 */
- (void)focusForTouchPoint:(CGPoint)point {
    
    if ([self.videoDevice lockForConfiguration:nil]) {
        
        if ([self.videoDevice isFocusPointOfInterestSupported]) {
            self.videoDevice.focusPointOfInterest = point;
        }
        
        if ([self.videoDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.videoDevice setFocusPointOfInterest:point];
            [self.videoDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.videoDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.videoDevice setExposurePointOfInterest:point];
            //曝光量调节
            [self.videoDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        if ([self.videoDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            self.videoDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
        }
        
        [self.videoDevice unlockForConfiguration];
    }
}

/**
 切换设备的摄像头
 */
- (void)changedDeviceCamera {
    // 获取摄像头数量
    NSInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount <= 1) {
        return;
    }
    
    AVCaptureDevice *tmpVideoDevice = nil;
    // 获取当前摄像头的postion
    AVCaptureDevicePosition cameraPostion = [[self.videoDeviceInput device] position];
    switch (cameraPostion) {
        case AVCaptureDevicePositionFront: {
            //当前是前置摄像头，切换成后置摄像头
            tmpVideoDevice = [self deviceWithPostion:AVCaptureDevicePositionBack];
        }
            break;
            
        case AVCaptureDevicePositionBack: {
            //当前是后置摄像头，切换成前置摄像头
            tmpVideoDevice = [self deviceWithPostion:AVCaptureDevicePositionFront];
        }
            break;
            
        default:
            break;
    }
    
    //输入流
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:tmpVideoDevice error:nil];
    
    if (videoInput) {
        [self.videoSession beginConfiguration];
        
        // 移除原先的input
        [self.videoSession removeInput:self.videoDeviceInput];
        
        if ([self.videoSession canAddInput:videoInput]) {
            [self.videoSession addInput:videoInput];
            self.videoDeviceInput = videoInput;
        } else {
            // 如果不能添加新的input, 继续使用之前的input
            [self.videoSession addInput:self.videoDeviceInput];
        }
        
        [self.videoSession commitConfiguration];
    }
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
 根据前置或者后置摄像头 获取device
 
 @param postion posttion
 @return device
 */
- (AVCaptureDevice *)deviceAudioWithPostion:(AVCaptureDevicePosition)postion {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
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
 配置手电筒开关
 
 @param on 是否开启
 */
- (void)configFlashlightOn:(BOOL)on {
    if ([self.videoDevice hasTorch] && [self.videoDevice hasFlash]) {
        [self.videoDevice lockForConfiguration:nil];
        if (on) {
            [self.videoDevice setTorchMode:AVCaptureTorchModeOn];
        } else {
            [self.videoDevice setTorchMode:AVCaptureTorchModeOff];
        }
        [self.videoDevice unlockForConfiguration];
    }
}

/**
 双击是放大，缩小录制
 */
- (void)doubleClickZoomVideo {
    if ([self.videoDevice lockForConfiguration:nil]) {
        CGFloat zoom = self.videoDevice.videoZoomFactor == 2.0?1.0:2.0;
        self.videoDevice.videoZoomFactor = zoom;
        [self.videoDevice unlockForConfiguration];
    }
}

/**
 开始录制
 
 @param model model
 */
- (void)startRecordAssetWriter:(INVideoModel *)model {
    NSError *error = nil;
    self.assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:model.videoUrl] fileType:AVFileTypeMPEG4 error:&error];
    
    // 视频尺寸的小知识，视频的宽高都必须是16的整数倍,否则经过AVFoundation的API合成后系统会自动对尺寸进行校正，不足的地方会以绿边的形式进行填充。
    
    int videoWidth = floor(KVRScreenWidth/16.0)*16;
    int videoHeight = floor(KVRScreenHeight/16.0)*16;
    
    NSDictionary *outputSettings = @{
                                     AVVideoCodecKey : AVVideoCodecH264,
                                     AVVideoWidthKey : @(videoHeight),
                                     AVVideoHeightKey : @(videoWidth),
                                     AVVideoScalingModeKey:AVVideoScalingModeResizeAspectFill,
                                     //                          AVVideoCompressionPropertiesKey:codecSettings
                                     };
    self.assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
    self.assetWriterVideoInput.expectsMediaDataInRealTime = YES; // 设置数据为实时输入
    self.assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
    
    
    NSDictionary *audioOutputSettings = @{
                                          AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                          AVEncoderBitRateKey:@(64000),
                                          AVSampleRateKey:@(44100),
                                          AVNumberOfChannelsKey:@(1),
                                          };
    
    self.assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioOutputSettings];
    self.assetWriterAudioInput.expectsMediaDataInRealTime = YES;
    
    
    NSDictionary *SPBADictionary = @{
                                     (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange),
                                     (__bridge NSString *)kCVPixelBufferWidthKey : @(videoWidth),
                                     (__bridge NSString *)kCVPixelBufferHeightKey  : @(videoHeight),
                                     (__bridge NSString *)kCVPixelFormatOpenGLESCompatibility : ((__bridge NSNumber *)kCFBooleanTrue)
                                     };
    self.writerInputPixelBufferAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.assetWriterVideoInput sourcePixelBufferAttributes:SPBADictionary];
    if ([self.assetWriter canAddInput:self.assetWriterVideoInput]) {
        [self.assetWriter addInput:self.assetWriterVideoInput];
    } else {
        NSLog(@"不能添加视频writer的input \(assetWriterVideoInput)");
    }
    
    if ([self.assetWriter canAddInput:self.assetWriterAudioInput]) {
        [self.assetWriter addInput:self.assetWriterAudioInput];
    } else {
        NSLog(@"不能添加视频writer的input \(assetWriterVideoInput)");
    }
    
    if(error) {
        NSLog(@"error = %@", [error localizedDescription]);
    }
    
    NSLog(@"_assetWriter = %ld",(long)self.assetWriter.status);
}

/**
 结束录制，保存
 
 @param model model
 @param completion 完成
 */
- (void)stopRecordAssetWriter:(INVideoModel *)model completion:(void (^)(void))completion {
    if (self.isInRecording) {
        if (completion) {
            completion();
        }
        return;
    }
    
    dispatch_async(self.recordQueue, ^{
        [self.assetWriter finishWritingWithCompletionHandler:^{
            NSURL *outputFileURL = [NSURL fileURLWithPath:model.videoUrl];

            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (!error && success) {
                    NSLog(@"保存相册成功");
                } else {
                    NSLog(@"保存相册失败! :%@",error);
                }
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
        }];
    });
}

/**
 将合成的视频保存到相册
 
 @param videoUrl 本地视频地址
 @param completion 完成
 */
- (void)saveMergeVideoToAblum:(NSString *)videoUrl completion:(void (^)(void))completion {
    dispatch_async(self.recordQueue, ^{
        NSURL *outputFileURL = [NSURL fileURLWithPath:videoUrl];
            
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (!error && success) {
                NSLog(@"保存相册成功");
            } else {
                NSLog(@"保存相册失败! :%@",error);
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

/**
 合成视频
 
 @param videos 多个视频
 @param targetUrl 合成的目标url
 @param completion 完成
 */
- (void)mergeVideoWithVideos:(NSArray *)videos targetUrl:(NSString *)targetUrl completion:(void (^)(void))completion {
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // 合成方向处理, iOS视频合成旋转90度解决
    compositionTrack.preferredTransform =  CGAffineTransformMakeRotation(M_PI/2);
    

    for (NSInteger index = videos.count - 1; index >= 0; index--) {
        INVideoModel *model = [videos objectAtIndex:index];
        AVURLAsset *videoAsset =[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:model.videoUrl] options:nil];
        [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
    }
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *ducumentDirectory = [paths objectAtIndex:0];
//    NSString *myPathDocs = [ducumentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d-%@.mp4",arc4random() % 1000,[INDocPathUtils getFilePathName]]];
//    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    NSURL *outputUrl = [NSURL fileURLWithPath:targetUrl];

    AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    export.outputURL = outputUrl;
    export.outputFileType = AVFileTypeMPEG4;
    export.shouldOptimizeForNetworkUse = YES;
    [export exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self exportDidFinish:export];
            if (completion) {
                completion();
            }
        });
    }];
}

/**
 合成视频的背景音乐
 
 @param outputVideoURL 合成后的视频本地地址
 @param sourceVideoUrl 视频本地地址
 @param musicUrl 音乐本地地址
 @param completion 完成
 */
- (void)mergeVideoBackgroupMusic:(NSString *)outputVideoURL sourceVideoUrl:(NSString *)sourceVideoUrl musicUrl:(NSString *)musicUrl completion:(void (^)(void))completion {
    //可变音视频组合
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:sourceVideoUrl] options:nil];
    
    //视频时间
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);

    //可变视频轨
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    //把素材轨道添加到可变的视频轨道中去
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    
    // 合成方向处理, iOS视频合成旋转90度解决
    videoTrack.preferredTransform =  CGAffineTransformMakeRotation(M_PI/2);
    
    //声音采集
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:musicUrl] options:nil];
    //音频轨道
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:videoTimeRange ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:1.0 atTime:videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    //防止合成后的视频旋转90度
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    //创建输出
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    assetExport.outputURL = [NSURL fileURLWithPath:outputVideoURL];//输出路径
    assetExport.outputFileType = AVFileTypeMPEG4;//输出类型
    assetExport.shouldOptimizeForNetworkUse = YES;
    //assetExport.videoComposition = mainCompositionInst;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (!self.isInRecording) {
        return;
    }
    
    @autoreleasepool {
        self.currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer);
        if (self.assetWriter.status != AVAssetWriterStatusWriting) {
            [self.assetWriter startWriting];
            [self.assetWriter startSessionAtSourceTime:self.currentSampleTime];
        }
        if (captureOutput == self.videoDataOutput) {
            if (self.writerInputPixelBufferAdaptor.assetWriterInput.isReadyForMoreMediaData) {
                CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                BOOL success = [self.writerInputPixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:self.currentSampleTime];
                if (!success) {
                    NSLog(@"Pixel Buffer没有append成功");
                }
            }
        }
        if (captureOutput == self.audioDataOutput) {
            [self.assetWriterAudioInput appendSampleBuffer:sampleBuffer];
        }
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
}

- (NSMutableArray *)videoModels {
    if (!_videoModels) {
        _videoModels = [NSMutableArray arrayWithCapacity:0];
    }
    return _videoModels;
}

@end
