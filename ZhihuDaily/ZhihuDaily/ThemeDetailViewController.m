//
//  ThemeDetailViewController.m
//  ZhihuDaily
//
//  Created by 焦相如 on 7/15/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "ThemeDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MJExtension.h"
#import "Macro.h"
#import "Masonry.h"
#import "DetailModel.h"

@interface ThemeDetailViewController ()
@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *backBtn; //返回按钮
@end

@implementation ThemeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSLog(@"%s", __func__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getDetail];
    [self initUI];
}

/** 初始化 UI */
- (void)initUI
{
    if (!_naviBar) {
        _naviBar = [[UIView alloc] init];
        _naviBar.backgroundColor = kColor(23, 144, 211, 1);
        [self.view addSubview:_naviBar];
        [_naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 55));
        }];
    }
    
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [self.naviBar addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.naviBar.mas_left).with.offset(20);
            make.top.equalTo(self.view).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [_backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        [_backBtn addTarget:self
                     action:@selector(back)
           forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        [self.view addSubview:_webView];
//        _webView.delegate = self;
//        _webView.scrollView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.naviBar.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-55));
        }];
    }
}

/** 返回上一级 */
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 获取内容 */
- (void)getDetail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%d", detailURL, self.id];
    NSLog(@"url--%@", url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DetailModel *model = [DetailModel mj_objectWithKeyValues:responseObject];
        model.htmlUrl = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",model.css[0],model.body]; //加载包含CSS的文本
        [self.webView loadHTMLString:model.htmlUrl baseURL:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error-->%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
