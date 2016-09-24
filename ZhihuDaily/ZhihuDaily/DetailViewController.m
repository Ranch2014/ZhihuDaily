//
//  DetailViewController.m
//  ZhihuDaily
//
//  Created by 焦相如 on 7/7/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "DetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Macro.h"
#import "DetailModel.h"
#import "MJExtension.h"
#import "Masonry.h"

@interface DetailViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *headerView; /**< 顶部图片，标题，来源 */
@property (nonatomic, strong) UILabel *titleLabel; /**< 标题 */
@property (nonatomic, strong) UIImageView *imageView; /**< 顶部图片 */
@property (nonatomic, strong) UILabel *sourceLabel; /**< 图片来源 */
@property (nonatomic, strong) UIView *naviBar; /**< 顶部导航栏(包含返回键，点赞人数等) */
@property (nonatomic, strong) UIButton *backBtn; /**< 返回按钮 */
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDetail];
    [self initUI];
}

/** 初始化 UI */
- (void)initUI
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
//        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        _webView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
        }];
    }
    
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
//        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 220);
        _headerView.clipsToBounds = YES;
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(-20);
            make.left.equalTo(self.webView);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 220));
        }];
    }
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor whiteColor];
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.headerView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.headerView);
            make.height.equalTo(self.view.mas_width);
        }];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.f];
//        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping; //换行模式
        [self.imageView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(16);
            make.right.equalTo(_headerView).offset(-16);
            make.bottom.equalTo(_headerView).offset(-20);
            make.height.mas_equalTo(60);
        }];
    }
    
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.textColor = [UIColor whiteColor];
        _sourceLabel.font = [UIFont systemFontOfSize:12.f];
        _sourceLabel.textAlignment = NSTextAlignmentRight;
        [_sourceLabel sizeToFit];
        [self.imageView addSubview:_sourceLabel];
        [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView).offset(-10);
            make.bottom.equalTo(_headerView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(150, 30));
        }];
    }
    
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
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.naviBar addSubview:_backBtn];
        [_backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.naviBar).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [_backBtn addTarget:self
                     action:@selector(back)
           forControlEvents:UIControlEventTouchUpInside];
    }
}

/** 返回上一级 */
- (void)back
{
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}

/** 获取详细信息 */
- (void)getDetail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%d", detailURL,self.id];
    NSLog(@"detailURL-->%@", url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        DetailModel *model = [DetailModel mj_objectWithKeyValues:responseObject];
        NSLog(@"image_source--%@", model.image);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.image]];
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image; //顶部图片
        self.titleLabel.text = model.title; //标题
        self.sourceLabel.text = model.image_source; //图片来源
        
        model.htmlUrl = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",model.css[0],model.body]; //加载包含CSS的文本
        [self.webView loadHTMLString:model.htmlUrl baseURL:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error-->");
    }];
}

#pragma mark - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滑动方法：滑动时顶部图片随 WebView 一起滚动。有待改动。
    
    CGFloat offsetY = scrollView.contentOffset.y; //滑动距离
    
    NSLog(@"offsetY = %f", offsetY); //-20.000000 ???
    
    if (offsetY < -10) {
        NSLog(@"向下拉了");
        if (offsetY > -90) {
            [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(-offsetY/2);
            }];
            [super updateViewConstraints];
        }
//        scrollView.scrollEnabled = NO;
//        [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(offsetY);
//        }];
//        [super updateViewConstraints];
    } else {
//        NSLog(@"向上滑动了！");
        [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-offsetY);
        }];
        [super updateViewConstraints];
    }
    
    //向上滑动时慢慢显示出导航栏
//    CGFloat offSetY = scrollView.contentOffset.y;
    if (offsetY<=0 && offsetY>=-90) {
        _naviBar.alpha = 0; //隐藏
    } else if(offsetY <= 500) {
        _naviBar.alpha = offsetY/200; //滑动时逐渐显示出来
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
