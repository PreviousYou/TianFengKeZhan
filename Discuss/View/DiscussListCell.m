//
//  DiscussListCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/24.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "DiscussListCell.h"
#import "CommonFunction.h"
#import <UIImageView+WebCache.h>

@interface DiscussListCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBrief;
@property (weak, nonatomic) IBOutlet UIButton *btnBrowseCount;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentCount;
@property (weak, nonatomic) IBOutlet UIButton *btnFavCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblGrade;
@property (weak, nonatomic) IBOutlet UIImageView *badgeTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBadge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic0;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic1;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic2;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeight;

@end

@implementation DiscussListCell
- (void)awakeFromNib {
    [_imgViewBackground.layer setCornerRadius:4];
    [_imgViewBackground.layer setMasksToBounds:YES];
    [_lblGrade.layer setCornerRadius:4];
    [_lblGrade.layer setMasksToBounds:YES];
    [_separatorHeight setConstant: 1.0 / [UIScreen mainScreen].scale];
}

- (void)loadDataWithObject:(DiscussObject*)obj {
    [_imgView sd_setImageWithURL:[NSURL URLWithString:obj.userObj.imagePath] placeholderImage:[UIImage imageNamed:@"placeholder_50x50"]];
    [_lblName setText:obj.userObj.nickName];
    [_lblTime setText:[[CommonFunction compareCurrentTime:obj.createDate] stringByAppendingString:@" 发布"]];
    [_lblBrief setText:obj.brief];
    
    if (obj.imagePath && obj.imagePath.length > 0) {
        [_imageViewHeight setConstant:60];
        NSArray *arrImagePath = [obj.imagePath componentsSeparatedByString:@","];
        NSArray *arrImageView = @[_imgViewPic0,_imgViewPic1,_imgViewPic2,_imgViewPic3];
        for (int i=0;i<MIN(4, arrImagePath.count);i++) {
            UIImageView *imgView = arrImageView[i];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[arrImagePath[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
            [imgView setHidden:NO];
        }
        for (NSUInteger i=arrImagePath.count;i<4;i++) {
            UIImageView *imgView = arrImageView[i];
            [imgView setHidden:YES];
        }

    } else {
        [_imageViewHeight setConstant:0];
    }
    
    [_btnBrowseCount setTitle:[NSString stringWithFormat:@"%d",obj.browseCount] forState:UIControlStateNormal];
    [_btnCommentCount setTitle:[NSString stringWithFormat:@"%d",obj.commentCount] forState:UIControlStateNormal];
    [_btnFavCount setTitle:[NSString stringWithFormat:@"%d",obj.favCount] forState:UIControlStateNormal];
    [_lblGrade setText:obj.userObj.grade];
    
    if (obj.status == 0) {
        [_imgViewBadge setHidden:YES];
    } else {
        [_imgViewBadge setHidden:NO];
        if (obj.status == 1) {
            [_imgViewBadge setImage:[UIImage imageNamed:@"badge_good"]];
        } else if (obj.status == 2) {
            [_imgViewBadge setImage:[UIImage imageNamed:@"badge_top"]];
        }
    }
    
}

@end
