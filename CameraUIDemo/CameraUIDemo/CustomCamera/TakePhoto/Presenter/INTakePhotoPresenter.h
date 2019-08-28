//
//  INTakePhotoPresenter.h
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INTakePhotoView.h"
#import "INTakePhotoInteractor.h"

@interface INTakePhotoPresenter : NSObject <INTakePhotoViewDelegate>

@property (nonatomic, strong) INTakePhotoView *photoView;
@property (nonatomic, strong) INTakePhotoInteractor *photoInteractor;
@property (nonatomic, strong) INTakePhotoConfig *photoConfig;

@property (nonatomic, weak) UIViewController *controller;

@end
