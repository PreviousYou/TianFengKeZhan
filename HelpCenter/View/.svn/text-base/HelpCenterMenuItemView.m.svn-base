//
//  HelpCenterMenuItemView.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/29.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HelpCenterMenuItemView.h"
#import "SAImageUtility.h"
#import "HCSubListViewController.h"
#import "HCEndQuestionListViewController.h"
#import "HCEndVideoListViewController.h"

@interface HelpCenterMenuItemView()
@property (strong, nonatomic) NSMutableArray *arrView; //按钮数组
@property (strong, nonatomic) UILabel *lblTitle; //标题标签
@property (strong, nonatomic) NSArray *arrData;
@end

@implementation HelpCenterMenuItemView
const CGFloat initialPosX = 10; //左侧初始X坐标
const CGFloat heightPerLine = 30; //每行高度
const CGFloat horizontalSpace = 10; //横向间隔
const CGFloat verticalSpace = 17; //纵向间隔

- (instancetype)initWithFrame:(CGRect)frame dataDictionary:(NSDictionary *)dict backgroundColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        _arrView = [[NSMutableArray alloc]init];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:4];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderWidth:0.5];
        [self.layer setBorderColor:[UIColor colorWithWhite:0.843 alpha:1.000].CGColor];
        _lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 35)];
        [_lblTitle setTextAlignment:NSTextAlignmentCenter];
        [_lblTitle setTextColor:[UIColor whiteColor]];
        [_lblTitle setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_lblTitle];
        [self reloadWithFrame:frame dataDictionary:dict backgroundColor:color];
    }
    return self;
}

- (void)reloadWithFrame:(CGRect)frame dataDictionary:(NSDictionary *)dict backgroundColor:(UIColor *)color{
    [_lblTitle setText:dict[@"name"]];
    if (color) {
        [_lblTitle setBackgroundColor:color];
    } else {
        [_lblTitle setBackgroundColor:[UIColor whiteColor]];
    }
    
    NSArray *array = dict[@"children"];
    if (!array) {
        array = @[];
    }
    _arrData = array;

    CGFloat posX = initialPosX; //当前X坐标
    CGFloat posY = _lblTitle.frame.origin.y + _lblTitle.frame.size.height + verticalSpace; //当前Y坐标
    CGRect rect;
    
    if (_arrView.count < array.count) {
        for (NSUInteger i=0;i<_arrView.count;i++) {
            //直接使用之前创建的ItemView
            UIButton *view = _arrView[i];
            NSDictionary *dictItem = array[i];
            [self reloadButton:view withText:dictItem[@"name"] tag:i highlightedColor:color];
            rect = view.frame;
            if (posX + rect.size.width > self.frame.size.width)
            {
                posX = initialPosX;
                posY += (heightPerLine + verticalSpace);
            }
            rect.origin.x = posX;
            rect.origin.y = posY;
            [view setFrame:rect];
            posX += (rect.size.width + horizontalSpace);
        }
        for (NSUInteger i=_arrView.count;i<array.count;i++) {
            //创建新的ItemView
            NSDictionary *dictItem = array[i];
            UIButton *view = [self generateButtonWithText:dictItem[@"name"] tag:i highlightedColor:color];
            rect = view.frame;
            if (posX + rect.size.width > self.frame.size.width)
            {
                posX = initialPosX;
                posY += (heightPerLine + verticalSpace);
            }
            rect.origin.x = posX;
            rect.origin.y = posY;
            [view setFrame:rect];
            posX += (rect.size.width + horizontalSpace);
            [self addSubview:view];
            [_arrView addObject:view];
        }
    } else {
        for (NSUInteger i=0;i<array.count;i++) {
            //直接使用之前创建的ItemView
            UIButton *view = _arrView[i];
            NSDictionary *dictItem = array[i];
            [self reloadButton:view withText:dictItem[@"name"] tag:i highlightedColor:color];
            rect = view.frame;
            if (posX + rect.size.width > self.frame.size.width)
            {
                posX = initialPosX;
                posY += (heightPerLine + verticalSpace);
            }
            rect.origin.x = posX;
            rect.origin.y = posY;
            [view setFrame:rect];
            posX += (rect.size.width + horizontalSpace);
        }
        for (NSUInteger i=array.count;i<_arrView.count;i++) {
            //清除之前创建的多余的ItemView
            UIButton *view = _arrView[i];
            [view removeFromSuperview];
        }
        [_arrView removeObjectsInRange:NSMakeRange(array.count, _arrView.count - array.count)];
    }
    
    posY += (heightPerLine + verticalSpace);
    
    //根据最后的Y坐标值更新自身的frame
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, posY)];
}

- (UIButton*)generateButtonWithText:(NSString*)text tag:(NSUInteger)tag highlightedColor:(UIColor*)color {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[SAImageUtility imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button.layer setBorderWidth:0.5f];
    [button.layer setBorderColor:[UIColor colorWithWhite:0.855 alpha:1.000].CGColor];
    [button.layer setCornerRadius:4.0f];
    [button.layer setMasksToBounds:YES];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button setTitleColor:[UIColor colorWithWhite:0.314 alpha:1.000] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self reloadButton:button withText:text tag:tag highlightedColor:color];
    return button;
}

- (void)reloadButton:(UIButton*)button withText:(NSString*)text tag:(NSUInteger)tag highlightedColor:(UIColor*)color {
    [button setBackgroundImage:[SAImageUtility imageWithColor:color] forState:UIControlStateHighlighted];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateHighlighted];
    [button sizeToFit];
    CGRect rect = button.frame;
    rect.size.width += 20;
    rect.size.height = heightPerLine;
    [button setFrame:rect];
    [button setTag:tag];
}

- (void)btnClick:(UIButton*)sender {
    NSDictionary *dictItem = _arrData[sender.tag];
    if ([dictItem[@"isLeaf"] intValue] == 0) {
        // 进入子类别列表
        HCSubListViewController *viewController = [_invokeViewController.storyboard instantiateViewControllerWithIdentifier:@"HCSubListViewController"];
        [viewController setDictBase:dictItem];
        [_invokeViewController.navigationController pushViewController:viewController animated:YES];
    } else {
        if ([dictItem[@"type"] intValue] == 0) {
            // 进入问题列表
            HCEndQuestionListViewController *viewController = [_invokeViewController.storyboard instantiateViewControllerWithIdentifier:@"HCEndQuestionListViewController"];
            [viewController setCategoryID:dictItem[@"id"]];
            [viewController setCategoryTitle:dictItem[@"name"]];
            [_invokeViewController.navigationController pushViewController:viewController animated:YES];
        } else {
            // 进入视频列表
            HCEndVideoListViewController *viewController = [_invokeViewController.storyboard instantiateViewControllerWithIdentifier:@"HCEndVideoListViewController"];
            [viewController setCategoryID:dictItem[@"id"]];
            [viewController setCategoryTitle:dictItem[@"name"]];
            [_invokeViewController.navigationController pushViewController:viewController animated:YES];
        }
    }
}

@end
