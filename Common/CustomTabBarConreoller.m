//
//  CustomTabBarConreoller.m
//  Project1
//
//  Created by  on 15/9/23.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "CustomTabBarConreoller.h"
#import <UIImageView+WebCache.h>
#import "ScrollPagesViewController.h"
#import "LoginedUserHandler.h"
#import "LoginViewController.h"
#import "UIStoryboard+SAGetter.h"
#import "LGAlertView.h"
#import "CommonFunction.h"
#import "BaseNavigationController.h"


#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height
#define SelectNotification @"SelectNotification"
#define ScrollNotification @"ScrollNotification"
#define kBasicTag 100

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

@interface CustomTabBarConreoller ()<LGAlertViewDelegate>
{
    UIView *tabBarView;
    NSMutableArray *itemArray;
}
@end

@implementation CustomTabBarConreoller

- (void)viewDidLoad {
    [super viewDidLoad];
    itemArray = [NSMutableArray array];
    _lastIndex = 0;
    _currentIndex = 0;
    [self reciveNotic];

//     2.创建一个新的视图来放按钮
    tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 49)];
    tabBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_white"]];
    
    [self.tabBar addSubview:tabBarView];
    
}

- (void)reciveNotic {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changItem:) name:ScrollNotification object:nil];
}

- (void)changItem:(NSNotification *)notic {
    NSDictionary *dic = notic.userInfo;
    NSInteger index = [[dic objectForKey:@"index"] intValue];
    for (CustomTabItem *item in itemArray) {
        BOOL isScroll = (item.tag == index + kBasicTag);
        [item changImageAndTitle:isScroll];
    }
    
    self.currentIndex = index;
    
    UIViewController *scrollPagesViewController = ((UINavigationController*)[self.childViewControllers firstObject]).topViewController;
    [scrollPagesViewController setTitle:_titleArray[index]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self removeTabBarItem];
}

#pragma 移除按钮
-(void)removeTabBarItem{
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
}

//3.创建按钮
- (void)setImageURLArray:(NSMutableArray *)imageURLArray {
    _imageURLArray = imageURLArray;
    int count = (int)_imageURLArray.count;
    if (!_titleArray.count) {
        return;
    }
    
    for (int i = 0; i < count; i ++) {
        CustomTabItem *item = [[CustomTabItem alloc] initWithFrame:CGRectMake(i*kScreenW/count, 0, kScreenW/count, 49) URL:_imageURLArray[i] title:_titleArray[i]];
        item.index = i;
        if (i == 0) {
            item.selected = YES;
        }
        item.tag = i + kBasicTag;
        [itemArray addObject:item];
        [tabBarView addSubview:item];
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)itemAction:(CustomTabItem *)sender{
    if (self.lastIndex != _currentIndex) {
        _lastIndex = _currentIndex;
    }
    int selectIndex = (int)sender.index;
    
    NSNumber *selectNumber = [NSNumber numberWithInteger:selectIndex];
    NSDictionary *indexDic = @{
                               @"index":selectNumber,
                               @"title":sender.title
                               };
    
//    视图滑动通知
    if ([LoginedUserHandler loginedUser].logined) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SelectNotification object:sender userInfo:indexDic];
        for (CustomTabItem *item in itemArray) {
            BOOL isSelect = (item.tag == sender.tag);
            [item changImageAndTitle:isSelect];
        }
    }else {
        if (selectIndex == ChatViewControllerNmuber) {
            
            LGAlertView *alertView3 = [[LGAlertView alloc]initWithTitle:nil message:@"\n您尚未登录，暂不能进行此操作哦！马上登录吧！\n" buttonTitles:@[@"登录"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
            alertView3.delegate = self;
            [alertView3 showAnimated:YES completionHandler:nil];
            [CommonFunction setStyleOfLGAlertView:alertView3];
        }else if (selectIndex == TaxViewControllerNmuber) {
            
            LGAlertView *alertView4 = [[LGAlertView alloc]initWithTitle:nil message:@"\n您尚未登录，暂不能进行此操作哦！马上登录吧！\n" buttonTitles:@[@"登录"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
            alertView4.delegate = self;
            [alertView4 showAnimated:YES completionHandler:nil];
            [CommonFunction setStyleOfLGAlertView:alertView4];
        }else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SelectNotification object:sender userInfo:indexDic];
            for (CustomTabItem *item in itemArray) {
                BOOL isSelect = (item.tag == sender.tag);
                [item changImageAndTitle:isSelect];
            }
        }
    }
    
    _currentIndex = sender.tag - kBasicTag;
}

- (void)alertView:(LGAlertView *)alertView buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index {
    UINavigationController *naviga = [self.childViewControllers firstObject];
    ScrollPagesViewController *scrollPageVC = (ScrollPagesViewController *)naviga.topViewController;
    [scrollPageVC scrollToPage:_lastIndex animation:YES];
    _currentIndex = _lastIndex;
    
    LoginViewController *viewController = [[UIStoryboard userLoginStoryboard] instantiateInitialViewController];
    [naviga pushViewController:viewController animated:YES];

    _currentIndex = _lastIndex;
}

- (void)alertViewCancelled:(LGAlertView *)alertView {

    BaseNavigationController *naviga = [self.childViewControllers firstObject];
    ScrollPagesViewController *scrollPageVC = (ScrollPagesViewController *)[naviga.viewControllers objectAtIndex:0];
    [scrollPageVC scrollToPage:_lastIndex animation:YES];
    _currentIndex = _lastIndex;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma mark -
#pragma mark - CustomTabItem

@implementation CustomTabItem

-(id)initWithFrame:(CGRect)frame URL:(NSString *)URL title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        _URL = URL;
        _title = title;
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-10, 10, 20, 20)];
    imageView.tag = _index + 3*kBasicTag;
    
    if ([_URL hasPrefix:@"bundle://"]) {
        [imageView setImage:[UIImage imageNamed:[_URL substringFromIndex:9]]];

    }else {
#warning 应该使用后台配置图片
//            [imageView sd_setImageWithURL:[NSURL URLWithString:URL]];
        NSString *imageString = [NSString stringWithFormat:@"tabbar_item%ld",_index +1];
        if (_index == 0) {
            imageString = @"tabbar_item1_selected";
        }
        [imageView setImage:[UIImage imageNamed:imageString]];
    }

