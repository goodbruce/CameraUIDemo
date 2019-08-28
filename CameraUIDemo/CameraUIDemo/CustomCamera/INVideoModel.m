//
//  INVideoModel.m
//  AppDemo
//
//  Created by 1 on 2019/3/8.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INVideoModel.h"

@implementation INVideoModel

+ (instancetype)createVideoModel {
    INVideoModel *videoModel = [[INVideoModel alloc] init];
    
    //创建视频文件路径
    NSString *filepathName = [NSString stringWithFormat:@"%@",[INDocPathUtils getFilePathName]];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",filepathName];
    NSString *fileFolder = [INDocPathUtils creatFolder:@"video" at:[INDocPathUtils getDocumentPath]];
    NSString *videoUrl = [NSString stringWithFormat:@"%@/%@",fileFolder, fileName];
    
    NSString *imagefileFolder = [INDocPathUtils creatFolder:@"image" at:[INDocPathUtils getDocumentPath]];
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",imagefileFolder, fileName];

    videoModel.videoUrl = videoUrl;
    videoModel.videoThumbImageUrl = imageUrl;

    
    return videoModel;
}

@end
