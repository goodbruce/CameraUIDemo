//
//  INTakePhotoViewController.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INTakePhotoViewController.h"
#import "INTakePhotoPresenter.h"

@interface INTakePhotoViewController ()

@property (nonatomic, strong) INTakePhotoView *photoView;
@property (nonatomic, strong) INTakePhotoInteractor *photoInteractor;
@property (nonatomic, strong) INTakePhotoConfig *photoConfig;
@property (nonatomic, strong) INTakePhotoPresenter *photoPresenter;

@end

@implementation INTakePhotoViewController

#pragma mark - Configure NavigationBar
- (void)configureNavigationBar {
    self.navigationItem.title = @"通知";
}

#pragma mark - loadView
- (void)loadView {
    [super loadView];
    self.view = self.photoView;
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
    self.photoPresenter.photoView = self.photoView;
    
    self.photoPresenter.controller = self;
    
    //presenter处理业务逻辑
    self.photoView.subDelegate = self.photoPresenter;
    self.photoView.actionDelegate = self.photoPresenter;

    //使用同一个配置
    self.photoPresenter.photoInteractor = self.photoInteractor;
    self.photoPresenter.photoConfig = self.photoInteractor.photoConfig;
    
    //开始启动
    [self.photoView.cameraConfig.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SETTER/GETTER
- (INTakePhotoConfig *)photoConfig {
    if (!_photoConfig) {
        _photoConfig = [[INTakePhotoConfig alloc] init];
    }
    return _photoConfig;
}

- (INTakePhotoInteractor *)photoInteractor {
    if (!_photoInteractor) {
        _photoInteractor = [[INTakePhotoInteractor alloc] init];
    }
    return _photoInteractor;
}

- (INTakePhotoPresenter *)photoPresenter {
    if (!_photoPresenter) {
        _photoPresenter = [[INTakePhotoPresenter alloc] init];
    }
    return _photoPresenter;
}

- (INTakePhotoView *)photoView {
    if (!_photoView) {
        _photoView = [[INTakePhotoView alloc] initWithFrame:CGRectZero];
    }
    return _photoView;
}

@end
