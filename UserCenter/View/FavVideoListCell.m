//
//  FavVideoListCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/26.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "FavVideoListCell.h"
#import <UIImageView+WebCache.h>

@interface FavVideoListCell()
@property (strong, nonatomic) VideoObject *videoObj;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@end

@implementation FavVideoListCell

- (void)awakeFromNib {
    [_viewContainer.layer setCornerRadius:6];
    [_viewContainer.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadDataWithObject:(VideoObject*)obj {
    [_lblTitle setText:obj.name];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:obj.imagePath] placeholderImage:[UIImage imageNamed:@"placeholder_310x170"]];
}

@end
