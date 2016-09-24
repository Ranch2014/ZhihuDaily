//
//  HeaderScrollView.h
//  ZhihuDaily
//
//  Created by 焦相如 on 7/4/16.
//  Copyright © 2016 jaxer. All rights reserved.
//
//  主页面顶部轮播图

#import <UIKit/UIKit.h>

@interface HeaderScrollView : UIView

@property (nonatomic, strong) NSArray *imageArray; //保存图片的数组

//- (void)setTitle; //设置标题（有待实现？？？？）


- (void)tapImage; /**< 图片点击事件 */

@end
