//
//  HPAdView.h
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseView.h"

@class HPAdView;

/*!
 *  @brief  HPAdViewDelegate 代理
 */
@protocol HPAdViewDelegate <NSObject>
/*!
 *  @brief  HPAdViewDelegate 代理方法
 *  @param adView 响应该代理方法的 adView
 *  @param index  adView 上被点击的图片的 index
 */
-(void)hpAdView:(HPAdView *)adView clickedAtIndex:(NSUInteger)index;
@end

/// HPAdView.h
@interface HPAdView : BaseView<UIScrollViewDelegate>

/// 代理
@property (strong, nonatomic) id<HPAdViewDelegate> delegate;
/// 占位图
@property (strong, nonatomic) UIImage *placeholderImage;

/*!
 *  @brief  自定义初始化方法
 *  @param frame       frame
 *  @param adObjectArr 广告数组
 *  @return 当前类的一个实体
 */
- (id)initWithFrame:(CGRect)frame adObjectArray:(NSArray *)adObjectArr;

/*!
 *  @brief  数据加载
 *  @param adObjectArr 广告数组
 */
- (void)reloadAdObjectArr:(NSArray *)adObjectArr;

/*!
 *  @brief  自定义初始化方法
 *  @param frame frame
 *  @return 当前类的一个实体
 */
- (id)initWithFrame:(CGRect)frame;
@end
