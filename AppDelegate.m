//
//  AppDelegate.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/17.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "AppDelegate.h"
#import "UIStoryboard+SAGetter.h"
#import "AppDelegate+DynamicMethod.h"
#import "AFNetworkActivityLogger.h"
#import "LoginedUserHandler.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "TaxViewController.h"
#import "MessageListViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "AppConfig.h"
#import "APService.h"
#import "MPAlertView.h"
#import "UIImage+DeviceSpecificMedia.h"
#import "APIHandler.h"
#import <EAIntroView.h>
#import <AudioToolbox/AudioToolbox.h>
#import "HomeViewController.h"
#import "AnnounceViewController.h"
#import "DiscussViewController.h"
#import "ChatViewController.h"
#import "TaxViewController.h"
#import "WebpageViewController.h"
#import "ScrollPagesViewController.h"
#import "CustomTabBarConreoller.h"
#import "BaseNavigationController.h"
#import <UIImageView+WebCache.h>


/// 隐藏导航栏返回按钮上的 Title
@implementation UINavigationItem (CustomBackButton)
-(UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
}
@end

@interface AppDelegate ()<UITabBarControllerDelegate,UIAlertViewDelegate,EAIntroDelegate>
@property (assign, nonatomic) SystemSoundID soundID; //收到推送时的系统声音ID
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 在Debug模式下，开启Log输出
#ifdef DEBUG
    [[AFNetworkActivityLogger sharedLogger] startLogging];
#endif
    [self initTabBarController];
    [self setNavigationBarStyle];
    [self initThirdPartyWithLaunchOptions:launchOptions];
    // 读取用户鉴权并自动登录，刷新用户信息
    if ([[LoginedUserHandler loginedUser] loadUserAuthInformation]) {
        [[LoginedUserHandler loginedUser] refreshUserInfoWithSuccess:^(id obj) {} failed:^(id obj) {}];
    };
    // 监听JPush自定义消息，监控单点登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveJPushMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // 判断显示引导页
    [self detectToShowIntroView];
    
    // 显示由服务端配置的启动页
    [self showStartUpImage];
    [self downloadStartupImage];
    
    // 初始化推送消息声音
    NSString *strSoundPath = [[NSBundle mainBundle] pathForResource:@"sms-received1" ofType:@"caf"];
    NSURL *urlSoundPath = [NSURL fileURLWithPath:strSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlSoundPath, &_soundID);
    
    return YES;
}

- (void)networkDidReceiveJPushMessage:(NSNotification *)notification {
    // 收到单点登录消息
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSData *dataJSON = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataJSON options:NSJSONReadingAllowFragments error:nil];
    if ([dict[@"retcode"] intValue] == -16) {
        NSArray *arrKick = dict[@"extra"];
        NSString *registrationID = [APService registrationID];
        for (NSString *strItem in arrKick) {
            if ([strItem isEqualToString:registrationID]) {
                [[LoginedUserHandler loginedUser] logout];
                UITabBarController *tabBarController = (UITabBarController*)self.window.rootViewController;
                [tabBarController setSelectedIndex:0];
                LoginViewController *viewController = [[UIStoryboard userLoginStoryboard] instantiateInitialViewController];
                [(UINavigationController *)tabBarController.selectedViewController popToRootViewControllerAnimated:NO];
                [(UINavigationController *)tabBarController.selectedViewController pushViewController:viewController animated:YES];
                [MPAlertView showAlertView:@"您的帐号在其他地方登录，您已被迫下线"];
                [self playSoundAndVibrate];
                return;
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 打开程序或从后台恢复到前台时，清空程序角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [APService resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - URL Handler
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([self handleURL:url]) {
        return YES;
    } else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([self handleURL:url]) {
        return YES;
    } else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}

- (BOOL)handleURL:(NSURL*)url {
    if ([url.scheme isEqualToString:@"tianfengkezhan"]) {
        NSString *urlContent = [url.absoluteString stringByReplacingCharactersInRange:NSMakeRange(0, (@"tianfengkezhan://").length) withString:@""];
        if ([urlContent isEqualToString:@"helpcenter"]) {
            //跳转到帮助中心
            [self jumpHelpCenter];
            return NO;
        }
        return YES;
    } else {
        return NO;
    }
}

- (void)jumpHelpCenter {
    CustomTabBarConreoller * customTabBar = (CustomTabBarConreoller *)self.window.rootViewController;
    BaseNavigationController *basicNaviga = customTabBar.childViewControllers[0];
    UIViewController *viewController = [[UIStoryboard helpCenterStoryboard] instantiateViewControllerWithIdentifier:@"HelpCenterViewController"];
    [basicNaviga popToRootViewControllerAnimated:NO];
    [basicNaviga pushViewController:viewController animated:NO];
}

#pragma mark - Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register remote notifications, error: %@",error);
}

- (void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification {
    //在通知栏里点击消息进入程序后，使通知栏里的消息消失
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //如果正在前台或者后台运行，那么此函数将被调用
    [APService handleRemoteNotification:userInfo];  //上报已接收
    [self receiveNotification:userInfo];
}

- (void)detectLaunchFromNotificationWithLaunchOptions:(NSDictionary *)launchOptions {
    //若由点击推送通知进入程序，则进行消息处理
    NSDictionary *remoteNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        [self receiveNotification:remoteNotification];
    }
}

- (void)receiveNotification:(NSDictionary*)userInfo {
    NSString *content = userInfo[@"aps"][@"alert"]; //消息内容
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"有新的消息" message:content delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
    [alert show];
    [self playSoundAndVibrate];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        MessageListViewController *viewController = [[UIStoryboard userCenterStoryboard] instantiateViewControllerWithIdentifier:@"MessageListViewController"];
        UITabBarController *tabBarController = (UITabBarController*)self.window.rootViewController;
        [(UINavigationController *)tabBarController.selectedViewController pushViewController:viewController animated:YES];
    }
}

- (void)playSoundAndVibrate {
    // 根据设置，播放声音和振动
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SoundEnabled"] boolValue]) {
        AudioServicesPlaySystemSound(_soundID);
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"VibrationEnabled"] boolValue]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark - Some initial functions
/// 设置导航栏样式
- (void)setNavigationBarStyle {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageForDeviceWithName:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setContentMode:UIViewContentModeScaleToFill];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 5, 0);
    UIImage *imgNavBack = [[[UIImage imageNamed:@"nav_btnBack"] imageWithAlignmentRectInsets:insets] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UINavigationBar appearance] setBackIndicatorImage:imgNavBack];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:imgNavBack];
    
    // 状态栏样式设置为白色字体
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

