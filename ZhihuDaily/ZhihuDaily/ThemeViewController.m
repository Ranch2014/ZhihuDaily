//
//  ThemeViewController.m
//  ZhihuDaily
//
//  Created by 焦相如 on 7/12/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "ThemeViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Macro.h"
#import "StoryModel.h"
#import "MJExtension.h"
#import "HomeCell.h"
#import "Masonry.h"
#import "View+MASShorthandAdditions.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "ThemeDetailViewController.h"

@interface ThemeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UILabel *nameLabel; //专栏名
@property (nonatomic, strong) UIImageView *headerImage; //头部图片
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIButton *leftBtn; //左侧按钮
@end

@implementation ThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES]; //隐藏状态栏
    
    self.stories = [[NSArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self getThemeInfo];
    [self initUI];
    
    self.nameLabel.text = self.name; //专题名
}

- (void)initUI
{
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight-60)];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped]; //设置 style 为 UITableViewStyleGrouped，headerView 会随着滑动
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _headerImage.backgroundColor = [UIColor orangeColor]; //状态栏问题???
    }
    
    if (!_naviBar) { //导航栏
        _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        _naviBar.backgroundColor = kColor(23, 144, 211, 1);
        [self.view addSubview:_naviBar];
        _naviBar.alpha = 1.0; //透明度
    }
    
    if (!_leftBtn) { //左侧按钮
        _leftBtn = [[UIButton alloc] init];
        [self.naviBar addSubview:_leftBtn];
        [_leftBtn setImage:[UIImage imageNamed:@"leftBtn"] forState:UIControlStateNormal];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.naviBar).with.offset(20);
            make.top.equalTo(self.naviBar).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [_leftBtn addTarget:self
                     action:@selector(closeLeft)
           forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!_nameLabel) { //专题名
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        [self.naviBar addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftBtn);
            make.left.equalTo(self.leftBtn).with.offset(40);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
    }
    
}

/**
 *  关闭左侧菜单栏
 */
- (void)closeLeft
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.mainViewController toggleDrawerSide:MMDrawerSideLeft
                                         animated:YES
                                       completion:nil];
}

/**
 *  获取专题信息
 */
- (void)getThemeInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%d", themeURL, self.id]; //拼接 URL
    NSLog(@"themeURL-->%@", url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.stories = [StoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - dataSource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    StoryModel *model = self.stories[indexPath.row];
    [cell setTitle:model.title]; //设置文章标题
    
    self.images = model.images;
    NSString *url = model.images[0];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    [cell setImage:image]; //设置缩略图
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选中状态
    
    StoryModel *model = self.stories[indexPath.row];
//    NSLog(@"id---%d", model.id);
    ThemeDetailViewController *detailVC = [[ThemeDetailViewController alloc] init];
    detailVC.id = model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 220;
}

//自定义 headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
        _headerImage.clipsToBounds = YES;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnail]]];
        self.headerImage.image = image;
    }
    return self.headerImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
