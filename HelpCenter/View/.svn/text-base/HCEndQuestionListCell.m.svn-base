//
//  HCEndQuestionListCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/1.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HCEndQuestionListCell.h"
#import "SAImageUtility.h"

@interface HCEndQuestionListCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewContainer;
@end


@implementation HCEndQuestionListCell
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
