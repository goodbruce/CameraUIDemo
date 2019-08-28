//
//  INTakeVideoViewController.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INTakeVideoViewController.h"
#import "INTakeVideoPresenter.h"

@interface INTakeVideoViewController ()

@property (nonatomic, strong) INTakeVideoView *videoView;
@property (nonatomic, strong) INTakeVideoInteractor *videoInteractor;
@property (nonatomic, strong) INTakeVideoConfig *videoConfig;
@property (nonatomic, strong) INTakeVideoPresenter *videoPresenter;

@end

@implementation INTakeVideoViewController

#pragma mark - Configure NavigationBar
- (void)configureNavigationBar {
    self.navigationItem.title = @"通知";
}

#pragma mark - loadView
- (void)loadView {
    [super loadView];
    self.view = self.videoView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self configureNavigationBar];
    [self configureAssociation];
}

#pragma mark - Configure
- (void)configureAssociation {
    //配置view
    self.videoPresenter.videoView = self.videoView;
    
    self.videoPresenter.controller = self;
    
    //presenter处理业务逻辑
    self.videoView.subDelegate = self.videoPresenter;
    self.videoView.actionDelegate = self.videoPresenter;
    
    //使用同一个配置
    self.videoPresenter.videoInteractor = self.videoInteractor;
    self.videoPresenter.videoConfig = self.videoInteractor.videoConfig;
    
    //开始启动
    [self.videoView.cameraConfig.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SETTER/GETTER
- (INTakeVideoConfig *)videoConfig {
    if (!_videoConfig) {
        _videoConfig = [[INTakeVideoConfig alloc] init];
    }
    return _videoConfig;
}

- (INTakeVideoInteractor *)videoInteractor {
    if (!_videoInteractor) {
        _videoInteractor = [[INTakeVideoInteractor alloc] init];
    }
    return _videoInteractor;
}

- (INTakeVideoPresenter *)videoPresenter {
    if (!_videoPresenter) {
        _videoPresenter = [[INTakeVideoPresenter alloc] init];
    }
    return _videoPresenter;
}

- (INTakeVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[INTakeVideoView alloc] initWithFrame:CGRectZero];
    }
    return _videoView;
}

@end
