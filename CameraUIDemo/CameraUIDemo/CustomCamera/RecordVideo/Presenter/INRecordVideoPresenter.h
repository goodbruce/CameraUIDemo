//
//  INRecordVideoPresenter.h
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INRecordVideoView.h"
#import "INRecordVideoInteractor.h"

@interface INRecordVideoPresenter : NSObject

@property (nonatomic, strong) INRecordVideoView *recordVView;
@property (nonatomic, strong) INRecordVideoInteractor *recordVInteractor;

@property (nonatomic, weak) UIViewController *controller;

@end
