//
//  INVideoUtils.h
//  AppDemo
//
//  Created by 1 on 2019/3/5.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "INDocPathUtils.h"

@interface INVideoUtils : NSObject

/**
 根据时间裁剪
 
 @param avAsset avAsset
 @param startTime 起始时间
 @param endTime 结束时间
 @param completion 回调视频url
 */
+ (void)cutVideoWithAVAsset:(AVAsset *)avAsset startTime:(CGFloat)startTime endTime:(CGFloat)endTime completion:(void (^)(NSURL *outputURL))completion;

@end
