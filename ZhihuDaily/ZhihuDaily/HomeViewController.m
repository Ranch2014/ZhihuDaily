//
//  HomeViewController.m
//  ZhihuDaily
//
//  Created by 焦相如 on 6/21/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "HomeViewController.h"
#import "Macro.h"
#import "AFHTTPRequestOperationManager.h"
#import "StoryModel.h"
#import "LatestNewsModel.h"
#import "MJExtension.h"
#import "HomeCell.h"
#import "HeaderScrollView.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UIButton *leftBtn; /**< 左侧按钮 */
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) NSArray *top_stories;
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, assign) int id;

//@property (nonatomic, strong) HeaderScrollView *header;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = [[NSMutableArray alloc] initWithCapacity:0];
//    self.stories = [[NSArray alloc] init];
//    self.top_stories = [[NSArray alloc] init];
//    self.header = [[HeaderScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [self getLatestNews];
    [self initUI];
    
    NSLog(@"images----%@", self.images);
}

//- (void)loadData
//{
//    [self.tableView reloadData];
//    NSLog(@"top---%@", self.stories); //为何没有数据？？在哪刷新？？
//}

/** 初始化 UI */
- (void)initUI
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
//        self.tableView.tableHeaderView = self.header;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //分隔符
        [self.view addSubview:self.tableView];
    }
    
    if (!_naviBar) {
        _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        _naviBar.backgroundColor = kColor(23, 144, 211, 1);
        [self.view addSubview:self.naviBar];
    }
    
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 30, 30)];
        [self.naviBar addSubview:_leftBtn];
        [_leftBtn setImage:[UIImage imageNamed:@"leftBtn"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self
                     action:@selector(openLeft)
           forControlEvents:UIControlEventTouchUpInside];
    }
}

/** 打开左侧菜单栏 */
- (void)openLeft
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.mainViewController toggleDrawerSide:MMDrawerSideLeft
                                         animated:YES
                                       completion:nil];
}

/** 获取最新消息 */
- (void)getLatestNews
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"latestNewURL-->%@", latestNewURL);
    [manager GET:latestNewURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        LatestNewsModel *model = [LatestNewsModel mj_objectWithKeyValues:responseObject];
        self.date = model.date; //接收数据
        self.stories = model.stories;
        self.top_stories = model.top_stories;
        
//        self.header.imageArray = self.top_stories;
        
//        NSLog(@"self.top_stories--%@", self.top_stories);
        
        for (int i=0; i<[self.top_stories count]; i++) {
            StoryModel *model = self.top_stories[i];
            [self.images addObject:model.image]; //添加图片地址
//            NSLog(@"image----%@", model.image);
        }
        
//        NSLog(@"self.images---%@", self.images);
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error-->%@", error);
    }];
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 0, 100, 80);
//    label.backgroundColor = [UIColor yellowColor];
    
//    NSLog(@"imgs--%@", self.images);
    HeaderScrollView *header = [[HeaderScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    header.imageArray = self.images;
    NSLog(@"header.image--%@", header.imageArray);
    return header;
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.contentView.backgroundColor = [UIColor whiteColor]; //OK
//    header.textLabel.font = [UIFont systemFontOfSize:32.f];
//    [header.textLabel setTextColor:[UIColor blackColor]];
//    header.textLabel.text = @"test";
//    header.textLabel.textAlignment = NSTextAlignmentCenter;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Hello";
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选中状态
    StoryModel *model = self.stories[indexPath.row];
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.id = model.id; //传递id
//    NSLog(@"model.id - %d", model.id); //test
    [self.navigationController pushViewController:detail animated:YES]; //test
}

#pragma mark - tableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    StoryModel *model = [self.stories objectAtIndex:indexPath.row];
    [cell setTitle:model.title]; //设置标题
    
//    self.images = model.images;
    
    NSString *str = model.images[0]; //设置缩略图
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
    [cell setImage:image];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stories.count;
}

#pragma mark - UIScrollView delegate

//ScrollView 滑动时的动作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //
    CGFloat sectionHeaderHeight = 144;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY<=0 && offSetY>=-90) {
        _naviBar.alpha = 0; //隐藏
    } else if(offSetY <= 500) {
        _naviBar.alpha = offSetY/200; //滑动时逐渐显示出来
//        NSLog(@"-->%f", _naviBar.alpha);
    }
    
//    NSLog(@"offset---->%f", offSetY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