//防止图片拉伸
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 20)];
    lable.tag = _index + 2*kBasicTag;
    lable.text = _title;
    lable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lable];
    
    
    NSDictionary *titleAttribute = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithWhite:0.314 alpha:1.000], NSForegroundColorAttributeName,[UIFont systemFontOfSize:10], NSFontAttributeName, nil];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:_title attributes:titleAttribute];
    lable.attributedText = attString;
    [self addSubview:lable];
}

- (void)changImageAndTitle:(BOOL)isSelceted {
    self.selected = isSelceted;
    if (!self.isSelected) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)view;
                NSDictionary *titleAttribute = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithWhite:0.314 alpha:1.000], NSForegroundColorAttributeName,[UIFont systemFontOfSize:10], NSFontAttributeName, nil];
                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.title attributes:titleAttribute];
                label.attributedText = attString;
            }
            if ([view isKindOfClass:[UIImageView class]]) {
#warning 应该使用后台配置图片
                UIImageView *imageView = (UIImageView *)view;
                int idenx = (int)imageView.tag - 3*kBasicTag;
                NSString *imageString = [NSString stringWithFormat:@"tabbar_item%d",idenx +1];
                [imageView setImage:[UIImage imageNamed:imageString]];
            }
        }
    }else {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)view;
                NSDictionary *titleAttributeSelected = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:0.271 green:0.580 blue:0.145 alpha:1.000], NSForegroundColorAttributeName,[UIFont systemFontOfSize:10], NSFontAttributeName, nil];
                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.title attributes:titleAttributeSelected];
                label.attributedText = attString;
            }
            
            if ([view isKindOfClass:[UIImageView class]]) {
#warning 应该使用后台配置图片
                UIImageView *imageView = (UIImageView *)view;
                int idenx = (int)imageView.tag - 3*kBasicTag;
                NSString *imageString = [NSString stringWithFormat:@"tabbar_item%d_selected",idenx +1];
                [imageView setImage:[UIImage imageNamed:imageString]];
            }
        }
    }
}


@end



