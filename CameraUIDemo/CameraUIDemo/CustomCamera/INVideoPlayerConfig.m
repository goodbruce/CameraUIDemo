//
//  INVideoPlayerConfig.m
//  AppDemo
//
//  Created by 1 on 2019/3/4.
//  Copyright © 2019 bruce. All rights reserved.
//

#import "INVideoPlayerConfig.h"

@interface INVideoPlayerConfig ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation INVideoPlayerConfig

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)playWithUrl:(NSURL *)url superView:(UIView *)view frame:(CGRect)frame {
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player replaceCurrentItemWithPlayerItem:item];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer = playerLayer;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.frame = frame;
    
    [view.layer insertSublayer:playerLayer atIndex:0];
    
    [self.player play];
}

- (void)replay {
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

- (void)stopPlay {
    [self.player pause];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *playerItem = object;
    AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
    if(status == AVPlayerStatusReadyToPlay){
        NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
    }
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

- (void)dealloc {
    [self.playerLayer removeFromSuperlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
