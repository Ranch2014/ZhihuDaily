//
//  LatestNewsModel.h
//  ZhihuDaily
//
//  Created by 焦相如 on 6/23/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LatestNewsModel : NSObject

@property (nonatomic, copy) NSString *date; /**< 日期 */
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) NSArray *top_stories;

@end
