//
//  HCEndVideoListCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/1.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HCEndVideoListCell.h"
#import "WebpageAdvancedViewController.h"
#import "UIStoryboard+SAGetter.h"
#import <UIImageView+WebCache.h>

@interface HCEndVideoListCell()
@property (weak, nonatomic) IBOutlet UIView *viewContainerLeft;
@property (weak, nonatomic) IBOutlet UIView *viewContainerRight;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewRight;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleRight;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;

@property (strong, nonatomic) VideoObject *objLeft;
@property (strong, nonatomic) VideoObject *objRight;
@end

@implementation HCEndVideoListCell
- (void)awakeFromNib {
    [_viewContainerLeft.layer setCornerRadius:6];
    [_viewContainerLeft.layer setMasksToBounds:YES];
    [_viewContainerLeft.layer setBorderColor:[UIColor colorWithWhite:0.769 alpha:1.000].CGColor];
    [_viewContainerLeft.layer setBorderWidth:0.5];
    
    [_viewContainerRight.layer setCornerRadius:6];
    [_viewContainerRight.layer setMasksToBounds:YES];
    [_viewContainerRight.layer setBorderColor:[UIColor colorWithWhite:0.769 alpha:1.000].CGColor];
    [_viewContainerRight.layer setBorderWidth:0.5];
    
    [_imgViewLeft.layer setBorderColor:[UIColor colorWithWhite:0.769 alpha:1.000].CGColor];
    [_imgViewLeft.layer setBorderWidth:0.5];
    [_imgViewRight.layer setBorderColor:[UIColor colorWithWhite:0.769 alpha:1.000].CGColor];
    [_imgViewRight.layer setBorderWidth:0.5];
}

- (void)loadDataWithObjectLeft:(VideoObject*)objLeft objectRight:(VideoObject*)objRight {
    _objLeft = objLeft;
    _objRight = objRight;
    if (objLeft) {
        [_imgViewLeft sd_setImageWithURL:[NSURL URLWithString:objLeft.imagePath] placeholderImage:[UIImage imageNamed:@"placeholder_150x80"]];
        [_lblTitleLeft setText:objLeft.name];
        [_viewContainerLeft setHidden:NO];
    } else {
        [_viewContainerLeft setHidden:YES];
    }
    if (objRight) {
        [_imgViewRight sd_setImageWithURL:[NSURL URLWithString:objRight.imagePath] placeholderImage:[UIImage imageNamed:@"placeholder_150x80"]];
        [_lblTitleRight setText:objRight.name];
        [_viewContainerRight setHidden:NO];
    } else {
        [_viewContainerRight setHidden:YES];
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    VideoObject *obj;
    if (sender == _btnLeft) {
        obj = _objLeft;
    } else if (sender == _btnRight) {
        obj = _objRight;
    }
    WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
    [viewController setSourceType:WebpageSourceTypeVideoID];
    [viewController setWebpageID:obj.objectID];
    [_invokeViewController.navigationController pushViewController:viewController animated:YES];
}
@end
