//
//  KeywordListView.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/8.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseView.h"

@protocol KeywordListViewDelegate<NSObject>
- (void)keywordSelected:(NSString*)keyword;
@end

@interface KeywordListView : BaseView
@property (strong, nonatomic) id<KeywordListViewDelegate> delegate;

/*!
 *  @brief  初始化方法
 *  @param frame      该View的frame
 *  @param dict  数据字典
 *  @param color 标题背景颜色
 *  @return 该类实例
 */
- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray*)array backgroundColor:(UIColor*)color;

/*!
 *  @brief  重新加载数据
 *  @param dict 数据字典
 *  @param color 标题背景颜色
 */
- (void)reloadWithFrame:(CGRect)frame dataArray:(NSArray*)array backgroundColor:(UIColor*)color;

@end
