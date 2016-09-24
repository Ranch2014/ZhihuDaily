//
//  LaunchViewController.m
//  ZhihuDaily
//
//  Created by 焦相如 on 6/20/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "LaunchViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "LaunchImage.h"
#import "MJExtension.h"
#import "Macro.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "MainViewController.h"

static const NSTimeInterval kAnimationDuration = 3;

@interface LaunchViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *imageTitle;
@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadLaunchImage];
    [self initUI];
}

/** 初始化 UI */
- (void)initUI
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.imageView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.imageView];
    }
    
    if (!_imageTitle) {
        self.imageTitle = [[UILabel alloc] init];
        self.imageTitle.frame = CGRectMake((kScreenWidth-150)/2, kScreenHeight-30, 150, 30); //宽度如何设置？字体是否会超出？
        [self.imageTitle setTextColor:[UIColor whiteColor]]; //设置时通过属性，读取时直接访问<Effective OC 2.0>
        [self.imageTitle setTextAlignment:NSTextAlignmentCenter];
        self.imageTitle.font = [UIFont systemFontOfSize:14.0f];
        [self.view addSubview:self.imageTitle];
    }
}

/** 加载启动图文 */
- (void)loadLaunchImage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:launchImageURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LaunchImage *imageInfo = [LaunchImage mj_objectWithKeyValues:responseObject];
        NSLog(@"launchImageURL-->%@", imageInfo.img);
        self.imageTitle.text = imageInfo.text;
        SDWebImageManager *downloader = [SDWebImageManager sharedManager];
        [downloader downloadImageWithURL:[NSURL URLWithString:imageInfo.img]
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize){nil;}
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                   self.imageView.image = image;
                                   
                                   [UIView animateWithDuration:kAnimationDuration
                                                    animations:^{
                                                        _imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
//                                                        _imageView.alpha = 0.f; //还可以设置透明度渐变
                                                    } completion:^(BOOL finished) {
                                                        self.view.window.rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).mainViewController; //图片显示完再把 MainVC 设为RootVC
                                                    }];
                               }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%s, %@", __func__, error); //这样方便定位错误
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
