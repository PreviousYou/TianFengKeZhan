//
//  HCSubListCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/31.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HCSubListCell.h"
#import "SAImageUtility.h"

@interface HCSubListCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewContainer;
@end

@implementation HCSubListCell
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
