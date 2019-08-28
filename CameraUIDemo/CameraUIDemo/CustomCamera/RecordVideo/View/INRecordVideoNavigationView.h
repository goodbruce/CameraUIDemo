//
//  INRecordVideoNavigationView.h
//  AppDemo
//
//  Created by 1 on 2019/3/7.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INCameraConfig.h"

@protocol INRecordVideoNavigationViewDelegate;
@interface INRecordVideoNavigationView : UIView


@property (nonatomic, weak) id<INRecordVideoNavigationViewDelegate>subDelegate;


/**
 背景控件
 */
@property (nonatomic, strong) UIImageView *bgImageView;

/**
 灯光
 */
@property (nonatomic, strong) UIButton *lightButton;

/**
 关闭
 */
@property (nonatomic, strong) UIButton *closeButton;

/**
 切换前后置摄像头
 */
@property (nonatomic, strong) UIButton *changedButton;

+ (CGFloat)navigationHeight;

@end

/**
 代理方法
 */
@protocol INRecordVideoNavigationViewDelegate <NSObject>

/**
 关闭
 */
- (void)closeButtonDidAction;

/**
 更换摄像头
 */
- (void)changedButtonDidAction;

/**
 灯管
 */
- (void)lightButtonDidAction;

@end
