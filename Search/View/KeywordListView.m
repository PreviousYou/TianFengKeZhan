//
//  KeywordListView.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/8.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "KeywordListView.h"
#import "SAImageUtility.h"

@interface KeywordListView()
@property (strong, nonatomic) NSMutableArray *arrView; //按钮数组
@property (strong, nonatomic) NSArray *arrData;
@end

@implementation KeywordListView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array backgroundColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        _arrView = [[NSMutableArray alloc]init];
        [self reloadWithFrame:frame dataArray:array backgroundColor:color];
    }
    return self;
}

- (void)reloadWithFrame:(CGRect)frame dataArray:(NSArray *)array backgroundColor:(UIColor *)color {
    const CGFloat initialPosX = 10; //左侧初始X坐标
    const CGFloat heightPerLine = 30; //每行高度
    const CGFloat horizontalSpace = 10; //横向间隔
    const CGFloat verticalSpace = 17; //纵向间隔
    
    _arrData = array ? array : @[];
    
    CGFloat posX = initialPosX; //当前X坐标
    CGFloat posY = verticalSpace; //当前Y坐标
    CGRect rect;
    
    if (_arrView.count < array.count) {
        for (NSUInteger i=0;i<_arrView.count;i++) {
            //直接使用之前创建的ItemView
            UIButton *view = _arrView[i];
            NSDictionary *dictItem = array[i];
            [self reloadButton:view withText:dictItem[@"word"] tag:i highlightedColor:color];
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
            UIButton *view = [self generateButtonWithText:dictItem[@"word"] tag:i highlightedColor:color];
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
            [self reloadButton:view withText:dictItem[@"word"] tag:i highlightedColor:color];
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button setTitleColor:[UIColor colorWithWhite:0.106 alpha:1.000] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self reloadButton:button withText:text tag:tag highlightedColor:color];
    return button;
}

- (void)reloadButton:(UIButton*)button withText:(NSString*)text tag:(NSUInteger)tag highlightedColor:(UIColor*)color {
    const CGFloat heightPerLine = 30; //每行高度
    
    [button setTitle:text forState:UIControlStateNormal];
    [button sizeToFit];
    CGRect rect = button.frame;
    rect.size.width += 20;
    rect.size.height = heightPerLine;
    [button setFrame:rect];
    [button setTag:tag];
}

- (void)btnClick:(UIButton*)sender {
    if (_delegate) {
        [_delegate keywordSelected:sender.currentTitle];
    }
}
@end
