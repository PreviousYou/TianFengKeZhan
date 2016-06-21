//
//  YGZBasicCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/2.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "YGZBasicCell.h"
#import "SAImageUtility.h"

@interface YGZBasicCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewContainer;
@end

@implementation YGZBasicCell

- (void)awakeFromNib {
    // background round corner
    [_imgViewContainer.layer setCornerRadius:4];
    [_imgViewContainer.layer setMasksToBounds:YES];
    
    // selection style
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[SAImageUtility imageWithColor:[UIColor orangeColor]]];
    [imgView.layer setCornerRadius:6];
    [imgView.layer setMasksToBounds:YES];
    [self setSelectedBackgroundView:imgView];
}

@end
