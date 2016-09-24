//
//  ThemeModel.h
//  ZhihuDaily
//
//  Created by 焦相如 on 7/11/16.
//  Copyright © 2016 jaxer. All rights reserved.
//
//  主题数据模型

#import <Foundation/Foundation.h>

@interface ThemeModel : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name; /**< 专题名字 */
@property (nonatomic, copy) NSString *thumbnail; /**< 图片网址 */
//@property (nonatomic, strong) NSString *description; /**< 专题描述 */
//@property (nonatomic, assign) int color; //暂时没用

@end
