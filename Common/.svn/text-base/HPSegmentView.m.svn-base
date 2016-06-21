//
//  HPSegmentView.m
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HPSegmentView.h"
#define BASETAG 10

@interface HPSegmentView()
@property (assign, nonatomic) NSUInteger segmentCount;
@end
    
@implementation HPSegmentView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray {
    if (self = [super initWithFrame:frame]) {
        [self reloadWithFrame:frame titleArray:titleArray];
    }
    return self;
}

- (void)reloadWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self setBackgroundColor:[UIColor colorWithWhite:0.941 alpha:1.000]];
    CGFloat itemWidth = frame.size.width / titleArray.count;
    CGFloat itemHeight = frame.size.height;
    for (int i=0;i<titleArray.count;i++) {
        UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnItem setTitle:titleArray[i] forState:UIControlStateNormal];
        [btnItem setTitleColor:[UIColor colorWithWhite:0.204 alpha:1.000] forState:UIControlStateNormal];
        [btnItem setTitleColor:[UIColor colorWithRed:0.027 green:0.588 blue:0.000 alpha:1.000] forState:UIControlStateSelected];
        [btnItem setBackgroundColor:[UIColor clearColor]];
        [btnItem setBackgroundImage:nil forState:UIControlStateNormal];
        [btnItem setBackgroundImage:[UIImage imageNamed:@"segment_indicator"] forState:UIControlStateSelected];
        [btnItem.titleLabel setFont:[UIFont fontWithName:@"Verdana" size:14]];
        [btnItem setFrame:CGRectMake(i*itemWidth, 0, itemWidth, itemHeight)];
        [btnItem setTag:BASETAG + i];
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnItem];
        
        //UIImageView *imgViewSeperator = [[UIImageView alloc]initWithFrame:CGRectMake(i*itemWidth, 4, 0.5, itemHeight - 8)];
        //[imgViewSeperator setBackgroundColor:[UIColor colorWithWhite:0.780 alpha:1.000]];
        //[self addSubview:imgViewSeperator];
    }
    _segmentCount = titleArray.count;
    [((UIButton*)[self viewWithTag:BASETAG]) setSelected:YES];
}

- (void)btnItemClick:(UIButton*)sender {
    for (int i=0;i<_segmentCount;i++) {
        UIButton *btnItem = (UIButton*)[self viewWithTag:BASETAG + i];
        if (btnItem) {
            [btnItem setSelected:NO];
        }
    }
    [sender setSelected:YES];
    if ([_delegate respondsToSelector:@selector(hpSegmentView:didClickItemAtIndex:)]) {
        [_delegate hpSegmentView:self didClickItemAtIndex:sender.tag - BASETAG];
    }
}

@end
