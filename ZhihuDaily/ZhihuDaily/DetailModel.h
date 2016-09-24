//
//  DetailModel.h
//  ZhihuDaily
//
//  Created by 焦相如 on 7/7/16.
//  Copyright © 2016 jaxer. All rights reserved.
//
//  文章内容数据模型

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic, copy) NSString *body; /**< 正文 */
@property (nonatomic, copy) NSString *image_source; /**< 图片来源 */
@property (nonatomic, copy) NSString *image; /**< 图片链接 */
@property (nonatomic, copy) NSString *title; /**< 标题 */
@property (nonatomic, copy) NSString *share_url;
@property (nonatomic, copy) NSString *ga_prefix;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) int id;

@property (nonatomic, strong) NSArray *css;

@property (nonatomic, copy) NSString *htmlUrl;

@end
