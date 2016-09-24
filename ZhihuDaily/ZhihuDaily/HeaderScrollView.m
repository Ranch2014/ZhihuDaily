//
//  HeaderScrollView.m
//  ZhihuDaily
//
//  Created by 焦相如 on 7/4/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "HeaderScrollView.h"
#import "Macro.h"

//#import "HeaderScrollView.h"

//#define kImageCount 2
//#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
//#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height
#define kImageCount [self.imageArray count]

static const NSTimeInterval kTimeInterval = 3.0f;

@interface HeaderScrollView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView; //滚动视图控件
@property (nonatomic, strong) UIPageControl *pageControl; //页码指示视图控件
@property (nonatomic, strong) NSTimer *timer; //定时器
@property (nonatomic, strong) UIImageView *leftImageView; //左边的图片
@property (nonatomic, strong) UIImageView *centerImageView; //中间的图片
@property (nonatomic, strong) UIImageView *rightImageView; //右边的图片
//@property (nonatomic, strong) NSArray *imageArray; //保存图片的数组
@property (nonatomic, assign) long currentIndex; //当前的索引
@property (nonatomic, assign) BOOL isTimeUp;
@end

@implementation HeaderScrollView

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"%s", __func__);
    
    self = [super initWithFrame:frame];
    if (self) {
        
//        if (!_imageArray) {
//            _imageArray = [[NSArray alloc] init];
//        }
        
        self.currentIndex = 0;
//        self.imageArray = @[@"1", @"2", @"3", @"4", @"5"];
        [self initUI];
        [self layoutImageView];
        
        [self refreshImage];
        
//        [self setImageByIndex:self.currentIndex];
        [self setBackgroundColor:[UIColor yellowColor]];
    }
    
//    NSLog(@"self.img--%@", self.imageArray);
    
    return self;
}

/**
 *  初始化 UI
 */
- (void)initUI
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _scrollView.contentOffset = CGPointMake(kWidth, 0);
        _scrollView.contentSize = CGSizeMake(kWidth * 3, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
    }
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        _pageControl.center = CGPointMake(kWidth/2, kHeight/10*8);
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor]; //当前点的颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor]; //其他点的颜色
        _pageControl.enabled = NO; //???
        _pageControl.numberOfPages = kImageCount;
        [self addSubview:self.pageControl];
    }
}

/**
 *  自定义添加 ImageView
 */
- (void)layoutImageView
{
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.leftImageView.clipsToBounds = YES;
    [self.scrollView addSubview:self.leftImageView];
    
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight)];
    self.centerImageView.clipsToBounds = YES;
    [self.scrollView addSubview:self.centerImageView];
    
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * 2, 0, kWidth, kHeight)];
    self.rightImageView.clipsToBounds = YES;
    [self.scrollView addSubview:self.rightImageView];
    
    //添加点击事件
    self.centerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [self.centerImageView addGestureRecognizer:singleTap];
    
    //启动时钟
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval
                                                  target:self
                                                selector:@selector(timerAction)
                                                userInfo:nil
                                                 repeats:YES];
    _isTimeUp = NO;
}

- (void)timerAction
{
    [self.scrollView setContentOffset:CGPointMake(kWidth * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f
                                     target:self
                                   selector:@selector(scrollViewDidEndDecelerating:)
                                   userInfo:nil
                                    repeats:NO];
}

//停止加速的操作
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshImage];
    
    self.scrollView.contentOffset = CGPointMake(kWidth, 0);
    self.pageControl.currentPage = self.currentIndex;
    
    //手动控制图片滚动应该取消计时器﻿
    if (!_isTimeUp) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimeInterval]];
    }
    _isTimeUp = NO;
}

- (void)refreshImage
{
    if (self.scrollView.contentOffset.x > kWidth) {
        self.currentIndex = (self.currentIndex + 1) % kImageCount;
    }
    else if (self.scrollView.contentOffset.x < kWidth) {
        self.currentIndex = (self.currentIndex - 1 + kImageCount) % kImageCount;
    }
    [self setImageByIndex:self.currentIndex];
}

- (void)setImageByIndex:(long)currentIndex
{
//    self.centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", currentIndex]];
//    self.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", ((self.currentIndex - 1 + kImageCount) % kImageCount)]];
//    self.rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", ((self.currentIndex + 1) % kImageCount)]];
    
    NSLog(@"imageArray---%@", self.imageArray);
    
//    self.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", ((self.currentIndex - 1 + kImageCount) % kImageCount)]];
    
    if (self.imageArray) {
        self.leftImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[(currentIndex-1 + kImageCount) % kImageCount]]]];
        self.centerImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[currentIndex]]]];
        self.rightImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[(currentIndex+1) % kImageCount]]]];
    }

//    self.rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", ((self.currentIndex + 1) % kImageCount)]];
    
    
    self.pageControl.currentPage = currentIndex;
}

/**
 *  点击事件
 */
- (void)tapImage
{
    NSLog(@"点击了！");
}

@end
