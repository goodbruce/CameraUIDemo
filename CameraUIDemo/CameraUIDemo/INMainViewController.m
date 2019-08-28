//
//  INMainViewController.m
//  LaGDemo
//
//  Created by bruce on 2019/8/26.
//  Copyright © 2019 com.boliboli. All rights reserved.
//

#import "INMainViewController.h"
#import "INRecordVideoViewController.h"
#import "INTakePhotoViewController.h"

@interface INMainViewController ()

@end

@implementation INMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *photoButton;
    photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(50, 370, 88, 44);
    photoButton.layer.cornerRadius = 4;
    photoButton.backgroundColor = [UIColor brownColor];
    [photoButton setTitle:@"拍照" forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
    
    UIButton *videoButton;
    videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoButton.frame = CGRectMake(50, 470, 88, 44);
    videoButton.layer.cornerRadius = 4;
    videoButton.backgroundColor = [UIColor brownColor];
    [videoButton setTitle:@"视频录制" forState:UIControlStateNormal];
    [videoButton addTarget:self action:@selector(videoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoButton];
}

- (void)photoButtonClick {
    INTakePhotoViewController *cameraPlayer = [[INTakePhotoViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:cameraPlayer];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)videoButtonClick {
    INRecordVideoViewController *cameraVideoPlayer = [[INRecordVideoViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:cameraVideoPlayer];
    [self presentViewController:navi animated:YES completion:nil];
}

@end
