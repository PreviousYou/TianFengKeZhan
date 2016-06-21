//
//  HelpCenterMenuView.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/29.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HelpCenterMenuView.h"
#import "HelpCenterMenuItemView.h"

@interface HelpCenterMenuView()
@property (strong, nonatomic) NSMutableArray *arrView; //ItemView数组
@property (strong, nonatomic) UIImageView *imgViewNoData; //无数据图片
@end

@implementation HelpCenterMenuView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array {
    if (self = [super initWithFrame:frame]) {
        [self.layer setMasksToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        _arrView = [[NSMutableArray alloc]init];
        if (!_arrTitleColor) {
            _arrTitleColor = @[[UIColor colorWithRed:0.992 green:0.655 blue:0.157 alpha:1.000],[UIColor colorWithRed:0.255 green:0.361 blue:0.996 alpha:1.000],[UIColor colorWithRed:0.984 green:0.208 blue:0.035 alpha:1.000],[UIColor colorWithRed:0.275 green:0.580 blue:0.149 alpha:1.000]];
        }
        _imgViewNoData = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
        [_imgViewNoData setFrame:CGRectMake(0, 0, frame.size.width, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 40)];
        [_imgViewNoData setContentMode:UIViewContentModeCenter];
        [_imgViewNoData setHidden:YES];
        [self addSubview:_imgViewNoData];
        [self reloadWithFrame:frame dataArray:array];
    }
    return self;
}

- (void)reloadWithFrame:(CGRect)frame dataArray:(NSArray *)array {
    if (!array || array.count == 0) {
        //无数据，显示无数据提示图
        [_imgViewNoData setHidden:NO];
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _imgViewNoData.frame.size.height)];
        for (UIView *view in _arrView) {
            [view removeFromSuperview];
        }
        [_arrView removeAllObjects];
        return;
    }
    
    CGFloat leftMargin = 6; //左侧边距
    CGFloat verticalSpace = 8; //纵向间隔
    CGFloat posY = verticalSpace; //当前Y坐标
    [_imgViewNoData setHidden:YES];
    
    if (_arrView.count < array.count) {
        for (NSUInteger i=0;i<_arrView.count;i++) {
            //直接使用之前创建的ItemView
            HelpCenterMenuItemView *view = _arrView[i];
            [view reloadWithFrame:CGRectMake(leftMargin, posY, frame.size.width - leftMargin * 2, 0) dataDictionary:array[i] backgroundColor:_arrTitleColor[i % _arrTitleColor.count]];
            posY += (view.frame.size.height + verticalSpace);
        }
        for (NSUInteger i=_arrView.count;i<array.count;i++) {
            //创建新的ItemView
            HelpCenterMenuItemView *view = [[HelpCenterMenuItemView alloc]initWithFrame:CGRectMake(leftMargin, posY, frame.size.width - leftMargin * 2, 0) dataDictionary:array[i] backgroundColor:_arrTitleColor[i % _arrTitleColor.count]];
            [view setInvokeViewController:_invokeViewController];
            posY += (view.frame.size.height + verticalSpace);
            [self addSubview:view];
            [_arrView addObject:view];
        }
    } else {
        for (NSUInteger i=0;i<array.count;i++) {
            //直接使用之前创建的ItemView
            HelpCenterMenuItemView *view = _arrView[i];
            [view reloadWithFrame:CGRectMake(leftMargin, posY, frame.size.width - leftMargin * 2, 0) dataDictionary:array[i] backgroundColor:_arrTitleColor[i % _arrTitleColor.count]];
            posY += (view.frame.size.height + verticalSpace);
        }
        for (NSUInteger i=array.count;i<_arrView.count;i++) {
            //清除之前创建的多余的ItemView
            HelpCenterMenuItemView *view = _arrView[i];
            [view removeFromSuperview];
        }
        [_arrView removeObjectsInRange:NSMakeRange(array.count, _arrView.count - array.count)];
    }
    //根据最后的Y坐标值更新自身的frame
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, posY)];
}
@end
