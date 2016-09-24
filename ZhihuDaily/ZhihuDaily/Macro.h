//
//  Macro.h
//  ZhihuDaily
//
//  Created by 焦相如 on 6/20/16.
//  Copyright © 2016 jaxer. All rights reserved.
//
//  宏定义

#ifndef Macro_h
#define Macro_h

#define launchImageURL @"http://news-at.zhihu.com/api/4/start-image/1080*1776"
#define latestNewURL @"http://news-at.zhihu.com/api/4/news/latest"
#define detailURL @"http://news-at.zhihu.com/api/4/news/"
#define themesURL @"http://news-at.zhihu.com/api/4/themes" /**< 专题网址 */
#define themeURL @"http://news-at.zhihu.com/api/4/theme/" /**< 单个专题，拼接 id 后构成具体某个专题 */

#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define kColor(R, G, B, A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

//extern CGFloat const kScreenWidth = [[UIScreen mainScreen] bounds].size.width;

#endif /* Macro_h */
