//
//  FavMessageListImageCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/28.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "FavMessageListImageCell.h"
#import <UIImageView+WebCache.h>

@interface FavMessageListImageCell()
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation FavMessageListImageCell

- (void)awakeFromNib {
    [_viewContainer.layer setCornerRadius:4];
    [_viewContainer.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadDataWithObject:(ArticleObject*)obj {
    [_imgView sd_setImageWithURL:[NSURL URLWithString:obj.imagePath] placeholderImage:[UIImage imageNamed:@"placeholder_80x60"]];
    [_lblTitle setText:obj.name];
    [_lblSubtitle setText:obj.brief];
}

@end
