//
//  DetailOperationView.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/6.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "DetailOperationView.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "AppConfig.h"

@implementation DetailOperationView

- (instancetype)initWithFrame:(CGRect)frame shareEnabled:(BOOL)shareEnabled favEnabled:(BOOL)favEnabled reportEnabled:(BOOL)reportEnabled {
    if (self = [super initWithFrame:frame]) {
        [self reloadWithShareEnabled:shareEnabled favEnabled:favEnabled reportEnabled:reportEnabled];
    }
    return self;
}

- (void)reloadWithShareEnabled:(BOOL)shareEnabled favEnabled:(BOOL)favEnabled reportEnabled:(BOOL)reportEnabled {
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    [self setClipsToBounds:YES];
    
    int perLine = 4;
    CGFloat perWidth = self.frame.size.width / perLine;
    CGFloat perHeight = perWidth * 9 / 8; // the ratio of width and height is 80:90
    
    NSMutableArray *arrOperation = [[NSMutableArray alloc]init];
    
    if (shareEnabled) {
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            NSDictionary *dict = @{@"title":@"微信",
                                   @"image":[UIImage imageNamed:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_wechat_session_icon"],
                                   @"type":@(DetailOperationTypeShareToWechatSession)};
            [arrOperation addObject:dict];
        }
        if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
            NSDictionary *dict = @{@"title":@"QQ",
                                   @"image":[UIImage imageNamed:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_qq_icon"],
                                   @"type":@(DetailOperationTypeShareToQQ)};
            [arrOperation addObject:dict];
        }
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            NSDictionary *dict = @{@"title":@"朋友圈",
                                   @"image":[UIImage imageNamed:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_wechat_timeline_icon"],
                                   @"type":@(DetailOperationTypeShareToWechatTimeline)};
            [arrOperation addObject:dict];
        }
        if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
            NSDictionary *dict = @{@"title":@"QQ空间",
                                   @"image":[UIImage imageNamed:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_qzone_icon"],
                                   @"type":@(DetailOperationTypeShareToQzone)};
            [arrOperation addObject:dict];
        }
        [arrOperation addObject:@{@"title":@"新浪微博",
                                  @"image":[UIImage imageNamed:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_sina_icon"],
                                  @"type":@(DetailOperationTypeShareToWeibo)}];
        [arrOperation addObject:@{@"title":@"腾讯微博",
                                  @"image":[UIImage imageNamed:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/UMS_tencent_icon"],
                                  @"type":@(DetailOperationTypeShareToTencent)}];
    }
    
    if (favEnabled){
        [arrOperation addObject:@{@"title":@"收藏",
                                  @"image":[UIImage imageNamed:@"btnFav"],
                                  @"type":@(DetailOperationTypeFavorite)}];
    }
    if (reportEnabled) {
        [arrOperation addObject:@{@"title":@"举报",
                                  @"image":[UIImage imageNamed:@"btnReport"],
                                  @"type":@(DetailOperationTypeReport)}];
    }
    
    for (int i=0;i<arrOperation.count;i++) {
        NSDictionary *dictItem = arrOperation[i];
        UIButton *button = [self generateButtonWithText:dictItem[@"title"] image:dictItem[@"image"] tag:[dictItem[@"type"] intValue]];
        [button setFrame:CGRectMake(i % perLine * perWidth, i / perLine * perHeight, perWidth, perHeight)];
        [self addSubview:button];
    }
    
    CGRect rect = self.frame;
    rect.size.height = (arrOperation.count + perLine - 1) / perLine * perHeight;
    [self setFrame:rect];
}

- (void)setButtonStyleToVertically:(UIButton*)button {
    CGFloat spacing = 6.0;
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake( -(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
}

- (UIButton*)generateButtonWithText:(NSString*)text image:(UIImage*)image tag:(NSUInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:text forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTag:tag];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonStyleToVertically:button];
    return button;
}

- (void)btnClick:(UIButton*)sender {
    switch (sender.tag) {
        case DetailOperationTypeShareToWechatSession:
        case DetailOperationTypeShareToWechatTimeline:
        case DetailOperationTypeShareToQQ:
        case DetailOperationTypeShareToQzone:
        case DetailOperationTypeShareToWeibo:
        case DetailOperationTypeShareToTencent:
            [_delegate shareClickWithPlatForm:sender.tag];
            break;
        case DetailOperationTypeFavorite:
            [_delegate favClick];
            break;
        case DetailOperationTypeReport:
            [_delegate reportClick];
            break;
        default:
            break;
    }
}

@end
