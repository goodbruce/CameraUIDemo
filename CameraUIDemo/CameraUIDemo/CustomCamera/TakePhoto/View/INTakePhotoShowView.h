//
//  INTakePhotoShowView.h
//  AppDemo
//
//  Created by 1 on 2019/3/1.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Addition.h"
#import "INCameraConfig.h"

@protocol INTakePhotoShowViewDelegate;
@interface INTakePhotoShowView : UIView

@property (nonatomic, weak) id<INTakePhotoShowViewDelegate>subDelegate;

/**
 显示拍照的图片
 */
@property (nonatomic, strong) UIImageView *photoImageView;

/**
 显示工具栏的背景
 */
@property (nonatomic, strong) UIImageView *toolbarImageView;

/**
 使用图片按钮
 */
@property (nonatomic, strong) UIButton *useButton;

/**
 重新拍摄
 */
@property (nonatomic, strong) UIButton *retakeButton;

@end

/**
 代理方法
 */
@protocol INTakePhotoShowViewDelegate <NSObject>

/**
 使用图片
 */
- (void)useButtonDidAction;

/**
 重拍按钮
 */
- (void)retakeButtonDidAction;

@end

