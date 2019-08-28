//
//  INVideoModel.h
//  AppDemo
//
//  Created by 1 on 2019/3/8.
//  Copyright © 2019 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "INDocPathUtils.h"

@interface INVideoModel : NSObject

@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *videoThumbImageUrl;
@property (nonatomic, assign) CGFloat videoTime;

+ (instancetype)createVideoModel;

@end
