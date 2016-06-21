//
//  HelpCenterMenuItemView.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/29.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseView.h"

@interface HelpCenterMenuItemView : BaseView

@property (strong, nonatomic) UIViewController *invokeViewController;

/*!
 *  @brief  初始化方法
 *  @param frame      该View的frame
 *  @param dict  数据字典
 *  @param color 标题背景颜色
 *  @return 该类实例
 */
- (instancetype)initWithFrame:(CGRect)frame dataDictionary:(NSDictionary*)dict backgroundColor:(UIColor*)color;

/*!
 *  @brief  重新加载数据
 *  @param dict 数据字典
 *  @param color 标题背景颜色 
 */
- (void)reloadWithFrame:(CGRect)frame dataDictionary:(NSDictionary*)dict backgroundColor:(UIColor*)color;
@end
