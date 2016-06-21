//
//  ScrollPagesViewController.m
//  wozaijinan
//
//  Created by 杜保全 on 15/1/7.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "ScrollPagesViewController.h"
#import "ScrollPagesView.h"
#import "CustomTabBarConreoller.h"
#import "HomeViewController.h"
#import "AnnounceViewController.h"
#import "DiscussViewController.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SelectNotification @"SelectNotification"

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

@interface ScrollPagesViewController ()
@property (nonatomic,strong) ScrollPagesView *scrollPagesView;

@end

@implementation ScrollPagesViewController

-(id)initWithViewControllers:(NSArray*)viewControllers atPage:(NSInteger)page{
    
    self  = [super init];
    if (self) {
        self.viewControllers = viewControllers;
        self.currentPage = page;
        [self receiveNotic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    for (UIViewController *viewCon in self.viewControllers) {
        [self addChildViewController:viewCon];
    }

    self.scrollPagesView = [[ScrollPagesView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) iewControllers:self.viewControllers atPage:self.currentPage];
    
    [self.view addSubview:self.scrollPagesView];
    [self scrollToPage:self.currentPage animation:YES];
    
    
    CustomTabBarConreoller *customTabbarController = (CustomTabBarConreoller*)self.navigationController.parentViewController;
    [self setTitle:[customTabbarController.titleArray firstObject]];
}
-(void)scrollToPage:(NSInteger)page animation:(BOOL)animation{
    HomeViewController *homeVC = self.viewControllers[0];
    AnnounceViewController *annVC = self.viewControllers[1];
    DiscussViewController *disVC = self.viewControllers[2];
    
    switch (page) {
        case HomeViewControllerNmuber:
            [self.navigationItem setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_titleLogo"]]];
            self.navigationItem.leftBarButtonItem = homeVC.leftBarButonItem;
            self.navigationItem.rightBarButtonItem = homeVC.rightBarBtttonItem;
            break;
        case AnnounceViewControllerNmuber:
            self.navigationItem.titleView = nil;
            self.navigationItem.rightBarButtonItem = annVC.rightBarButtonItem;
            self.navigationItem.leftBarButtonItem = nil;
            break;
        case DiscussViewControllerNmuber:
            self.navigationItem.titleView = nil;
            self.navigationItem.leftBarButtonItem = disVC.leftBarButtonItem;
            self.navigationItem.rightBarButtonItem = disVC.rightBarButtonItem;
            break;
        case ChatViewControllerNmuber:
            self.navigationItem.titleView = nil;
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
            break;
        case TaxViewControllerNmuber:
            self.navigationItem.titleView = nil;
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
            break;
        default:
            break;
    }
    
    
    [self.scrollPagesView.scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * page, 0, SCREENWIDTH, SCREENHEIGHT) animated:animation];
    self.scrollPagesView.currentContentOffsetX = self.scrollPagesView.scrollView.contentOffset.x;
}



#pragma mark  PushLifeViewControllerDelegate
-(void)pushLifeViewController:(UIViewController*)viewController{
    [self.navigationController  pushViewController:viewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)receiveNotic {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollAction:) name:SelectNotification object:nil];
}

- (void)scrollAction:(NSNotification *)notic {
    NSDictionary *userInfo = notic.userInfo;
    int page = [[userInfo objectForKey:@"index"] intValue];
    [self scrollToPage:page animation:YES];
    [self setTitle:[userInfo objectForKey:@"title"]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end