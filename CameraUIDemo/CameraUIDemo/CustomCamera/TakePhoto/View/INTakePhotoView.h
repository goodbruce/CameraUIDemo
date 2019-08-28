//
//  INTakePhotoView.h
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Addition.h"
#import "INCameraConfig.h"
#import "INTakePhotoShowView.h"

@protocol INTakePhotoViewDelegate;
@interface INTakePhotoView : UIView

@property (nonatomic, weak) id subDelegate;

@property (nonatomic, weak) id<INTakePhotoViewDelegate>actionDelegate;

@property (nonatomic, strong) INCameraConfig *cameraConfig;

/**
 拍照的背景图片
 */
@property (nonatomic, strong) UIImageView *takeBGImageView;

/**
 关闭
 */
@property (nonatomic, strong) UIButton *closeButton;

/**
 拍照按钮
 */
@property (nonatomic, strong) UIButton *photoButton;

/**
 聚焦view
 */
@property (nonatomic, strong) UIView *focusView;

/**
 切换前后置摄像头
 */
@property (nonatomic, strong) UIButton *changedButton;

/**
 开启闪光灯按钮
 */
@property (nonatomic, strong) UIButton *flashButton;


/**
 显示图片 重拍 或者使用图片
 */
@property (nonatomic, strong) INTakePhotoShowView *showPhotoView;


- (id)initWithFrame:(CGRect)frame;

@end

/**
 代理方法
 */
@protocol INTakePhotoViewDelegate <NSObject>

/**
 close 关闭界面
 */
- (void)closeButtonDidAction;

@end
