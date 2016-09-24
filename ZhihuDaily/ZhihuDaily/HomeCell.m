//
//  HomeCell.m
//  ZhihuDaily
//
//  Created by 焦相如 on 6/22/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "HomeCell.h"
#import "Masonry.h"
#import "Macro.h"

@interface HomeCell ()
@property (nonatomic, strong) UILabel *titleLabel; /**< 标题 Label */
@property (nonatomic, strong) UIImageView *titleImageView; /**< 缩略图 Label */

@property (nonatomic, copy) NSString *titleText; /**< 标题文本 */
@property (nonatomic, strong) UIImage *titleImage; /**< 缩略图网址 */
@end

@implementation HomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = [UIFont systemFontOfSize:16.0];
            [_titleLabel sizeToFit];
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _titleLabel.numberOfLines = 0;
            _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo([_titleLabel superview]).with.offset(10);
                make.left.equalTo([_titleLabel superview]).with.offset(20);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.65, 60));
            }];
        }
        
        if (!_titleImageView) {
            _titleImageView = [[UIImageView alloc] init];
            [self.contentView addSubview:_titleImageView];
            [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo([_titleImageView superview]).with.offset(10);
                make.left.equalTo(_titleLabel.mas_right).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(60, 60));
            }];
        }
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 0;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
//    NSLog(@"%s", __func__);
    _titleLabel.text = self.titleText;
    _titleImageView.image = self.titleImage;
}

- (void)setTitle:(NSString *)title
{
    self.titleText = title;
}

- (void)setImage:(UIImage *)image
{
    self.titleImage = image;
}

@end