/// 构建TabBarController
- (void)initTabBarController {
    NSMutableArray *imageURLArray = [NSMutableArray array];
    NSMutableArray *titleArray = [NSMutableArray array];
    NSArray *arrData = [self getTabbarData];

    NSMutableArray *arrTabs = [[NSMutableArray alloc]init];
    NSMutableArray *arrInitialPara = [[NSMutableArray alloc]init]; //特定页面所必要的初始化参数
    for (NSDictionary *dictItem in arrData) {
        int type = [dictItem[@"type"] intValue];
        if (type == 0) {
            NSString *strCode = dictItem[@"code"];
            if ([strCode isEqualToString:@"sy"]) {
                [arrTabs addObject:[UIStoryboard homeStoryboard]];
            } else if ([strCode isEqualToString:@"tzgg"]) {
                [arrTabs addObject:[UIStoryboard announceStoryboard]];
                NSDictionary *dictPara = @{ @"index":@(arrTabs.count - 1),
                                            @"para":@{@"ifAnnounce":@YES, @"subjectTitle":dictItem[@"title"], @"ifHasAdvertisement":@YES} };
                [arrInitialPara addObject:dictPara];
            } else if ([strCode isEqualToString:@"jl"]) {
                [arrTabs addObject:[UIStoryboard discussStoryboard]];
            } else if ([strCode isEqualToString:@"zx"]) {
                [arrTabs addObject:[UIStoryboard chatStoryboard]];
            } else if ([strCode isEqualToString:@"bs"]) {
                [arrTabs addObject:[UIStoryboard taxStoryboard]];
            }
        } else if (type == 1) {
            [arrTabs addObject:[UIStoryboard webStoryboard]];
        }
        
//        tabBar item图片
        NSString *URLString = [dictItem objectForKey:@"imgUrl"];
        [imageURLArray addObject:URLString];
        
//        tabBar item标题
        NSString *title = [dictItem objectForKeyedSubscript:@"title"];
        [titleArray addObject:title];
    }
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (UIStoryboard *storyboard in arrTabs) {
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        [viewControllers addObject:viewController];
        if ([viewController isKindOfClass:[AnnounceViewController class]]) {
            for (NSDictionary *dictPara in arrInitialPara) {
                [viewController setValuesForKeysWithDictionary:dictPara[@"para"]];
            }
        }
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    ScrollPagesViewController *scrollVC = [[ScrollPagesViewController alloc] initWithViewControllers:viewControllers atPage:0];
    scrollVC.viewControllers = viewControllers;
    BaseNavigationController *navController = [[BaseNavigationController alloc]initWithRootViewController:scrollVC];
    CustomTabBarConreoller *cusTabBarC = [[CustomTabBarConreoller alloc] init];
    cusTabBarC.titleArray = titleArray;
    cusTabBarC.imageURLArray = imageURLArray;
    [cusTabBarC addChildViewController:navController];
    self.window.rootViewController = cusTabBarC;    
}

/// 初始化第三方组件
- (void)initThirdPartyWithLaunchOptions:(NSDictionary *)launchOptions {
    // UMeng Social
    [UMSocialData setAppKey:CONFIG_UMENG_APP_KEY];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession]];
    [UMSocialWechatHandler setWXAppId:CONFIG_WECHAT_APP_ID appSecret:CONFIG_WECHAT_APP_SECRET url:CONFIG_SHARE_URL];
    [UMSocialQQHandler setQQWithAppId:CONFIG_QQ_APP_ID appKey:CONFIG_QQ_APP_KEY url:CONFIG_SHARE_URL];
    [UMSocialQQHandler setSupportWebView:YES];
    
    // JPush
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    } else {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
}

