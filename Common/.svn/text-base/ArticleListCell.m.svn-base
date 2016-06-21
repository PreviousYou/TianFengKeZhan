//
//  ArticleListCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/19.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "ArticleListCell.h"
#import <UIImageView+WebCache.h>

@interface ArticleListCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorHeight;

@end

@implementation ArticleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (_seperatorHeight) [_seperatorHeight setConstant:1 / [UIScreen mainScreen].scale];
}

- (void)loadDataWithObject:(ArticleObject*)obj {
    [_imgView sd_setImageWithURL:[NSURL URLWithString:obj.imagePath] placeholderImage:[UIImage imageNamed:@"placeholder_80x60"]];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]init];
    if (obj.status == 1) {
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
        [imageAttachment setImage:[UIImage imageNamed:@"badge_good"]];
        NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [attributedStr appendAttributedString:imageAttributedString];
    } else if (obj.status == 2) {
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
        [imageAttachment setImage:[UIImage imageNamed:@"badge_top"]];
        NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [attributedStr appendAttributedString:imageAttributedString];
    }

    CGFloat fontSizeTitle = 15;
    CGFloat fontSizeSubtitle = 13;
    switch ((int)[UIScreen mainScreen].bounds.size.height) {
        case 480:
        case 568:{
            fontSizeTitle = 15;
            fontSizeSubtitle = 13;
            break;
        }
        case 667: {
            fontSizeTitle = 17;
            fontSizeSubtitle = 15;
            break;
        }
        case 736: {
            fontSizeTitle = 19;
            fontSizeSubtitle = 17;
            break;
        }
    }
    
    [attributedStr appendAttributedString:[[NSAttributedString alloc]initWithString:obj.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSizeTitle] ,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@"3"}]];
    [_lblTitle setAttributedText:attributedStr];

    [_lblSubtitle setText:obj.brief];
    [_lblSubtitle setFont:[UIFont systemFontOfSize:fontSizeSubtitle]];
}

@end
