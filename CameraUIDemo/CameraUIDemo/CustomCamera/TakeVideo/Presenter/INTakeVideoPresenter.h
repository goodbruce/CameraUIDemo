//
//  INTakeVideoPresenter.h
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INTakeVideoView.h"
#import "INTakeVideoInteractor.h"

@interface INTakeVideoPresenter : NSObject <INTakeVideoViewDelegate>

@property (nonatomic, strong) INTakeVideoView *videoView;
@property (nonatomic, strong) INTakeVideoInteractor *videoInteractor;
@property (nonatomic, strong) INTakeVideoConfig *videoConfig;

@property (nonatomic, weak) UIViewController *controller;

@end
