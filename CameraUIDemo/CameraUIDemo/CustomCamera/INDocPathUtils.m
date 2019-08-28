//
//  INDocPathUtils.m
//  AppDemo
//
//  Created by 1 on 2019/3/4.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INDocPathUtils.h"

@implementation INDocPathUtils

/**
 文件路径名称
 
 @return 路径
 */
+ (NSString *)getFilePathName {
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%lld",timestamp];
    return timeString;
}

/**
 document文件路径
 
 @return document路径
 */
+ (NSString *)getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

/**
 Library文件路径
 
 @return Library路径
 */
+ (NSString *)getDirLibraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

/**
 chache文件路径
 
 @return cache路径
 */
+ (NSString *)getDirCachePath {
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [cacPath objectAtIndex:0];
}

/**
 临时文件路径
 
 @return 临时文件路径
 */
+ (NSString *)dirTmpPath {
    return  NSTemporaryDirectory();
}

/**
 document文件路径
 
 @return document路径
 */
+ (NSString *)creatFolder:(NSString *)folderName at:(NSString *)dirPath {
    
    NSString *temDirectory = [dirPath stringByAppendingPathComponent:folderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建目录
    BOOL res=[fileManager createDirectoryAtPath:temDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        return temDirectory;
    }else{
        return temDirectory;
    }
}

/**
 合成视频存储的路径
 
 @return document路径
 */
+ (NSString *)getMergeVideoUrl {
    //创建视频文件路径
    NSString *filepathName = [NSString stringWithFormat:@"%@",[INDocPathUtils getFilePathName]];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",filepathName];
    NSString *fileFolder = [INDocPathUtils creatFolder:@"mergeVideo" at:[INDocPathUtils getDocumentPath]];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",fileFolder, fileName];
    return filePath;
}

/**
 合成视频与背景音乐的存储的路径
 
 @return document路径
 */
+ (NSString *)getMergeBackgroundMusicVideoUrl {
    //创建视频文件路径
    NSString *filepathName = [NSString stringWithFormat:@"%@",[INDocPathUtils getFilePathName]];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",filepathName];
    NSString *fileFolder = [INDocPathUtils creatFolder:@"mergeMusicVideo" at:[INDocPathUtils getDocumentPath]];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",fileFolder, fileName];
    return filePath;
}

/**
 获取临时文件路径
 
 @param filePathName 文件名
 @return 路径
 */
+ (NSString *)tempVideoFilePath:(NSString *)filePathName {
    // 获取沙盒 temp 路径
    NSString *tempPath = NSTemporaryDirectory();
    tempPath = [tempPath stringByAppendingPathComponent:@"Video"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 判断文件夹是否存在 不存在创建
    BOOL exits = [manager fileExistsAtPath:tempPath isDirectory:nil];
    if (!exits) {
        
        // 创建文件夹
        [manager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 创建视频存放路径
    tempPath = [tempPath stringByAppendingPathComponent:filePathName];
    
    // 判断文件是否存在
    if ([manager fileExistsAtPath:tempPath isDirectory:nil]) {
        // 存在 删除之前的视频
        [manager removeItemAtPath:tempPath error:nil];
    }
    
    return tempPath;
}

@end
