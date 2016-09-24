//
//  MainViewController.m
//  ZhihuDaily
//
//  Created by 焦相如 on 6/20/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"%s", __func__);
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    self.navigationController = navController;
    navController.navigationBar.hidden = YES; //隐藏导航栏
    
    LeftViewController *leftVC = [[LeftViewController alloc] init];

    self.leftDrawerViewController = leftVC; //左侧菜单栏
    self.centerViewController = navController; //主目录
    
    [self setMaximumLeftDrawerWidth:220]; //设置弹出框的宽度

    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll]; //手势打开抽屉
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll]; //手势关闭抽屉
    
    [self setShowsShadow:NO]; //是否显示阴影
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
