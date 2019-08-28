//
//  INRecordVideoViewController.m
//  AppDemo
//
//  Created by 1 on 2018/8/13.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "INRecordVideoViewController.h"
#import "INRecordVideoPresenter.h"

@interface INRecordVideoViewController ()

@property (nonatomic, strong) INRecordVideoView *recordVView;
@property (nonatomic, strong) INRecordVideoInteractor *recordVInteractor;
@property (nonatomic, strong) INRecordVideoPresenter *recordVPresenter;

@end

@implementation INRecordVideoViewController

#pragma mark - Configure NavigationBar
- (void)configureNavigationBar {
    self.navigationItem.title = @"通知";
}

#pragma mark - loadView
- (void)loadView {
    [super loadView];
    self.view = self.recordVView;
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
    
    [self configureNavigationBar];
    [self configureAssociation];
}

#pragma mark - Configure
- (void)configureAssociation {
    //配置view
    self.recordVPresenter.recordVView = self.recordVView;
    
    self.recordVPresenter.controller = self;
    
    //presenter处理业务逻辑
    self.recordVView.delegate = self.recordVPresenter;
    self.recordVView.actionDelegate = self.recordVPresenter;

    //使用同一个配置
    self.recordVPresenter.recordVInteractor = self.recordVInteractor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SETTER/GETTER
- (INRecordVideoInteractor *)recordVInteractor {
    if (!_recordVInteractor) {
        _recordVInteractor = [[INRecordVideoInteractor alloc] init];
    }
    return _recordVInteractor;
}

- (INRecordVideoPresenter *)recordVPresenter {
    if (!_recordVPresenter) {
        _recordVPresenter = [[INRecordVideoPresenter alloc] init];
    }
    return _recordVPresenter;
}

- (INRecordVideoView *)recordVView {
    if (!_recordVView) {
        _recordVView = [[INRecordVideoView alloc] initWithFrame:CGRectZero];
    }
    return _recordVView;
}

@end
