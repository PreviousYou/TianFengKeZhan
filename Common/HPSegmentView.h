//
//  HPSegmentView.h
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseView.h"

@class HPSegmentView;

@protocol HPSegmentViewDelegate <NSObject>
@optional
/*!
 *  @brief  点击 Segmentview 中的元素所触发的代理方法
 *  @param segmentView 触发事件的HPSegmentView对象
 *  @param index       点击的元素下标
 */
- (void)hpSegmentView:(HPSegmentView*)segmentView didClickItemAtIndex:(NSUInteger)index;
@end

@interface HPSegmentView : BaseView
/// 代理
@property (strong, nonatomic) id<HPSegmentViewDelegate> delegate;
/*!
 *  @brief  初始化方法
 *  @param frame      该View的frame
 *  @param titleArray SegmentView中所有元素标题的数组
 *  @return 该类实例
 */
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray;

/*!
 *  @brief  重新加载数据
 *  @param titleArray SegmentView中所有元素标题的数组
 */
- (void)reloadWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray;
@end
