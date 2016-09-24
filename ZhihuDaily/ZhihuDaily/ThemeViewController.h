//
//  ThemeViewController.h
//  ZhihuDaily
//
//  Created by 焦相如 on 7/12/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThemeModel;

@interface ThemeViewController : UIViewController

@property (nonatomic, strong) ThemeModel *themeModel;
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name; /**< 专题名字 */
@property (nonatomic, copy) NSString *thumbnail; /**< 图片网址 */

@end
