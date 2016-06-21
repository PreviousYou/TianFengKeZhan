//
//  FavMessageListCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/26.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "FavMessageListBasicCell.h"

@interface FavMessageListBasicCell()
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;

@end

@implementation FavMessageListBasicCell

- (void)awakeFromNib {
    [_viewContainer.layer setCornerRadius:4];
    [_viewContainer.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadDataWithObject:(ArticleObject*)obj {
    [_lblTitle setText:obj.name];
    [_lblSubtitle setText:obj.brief];
}

@end
