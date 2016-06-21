//
//  ScrollPagesView.m
//  wozaijinan
//
//  Created by 杜保全 on 15/1/7.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "ScrollPagesView.h"
#import "ScrollPagesViewController.h"
#import "CommonFunction.h"
#import "LoginedUserHandler.h"
#import "LoginViewController.h"
#import "UIStoryboard+SAGetter.h"
#import "UIView+viewController.h"
#import "HomeViewController.h"
#import "AnnounceViewController.h"
#import "DiscussViewController.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define ScrollNotification @"ScrollNotification"


typedef NS_ENUM(NSUInteger, ScrollingType){
//    向右滑
    ScrollingRightType,
//    向左滑
    ScrollingleftType
};

//视图控制器index
typedef NS_ENUM(NSInteger, ViewControllerIndexNumber) {
//    首页
    HomeViewControllerNmuber = 0,
//    通知公告
    AnnounceViewControllerNmuber = 1,
//    交流
    DiscussViewControllerNmuber = 2,
//    咨询
    ChatViewControllerNmuber = 3,
//    办税
    TaxViewControllerNmuber = 4
};

@implementation ScrollPagesView

-(id)initWithFrame:(CGRect)frame iewControllers:(NSArray*)viewControllers atPage:(NSInteger)page{
    self  = [super initWithFrame:frame];
    if (self) {
        
        self.currentPage = page;
        self.viewControllers = viewControllers;
        self.visibleViews = [NSMutableArray array];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        [self.scrollView setContentSize:CGSizeMake(SCREENWIDTH * viewControllers.count, SCREENHEIGHT - 20 - 44 - 49)];
        
        
        for (int i = 0; i < self.viewControllers.count; i ++) {
            UIViewController *viewController = self.viewControllers[i];
            viewController.view.frame = CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, SCREENHEIGHT - 20 - 44 - 49);
            [self.scrollView addSubview:viewController.view];
        }
        [self addSubview:self.scrollView];
        
        self.userInteractionEnabled = YES;
        self.scrollView.bounces = NO;
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.ScrollingType == ScrollingRightType) {
        if (![LoginedUserHandler loginedUser].logined) {
            if (self.currentPage == ChatViewControllerNmuber) {
                self.scrollView.scrollEnabled = NO;
            }
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.ScrollingType == ScrollingRightType) {
        if (![LoginedUserHandler loginedUser].logined) {
            if (self.currentPage == DiscussViewControllerNmuber) {
                
                LGAlertView *alertView3 = [[LGAlertView alloc]initWithTitle:nil message:@"\n您尚未登录，暂不能进行此操作哦！马上登录吧！\n" buttonTitles:@[@"登录"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
                alertView3.delegate = self;
                [alertView3 showAnimated:YES completionHandler:nil];
                [CommonFunction setStyleOfLGAlertView:alertView3];
                self.scrollView.scrollEnabled = NO;
            }else if (self.currentPage == ChatViewControllerNmuber) {
                
                LGAlertView *alertView4 = [[LGAlertView alloc]initWithTitle:nil message:@"\n您尚未登录，暂不能进行此操作哦！马上登录吧！\n" buttonTitles:@[@"登录"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
                alertView4.delegate = self;
                [alertView4 showAnimated:YES completionHandler:nil];
                [CommonFunction setStyleOfLGAlertView:alertView4];
                self.scrollView.scrollEnabled = NO;
            }
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x <self.currentContentOffsetX) {
        if (self.currentPage>=0) {
            self.ScrollingType = ScrollingleftType;
        }
    }else if (scrollView.contentOffset.x > self.currentContentOffsetX ){
        if ((self.currentPage+1)<=(self.viewControllers.count-1)) {
            self.ScrollingType = ScrollingRightType;
        }
    }
    
    self.currentContentOffsetX = scrollView.contentOffset.x;
    self.currentPage = (int)(scrollView.contentOffset.x / SCREENWIDTH);
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.ScrollingType == ScrollingleftType) {
        NSDictionary *dic = @{
                              @"index":[NSNumber numberWithInteger:self.currentPage ]
                              };
        [[NSNotificationCenter defaultCenter] postNotificationName:ScrollNotification object:nil userInfo:dic];
    }else if (self.ScrollingType == ScrollingRightType) {
        NSDictionary *dic = @{
                              @"index":[NSNumber numberWithInteger:self.currentPage ]
                              };
        if (self.currentPage  <= TaxViewControllerNmuber) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ScrollNotification object:nil userInfo:dic];
        }
    }
    [self reloadNavigationItem];
}


- (void)reloadNavigationItem {
    ScrollPagesViewController *scrollPagesVC = (ScrollPagesViewController *)[self viewController];
    HomeViewController *homeVC = self.viewControllers[0];
    AnnounceViewController *annVC = self.viewControllers[1];
    DiscussViewController *disVC = self.viewControllers[2];
    
    switch (self.currentPage) {
        case HomeViewControllerNmuber:
            [scrollPagesVC.navigationItem setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_titleLogo"]]];
            scrollPagesVC.navigationItem.leftBarButtonItem = homeVC.leftBarButonItem;
            scrollPagesVC.navigationItem.rightBarButtonItem = homeVC.rightBarBtttonItem;
            break;
        case AnnounceViewControllerNmuber:
            scrollPagesVC.navigationItem.titleView = nil;
            scrollPagesVC.navigationItem.rightBarButtonItem = annVC.rightBarButtonItem;
            scrollPagesVC.navigationItem.leftBarButtonItem = nil;
            break;
        case DiscussViewControllerNmuber:
            scrollPagesVC.navigationItem.titleView = nil;
            scrollPagesVC.navigationItem.leftBarButtonItem = disVC.leftBarButtonItem;
            scrollPagesVC.navigationItem.rightBarButtonItem = disVC.rightBarButtonItem;
            break;
        case ChatViewControllerNmuber:
            scrollPagesVC.navigationItem.titleView = nil;
            scrollPagesVC.navigationItem.leftBarButtonItem = nil;
            scrollPagesVC.navigationItem.rightBarButtonItem = nil;
            break;
        case TaxViewControllerNmuber:
            scrollPagesVC.navigationItem.titleView = nil;
            scrollPagesVC.navigationItem.leftBarButtonItem = nil;
            scrollPagesVC.navigationItem.rightBarButtonItem = nil;
            break;
        default:
            break;
    }
}


- (void)pushLoginViewController:(NSInteger )index {
    LoginViewController *viewController = [[UIStoryboard userLoginStoryboard] instantiateInitialViewController];
    UINavigationController *naviga = [self viewController].navigationController;
    [naviga pushViewController:viewController animated:YES];
}

- (void)alertView:(LGAlertView *)alertView buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index {
    
    [self pushLoginViewController:ChatViewControllerNmuber];
    ScrollPagesViewController *scrollPage = (ScrollPagesViewController *)[self viewController];
    [scrollPage scrollToPage:DiscussViewControllerNmuber animation:YES];
    
    NSDictionary *dic = @{
                          @"index":[NSNumber numberWithInteger:DiscussViewControllerNmuber ]
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:ScrollNotification object:nil userInfo:dic];
    self.scrollView.scrollEnabled = YES;
    
}

- (void)alertViewCancelled:(LGAlertView *)alertView {
    ScrollPagesViewController *scrollPagesController = (ScrollPagesViewController *)[self viewController];
    [scrollPagesController scrollToPage:DiscussViewControllerNmuber animation:YES];
    
    NSDictionary *dic = @{
                          @"index":[NSNumber numberWithInteger:DiscussViewControllerNmuber ]
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:ScrollNotification object:nil userInfo:dic];
    [self.scrollView setContentSize:CGSizeMake(SCREENWIDTH * self.viewControllers.count, SCREENHEIGHT - 20 - 44 - 49)];
    self.scrollView.scrollEnabled = YES;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
