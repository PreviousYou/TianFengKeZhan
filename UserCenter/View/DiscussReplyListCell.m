//
//  DiscussReplyListCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/27.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "DiscussReplyListCell.h"
#import "CommonFunction.h"
#import <UIImageView+WebCache.h>

@interface DiscussReplyListCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBrief;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblGrade;
@end


@implementation DiscussReplyListCell

- (void)awakeFromNib {
    [_imgViewBackground.layer setCornerRadius:4];
    [_imgViewBackground.layer setMasksToBounds:YES];
    [_lblGrade.layer setCornerRadius:4];
    [_lblGrade.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadDataWithDictionary:(NSDictionary*)dict {
    [_imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"headerImg"]] placeholderImage:[UIImage imageNamed:@"placeholder_50x50"]];
    [_lblName setText:dict[@"nick"]];
    [_lblGrade setText:dict[@"grade"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_lblTime setText:[CommonFunction compareCurrentTime:[formatter dateFromString:dict[@"createDate"]]]];

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]init];
    NSString *parentID = dict[@"parentId"];
    if (parentID && parentID.length > 0) {
        [attributedStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"回复了你：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.373 green:0.639 blue:0.267 alpha:1.000], NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
    } else {
        [attributedStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"评论了你：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.373 green:0.639 blue:0.267 alpha:1.000], NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
    }
    [attributedStr appendAttributedString:[[NSAttributedString alloc]initWithString:dict[@"content"] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.145 alpha:1.000], NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
    [_lblBrief setAttributedText:attributedStr];
}

@end