#pragma mark - TabBarController Delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UINavigationController *navController = (UINavigationController*)viewController;
    UIViewController *rootViewController = [navController.viewControllers firstObject];
    // 点击了Tabbar的咨询或办税，判断是否登录
    if ([rootViewController isKindOfClass:[ChatViewController class]] || [rootViewController isKindOfClass:[TaxViewController class]]) {
        if ([LoginedUserHandler loginedUser].logined) {
            return YES;
        } else {
            // 未登录，禁止切换到个人中心，在首页跳转入登录页
            LoginViewController *viewController = [[UIStoryboard userLoginStoryboard] instantiateInitialViewController];
            [(UINavigationController *)tabBarController.selectedViewController pushViewController:viewController animated:YES];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 引导页
- (void)detectToShowIntroView {
    NSString *strDisplayed = [[NSUserDefaults standardUserDefaults]valueForKey:@"introDisplayed"];
    if (!(strDisplayed && [strDisplayed boolValue])) {
        NSMutableArray *arrImageName = [[NSMutableArray alloc]init];
        for (int i = 1; i <= 5; i ++) {
            NSString *imageName = [NSString stringWithFormat:@"introduce%d",i];
            [arrImageName addObject:imageName];
        }
        
        NSMutableArray *arrPage = [[NSMutableArray alloc]init];
        for (int i=0;i<arrImageName.count;i++) {
            UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageForDeviceWithName:arrImageName[i]]];
            [view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            EAIntroPage *page = [EAIntroPage pageWithCustomView:view];
            [arrPage addObject:page];
        }
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) andPages:arrPage];
        [intro setDelegate:self];
        [intro.pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:0.761 alpha:1.000]];
        [intro.pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithWhite:0.341 alpha:1.000]];
        [intro showInView:[UIApplication sharedApplication].delegate.window animateDuration:0.0];
    }
}

- (void)introDidFinish:(EAIntroView *)introView {
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"introDisplayed"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowGuideNotification" object:nil];
}

#pragma mark - 启动图片
- (void)downloadStartupImage {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    [apiHandler getWithAPIName:API_GET_LAUNCH_IMAGE parameters:nil success:^(NSDictionary *dictResponse) {
        NSLog(@"%@: %@",API_GET_LAUNCH_IMAGE,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            NSString *strImageURL = [dictResponse valueForKey:@"extra"];
            if (strImageURL && strImageURL.length > 0 && ([strImageURL hasPrefix:@"http://"] || [strImageURL hasPrefix:@"https://"])) {
                NSString *strFileName = [strImageURL lastPathComponent];
                [apiHandler downloadFileWithURL:[NSURL URLWithString:strImageURL] saveToDocumentFile:strFileName success:^(id obj) {
                    [[NSUserDefaults standardUserDefaults] setObject:strFileName forKey:@"startupimg"];
                } failed:^(id obj) {
                    // do nothing.
                }];
            }
        } else {
            // do nothing.
        }
    } failed:^(NSString *errorMessage) {
        // do nothing.
    }];
}

- (void)showStartUpImage {
    NSString *strStartUpFilename = [[NSUserDefaults standardUserDefaults]objectForKey:@"startupimg"];
    if (strStartUpFilename && strStartUpFilename.length > 0) {
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        NSString *strPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:strStartUpFilename];
        if ([fileManager fileExistsAtPath:strPath]) {
            UIImageView *imgViewStartUp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [imgViewStartUp setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:strPath]]];
            [self.window addSubview:imgViewStartUp];
            [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
                [imgViewStartUp setAlpha:0];
            } completion:^(BOOL finished) {
                [imgViewStartUp removeFromSuperview];
            }];
        }
    }
}
@end
