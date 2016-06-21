//
//  HelpCenterMenuView.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/29.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseView.h"

@interface HelpCenterMenuView : BaseView

/// 调用者ViewController
@property (strong, nonatomic) UIViewController *invokeViewController;
/// 标题颜色数组
@property (strong, nonatomic) NSArray *arrTitleColor;

/*!
 *  @brief  初始化方法
 *  @param frame      该View的frame
 *  @param array  数据数组
 *  @return 该类实例
 */
- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray*)array;

/*!
 *  @brief  重新加载数据
 *  @param array 数据数组
 */
- (void)reloadWithFrame:(CGRect)frame dataArray:(NSArray*)array;
@end
