//
//  MessageListItemCell.m
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/20.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "MessageListItemCell.h"

@interface MessageListItemCell()
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end

@implementation MessageListItemCell

- (void)awakeFromNib {
    [_viewContainer.layer setCornerRadius:8];
    [_viewContainer.layer setMasksToBounds:YES];
    [_viewContainer.layer setBorderColor:[UIColor colorWithWhite:0.769 alpha:1.000].CGColor];
    [_viewContainer.layer setBorderWidth:0.5];
    [_lblBadgeNew.layer setCornerRadius:4];
    [_lblBadgeNew.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadDataWithDictionary:(NSDictionary*)dict {
    
    NSString *date = [dict objectForKey:@"createDate"];
    
    if (date.length >= 16) {
        NSString *dateNomal = [date substringToIndex:16];
        [_lblTime setText:dateNomal];
    }else {
        [_lblTime setText:date];
    }
    

    [_lblContent setText:dict[@"content"]];
//    [_lblBadgeNew setHidden:[dict[@"isread"] boolValue]];
    NSString *lastOpenTime = dict[@"lastOpenNotify"];
    NSString *createTime = dict[@"createDate"];
    lastOpenTime = [lastOpenTime substringToIndex:MIN(lastOpenTime.length, createTime.length)];
    createTime = [createTime substringToIndex:MIN(lastOpenTime.length, createTime.length)];
    [_lblBadgeNew setHidden:([lastOpenTime compare:createTime] == NSOrderedDescending)];
    [_lblTitle setText:dict[@"subject"]];
}
@end
