//
//  INDocPathUtils.h
//  AppDemo
//
//  Created by 1 on 2019/3/4.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INDocPathUtils : NSObject

/**
 文件路径名称

 @return 路径
 */
+ (NSString *)getFilePathName;

/**
 document文件路径
 
 @return document路径
 */
+ (NSString *)getDocumentPath;

/**
 Library文件路径
 
 @return Library路径
 */
+ (NSString *)getDirLibraryPath;

/**
 chache文件路径
 
 @return cache路径
 */
+ (NSString *)getDirCachePath;

/**
 临时文件路径
 
 @return 临时文件路径
 */
+ (NSString *)dirTmpPath;

/**
 document文件路径
 
 @return document路径
 */
+ (NSString *)creatFolder:(NSString *)folderName at:(NSString *)dirPath;

/**
 合成视频存储的路径
 
 @return document路径
 */
+ (NSString *)getMergeVideoUrl;

/**
 合成视频与背景音乐的存储的路径
 
 @return document路径
 */
+ (NSString *)getMergeBackgroundMusicVideoUrl;

/**
 获取临时文件路径

 @param filePathName 文件名
 @return 路径
 */
+ (NSString *)tempVideoFilePath:(NSString *)filePathName;

@end
