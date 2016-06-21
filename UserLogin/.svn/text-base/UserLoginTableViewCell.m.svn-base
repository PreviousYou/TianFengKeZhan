//
//  UserLoginTableViewCell.m
//  TianFengKeZhan
//
//  Created by zhou on 15/9/22.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "UserLoginTableViewCell.h"
#define UserDidClick @"UserClickNotification"

@implementation UserLoginTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidClick object:nil userInfo:nil];
    
}

@end
