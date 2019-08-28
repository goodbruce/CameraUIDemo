//
//  INVideoPlayerConfig.h
//  AppDemo
//
//  Created by 1 on 2019/3/4.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface INVideoPlayerConfig : NSObject

@property (nonatomic, strong) AVPlayer *player;

- (void)playWithUrl:(NSURL *)url superView:(UIView *)view frame:(CGRect)frame;

- (void)stopPlay;

@end
