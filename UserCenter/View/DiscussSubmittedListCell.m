//
//  DiscussSubmittedListCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/27.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "DiscussSubmittedListCell.h"
#import <UIImageView+WebCache.h>

@interface DiscussSubmittedListCell()
@property (weak, nonatomic) IBOutlet UILabel *lblBrief;
@property (weak, nonatomic) IBOutlet UIButton *btnBrowseCount;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentCount;
@property (weak, nonatomic) IBOutlet UIButton *btnFavCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic0;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic1;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic2;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic3;
@end

@implementation DiscussSubmittedListCell

- (void)awakeFromNib {
    [_imgViewBackground.layer setCornerRadius:4];
    [_imgViewBackground.layer setMasksToBounds:YES];
}

- (void)loadDataWithObject:(DiscussObject*)obj {
    [_lblBrief setText:obj.brief];
    [_btnBrowseCount setTitle:[NSString stringWithFormat:@"%d",obj.browseCount] forState:UIControlStateNormal];
    [_btnCommentCount setTitle:[NSString stringWithFormat:@"%d",obj.commentCount] forState:UIControlStateNormal];
    [_btnFavCount setTitle:[NSString stringWithFormat:@"%d",obj.favCount] forState:UIControlStateNormal];
    
    if (obj.imagePath && obj.imagePath.length > 0) {
        [_imageViewHeight setConstant:60];
        NSArray *arrImagePath = [obj.imagePath componentsSeparatedByString:@","];
        NSArray *arrImageView = @[_imgViewPic0,_imgViewPic1,_imgViewPic2,_imgViewPic3];
        for (int i=0;i<MIN(4, arrImagePath.count);i++) {
            UIImageView *imgView = arrImageView[i];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[arrImagePath[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
        }
    } else {
        [_imageViewHeight setConstant:0];
    }
}

@end
