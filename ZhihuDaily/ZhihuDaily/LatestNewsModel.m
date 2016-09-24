//
//  LatestNewsModel.m
//  ZhihuDaily
//
//  Created by 焦相如 on 6/23/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "LatestNewsModel.h"
#import "MJExtension.h"
#import "StoryModel.h"

@implementation LatestNewsModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"stories" : [StoryModel class],
             @"top_stories" : [StoryModel class]
             };
}

@end
