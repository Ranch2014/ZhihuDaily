//
//  StoryModel.h
//  ZhihuDaily
//
//  Created by 焦相如 on 6/23/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryModel : NSObject

@property (nonatomic, copy) NSString *title; /**< 标题 */
@property (nonatomic, copy) NSArray *images; /**< stories 图片 */
@property (nonatomic, copy) NSString *image; /**< top_stories 图片 */
@property (nonatomic, copy) NSString *ga_prefix;
@property (nonatomic, assign) int id;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL multipic; /**< 是否多图 */

@end
