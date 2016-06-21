//
//  ScrollPagesViewController.h
//  wozaijinan
//
//  Created by 杜保全 on 15/1/7.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"




/*!
 ScrollPagesViewController.h
 */
@interface ScrollPagesViewController : BaseViewController
@property (strong, nonatomic) NSArray *viewControllers;
@property (nonatomic,assign) NSInteger currentPage;
/*!
 *  @brief  自定义初始化方法
 *  @param viewControllers 存放viewController 的数组
 *  @param page            当前所在页面
 *  @return 当前类的实例
 */
-(id)initWithViewControllers:(NSArray*)viewControllers atPage:(NSInteger)page;

/*!
 *  @brief  切换 viewController 的滑动方法
 *  @param page      滑动到的页面
 *  @param animation 是否需要动画，yes 为有动画
 */
-(void)scrollToPage:(NSInteger)page animation:(BOOL)animation;

@end
