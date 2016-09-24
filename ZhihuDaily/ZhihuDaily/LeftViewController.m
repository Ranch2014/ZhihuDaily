//
//  LeftViewController.m
//  ZhihuDaily
//
//  Created by 焦相如 on 6/20/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "LeftViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MJExtension.h"
#import "Macro.h"
#import "ThemeModel.h"
#import "LeftCell.h"
#import "ThemeViewController.h"
#import "MainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HomeViewController.h"

@interface LeftViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *themes;
@property (nonatomic, strong) ThemeViewController *themeVC;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.22 alpha:1.00];
    
    NSLog(@"%s", __func__);
    
    [self getTheme];
    [self initUI];
}

- (void)initUI
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-80)];
        _tableView.backgroundColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.22 alpha:1.00];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

/** 获取专题信息 */
- (void)getTheme
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"themeURL-->%@", themesURL);
    [manager GET:themesURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *array = [ThemeModel mj_objectArrayWithKeyValuesArray:responseObject[@"others"]]; //接收数据
        [self.themes addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error-->%@", error);
    }];
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.themes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[LeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    ThemeModel *model = self.themes[indexPath.row];
    [cell setName:model.name]; //设置专题名
    cell.backgroundColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.22 alpha:1.00];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选中状态

    if (indexPath.row == 0) { //回到首页(有待优化)
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:homeVC animated:YES]; //能回到首页，但不能滑动打开左侧菜单栏
        
//        [self.mainVC setCenterViewController:self.mainVC.navigationController withCloseAnimation:YES completion:nil]; //回到首页 (在其他专栏时，点击还是该专栏，不能回到首页)
    }
    else { //跳转到其他专题
    
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        ThemeModel *model = self.themes[indexPath.row];
        themeVC.id = model.id;
        themeVC.name = model.name;
        themeVC.thumbnail = model.thumbnail;
        
//        themeVC.themeModel = model; //test, 不能直接传 model，郁闷！
        
        //拿到我们的LitterLCenterViewController，让它去push
        UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:themeVC animated:YES];
    }
    
    //push 成功之后，关闭抽屉
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone]; //设置打开抽屉效果
    }];
}

- (NSMutableArray *)themes
{
    if (!_themes) {
        _themes = [[NSMutableArray alloc] init];
        ThemeModel *model = [[ThemeModel alloc] init];
        model.name = @"首页";
        [_themes addObject:model]; //添加首页标签
    }
    return _themes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
