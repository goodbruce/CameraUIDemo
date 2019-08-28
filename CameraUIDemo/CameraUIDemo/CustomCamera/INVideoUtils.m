//
//  INVideoUtils.m
//  AppDemo
//
//  Created by 1 on 2019/3/5.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INVideoUtils.h"

@implementation INVideoUtils

/**
 根据时间裁剪
 
 @param avAsset avAsset
 @param startTime 起始时间
 @param endTime 结束时间
 @param completion 回调视频url
 */
+ (void)cutVideoWithAVAsset:(AVAsset *)avAsset startTime:(CGFloat)startTime endTime:(CGFloat)endTime completion:(void (^)(NSURL *outputURL))completion {
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        NSString *filtPath = [INDocPathUtils tempVideoFilePath:@"cutVideo.mp4"];
        NSURL *videoPath = [NSURL fileURLWithPath:filtPath];
        
        [self cutVideoWithAVAsset:avAsset startTime:startTime endTime:endTime filePath:videoPath completion:^(NSURL *outputURL) {
            
            if (completion) {
                completion(outputURL);
            }
        }];
    }
}

+ (void)cutVideoWithAVAsset:(AVAsset *)asset startTime:(CGFloat)startTime endTime:(CGFloat)endTime filePath:(NSURL *)filePath completion:(void (^)(NSURL *outputURL))completion
{
    // 1.将素材拖入素材库
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject]; // 视频轨迹
    
    AVAssetTrack *audioAssetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject]; // 音轨
    
    // 2.将素材的视频插入视频轨道 ，音频插入音轨
    
    AVMutableComposition *composition = [[AVMutableComposition alloc] init]; // AVAsset的子类
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid]; // 视频轨道
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil]; // 在视频轨道插入一个时间段的视频
    
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid]; // 音轨
    
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil]; // 插入音频数据，否则没有声音
    
    // 3. 裁剪视频，就是要将所有的视频轨道进行裁剪，就需要得到所有的视频轨道，而得到一个视频轨道就需要得到它上面的所有素材
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    CMTime totalDuration = CMTimeAdd(kCMTimeZero, asset.duration);
    
    CGFloat videoAssetTrackNaturalWidth = videoAssetTrack.naturalSize.width;
    CGFloat videoAssetTrackNatutalHeight = videoAssetTrack.naturalSize.height;
    
    CGSize renderSize = CGSizeMake(videoAssetTrackNaturalWidth, videoAssetTrackNatutalHeight);
    
    CGFloat renderW = MAX(renderSize.width, renderSize.height);
    
    CGFloat rate;
    
    rate = renderW / MIN(videoAssetTrackNaturalWidth, videoAssetTrackNatutalHeight);
    
    CGAffineTransform layerTransform = CGAffineTransformMake(videoAssetTrack.preferredTransform.a, videoAssetTrack.preferredTransform.b, videoAssetTrack.preferredTransform.c, videoAssetTrack.preferredTransform.d, videoAssetTrack.preferredTransform.tx * rate, videoAssetTrack.preferredTransform.ty * rate);
    
    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);
    
    [layerInstruction setTransform:layerTransform atTime:kCMTimeZero]; // 得到视频素材
    [layerInstruction setOpacity:0.0 atTime:totalDuration];
    
    AVMutableVideoCompositionInstruction *instrucation = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instrucation.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    instrucation.layerInstructions = @[layerInstruction];
    
    AVMutableVideoComposition *mainComposition = [AVMutableVideoComposition videoComposition];
    mainComposition.instructions = @[instrucation];
    mainComposition.frameDuration = CMTimeMake(1, 30);
    mainComposition.renderSize = CGSizeMake(renderW, renderW); // 裁剪出对应大小
    
    // 4. 导出
    CMTime start = CMTimeMakeWithSeconds(startTime, totalDuration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(endTime - startTime, totalDuration.timescale);
    
    CMTimeRange range = CMTimeRangeMake(start, duration);
    
    // 导出视频
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    session.videoComposition = mainComposition;
    session.outputURL = filePath;
    session.shouldOptimizeForNetworkUse = YES;
    session.outputFileType = AVFileTypeMPEG4;
    session.timeRange = range;
    
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        if ([session status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"%@",[NSThread currentThread]);
            NSLog(@"%@",session.outputURL);
            NSLog(@"导出成功");
            if (completion) {
                completion(session.outputURL);
            }
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"导出失败");
            });
        }
    }];
    
}

@end
