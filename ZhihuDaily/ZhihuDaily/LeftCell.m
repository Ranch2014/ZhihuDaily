//
//  LeftCell.m
//  ZhihuDaily
//
//  Created by 焦相如 on 7/12/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "LeftCell.h"
#import "Masonry.h"
#import "Macro.h"

@interface LeftCell ()
@property (nonatomic, strong) UILabel *titleLable; /**< 专题名标签 */
@property (nonatomic, copy) NSString *titleText; /**< 专题文本 */
@end

@implementation LeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_titleLable) {
            _titleLable = [[UILabel alloc] init];
            _titleLable.font = [UIFont systemFontOfSize:18.f];
            [self.contentView addSubview:_titleLable];
            [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo([_titleLable superview]).with.offset(20);
                make.bottom.equalTo([_titleLable superview]).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth, 60));
            }];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    self.titleLable.text = self.titleText;
}

- (void)setName:(NSString *)name
{
    self.titleText = name;
}

@end
