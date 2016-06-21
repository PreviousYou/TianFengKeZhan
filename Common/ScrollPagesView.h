//
//  ScrollPagesView.h
//  wozaijinan
//
//  Created by 杜保全 on 15/1/7.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGAlertView.h"
@interface ScrollPagesView : UIView<UIScrollViewDelegate,LGAlertViewDelegate,UINavigationControllerDelegate>
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) NSArray *viewControllers;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,retain) NSMutableArray *visibleViews;
@property (nonatomic,assign) CGFloat currentContentOffsetX;
@property (assign, nonatomic) NSInteger ScrollingType;

-(id)initWithFrame:(CGRect)frame iewControllers:(NSArray*)viewControllers atPage:(NSInteger)page;

@end
