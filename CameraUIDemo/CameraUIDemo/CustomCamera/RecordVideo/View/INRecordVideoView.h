//
//  INRecordVideoView.h
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Addition.h"
#import "INCameraConfig.h"
#import "INRecordVideoNavigationView.h"
#import "INRecordVideoToolView.h"
#import "INRecordVideoConfig.h"

@protocol INRecordVideoViewDelegate;
@interface INRecordVideoView : UIView

@property (nonatomic, weak) id delegate;

@property (nonatomic, weak) id<INRecordVideoViewDelegate>actionDelegate;

@property (nonatomic, strong) INRecordVideoConfig *recordVideoConfig;


@property (nonatomic, strong) UIImageView *focusView;

/**
 顶部导航
 */
@property (nonatomic, strong) INRecordVideoNavigationView *navigationBar;

/**
 底部工具栏
 */
@property (nonatomic, strong) INRecordVideoToolView *toolBar;

- (id)initWithFrame:(CGRect)frame;

@end

/**
 代理方法
 */
@protocol INRecordVideoViewDelegate <NSObject>

/**
 关闭
 */
- (void)closeButtonDidAction;

@end
