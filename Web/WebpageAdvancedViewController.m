//
//  WebpageAdvancedViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/28.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "WebpageAdvancedViewController.h"
#import "WebpageNativeObject.h"
#import "AppConfig.h"
#import "APIHandler.h"
#import "DetailOperationView.h"
#import "MWPhotoBrowser.h"
#import "LoginedUserHandler.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "ReportViewController.h"
#import "LoginViewController.h"
#import "UIStoryboard+SAGetter.h"
#import "LGAlertView.h"
#import "CommonFunction.h"
#import <MBProgressHUD.h>

@interface WebpageAdvancedViewController ()<UIWebViewDelegate,WebpageNativeObjectDelegate,MWPhotoBrowserDelegate,DetailOperationViewDelegate,UMSocialUIDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView; //主WebView
@property (weak, nonatomic) IBOutlet UIButton *btnNavRight; //导航栏右侧按钮
@property (weak, nonatomic) IBOutlet UIView *toolBarComment; //评论条
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottomSpace; //评论条距底部距离
@property (weak, nonatomic) IBOutlet UITextField *textFieldComment; //评论TextField
@property (weak, nonatomic) IBOutlet UIButton *btnComment; //评论按钮
@property (weak, nonatomic) IBOutlet UIButton *btnRetract; //收回键盘按钮
@property (strong, nonatomic) DetailOperationView *operationView; //顶部操作栏
@property (assign, nonatomic) BOOL isExpanded; //当前是否展开顶部操作栏
@property (strong, nonatomic) WebpageNativeObject *nativeObject; //Native对象
@property (strong, nonatomic) NSMutableArray *arrMWImage; //图片浏览大图数组
@property (strong, nonatomic) NSMutableArray *arrMWThumb; //图片浏览缩略图数组
@property (strong, nonatomic) NSString *replyTargetName; //回复目标用户昵称

@property (copy, nonatomic) NSString *contentStr;

@end

@implementation WebpageAdvancedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self loadWebView];
    [self registerKeyboardObserver];
}

- (void)registerKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)initViews {
    if (_webpageTitle && _webpageTitle.length > 0) {
        [self setTitle:_webpageTitle];
    } else {
        [self setTitle:@""];
    }
    
    [_btnComment.layer setCornerRadius:4];
    [_btnComment.layer setMasksToBounds:YES];
    [_toolBarComment.layer setBorderColor:[UIColor colorWithWhite:0.894 alpha:1.000].CGColor];
    [_toolBarComment.layer setBorderWidth:1 / [UIScreen mainScreen].scale];
    // 初始将所有操作的入口隐藏，待网页通过initData传回各项参数后，再根据参数的值判断各项操作的显示与隐藏
    [_toolBarComment setHidden:YES];
    [_toolBarBottomSpace setConstant:-44];
    [_btnNavRight setHidden:YES];
    [_btnRetract setHidden:YES];
    
    _operationView = [[DetailOperationView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    [_operationView setDelegate:self];
    [_operationView setHidden:NO];
    [_operationView setAlpha:0];
    [self.view addSubview:_operationView];
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - WebView
- (void)loadWebView {
    NSString *defaultHTML = @"<html><p align=\"center\">抱歉，暂无信息</p></html>";
    switch (_sourceType) {
        case WebpageSourceTypeID:
            if (_webpageID && _webpageID.length > 0) {
                NSString *strURL = [NSString stringWithFormat:@"%@/%@/%@",CONFIG_API_ROOT,API_ARTICLE_HTML,_webpageID];
                SALog(strURL);
                NSURL *url = [NSURL URLWithString:strURL];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [_webView loadRequest:request];
            } else {
                SALog(@"Webpage ID missing.");
                [_webView loadHTMLString:defaultHTML baseURL:nil];
            }
            break;
        case WebpageSourceTypeDiscussID:
            if (_webpageID && _webpageID.length > 0) {
                NSString *strURL = [NSString stringWithFormat:@"%@/%@/%@",CONFIG_API_ROOT,API_DISCUSS_HTML,_webpageID];
                SALog(strURL);
                NSURL *url = [NSURL URLWithString:strURL];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [_webView loadRequest:request];
            } else {
                SALog(@"Webpage ID missing.");
                [_webView loadHTMLString:defaultHTML baseURL:nil];
            }
            break;
        case WebpageSourceTypeVideoID:
            if (_webpageID && _webpageID.length > 0) {
                NSString *strURL = [NSString stringWithFormat:@"%@/%@/%@",CONFIG_API_ROOT,API_VIDEO_HTML,_webpageID];
                SALog(strURL);
                NSURL *url = [NSURL URLWithString:strURL];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [_webView loadRequest:request];
            } else {
                SALog(@"Webpage ID missing.");
                [_webView loadHTMLString:defaultHTML baseURL:nil];
            }
            break;
        case WebpageSourceTypeQuestionID:
            if (_webpageID && _webpageID.length > 0) {
                NSString *strURL = [NSString stringWithFormat:@"%@/%@/%@",CONFIG_API_ROOT,API_QUESTION_HTML,_webpageID];
                SALog(strURL);
                NSURL *url = [NSURL URLWithString:strURL];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [_webView loadRequest:request];
            } else {
                SALog(@"Webpage ID missing.");
                [_webView loadHTMLString:defaultHTML baseURL:nil];
            }
            break;
        case WebpageSourceTypeURL:
            if (_webpageURL && _webpageURL.absoluteString.length > 0) {
                NSURLRequest *request = [NSURLRequest requestWithURL:_webpageURL];
                [_webView loadRequest:request];
            } else {
                SALog(@"Webpage URL missing.");
                [_webView loadHTMLString:defaultHTML baseURL:nil];
            }
            break;
        default: {
            SALog(@"Webpage source type unknown.");
            [_webView loadHTMLString:defaultHTML baseURL:nil];
            break;
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // enable error logging
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"WEB JS: %@", value);
    }];
    _nativeObject = [[WebpageNativeObject alloc] init];
    _nativeObject.delegate = self;
    context[@"tfkznative"] = _nativeObject;
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (_webpageTitle && _webpageTitle.length > 0) {
        [self setTitle:_webpageTitle];
    } else {
        [self setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    }
}

#pragma mark - Native Object Delegate
- (void)showImageBrowser:(NSArray *)imagePath atIndex:(NSUInteger)index {
    if (!_arrMWImage || !_arrMWThumb) {
        [self generateMWArray:imagePath];
    }
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    photoBrowser.displayActionButton = YES;
    photoBrowser.displayNavArrows = NO;
    photoBrowser.displaySelectionButtons = NO;
    photoBrowser.alwaysShowControls = NO;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableGrid = NO;
    photoBrowser.startOnGrid = NO;
    photoBrowser.enableSwipeToDismiss = YES;
    photoBrowser.enableClickToDismissWhenModel = YES;
    [photoBrowser setCurrentPhotoIndex:index];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoBrowser];
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)configReceived {
    if (_nativeObject.shareEnabled || _nativeObject.favEnabled || _nativeObject.reportEnabled) {
        [_operationView reloadWithShareEnabled:_nativeObject.shareEnabled favEnabled:_nativeObject.favEnabled reportEnabled:_nativeObject.reportEnabled];
        [_btnNavRight setHidden:NO];
    } else {
        [_btnNavRight setHidden:YES];
    }
    if (_nativeObject.replyEnabled) {
        [_toolBarBottomSpace setConstant:0];
        [_toolBarComment setHidden:NO];
    } else {
        [_toolBarBottomSpace setConstant:-44];
        [_toolBarComment setHidden:YES];
    }
}

- (void)replyFloor:(NSString *)targetName {
    if (_nativeObject.replyEnabled) {
        [_textFieldComment becomeFirstResponder];
        _replyTargetName = targetName;
        [_textFieldComment setPlaceholder:[NSString stringWithFormat:@"@%@",targetName]];
    }
}

#pragma mark - Operation View Delegate
- (void)favClick {
    if ([LoginedUserHandler loginedUser].logined) {
        // 调用收藏的js方法
        NSString *jsMethod = [_nativeObject.favMethod stringByAppendingFormat:@"({\"memberId\":\"%@\",\"token\":\"%@\"});",[LoginedUserHandler loginedUser].userObj.objectID,[LoginedUserHandler loginedUser].userObj.token];
        [_webView stringByEvaluatingJavaScriptFromString:jsMethod];
    } else {
        // 未登录，跳转登录页面
        LoginViewController *viewController = [[UIStoryboard userLoginStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)reportClick {
    if ([LoginedUserHandler loginedUser].logined) {
        // 跳转到举报页面
        ReportViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportViewController"];
       
        viewController.webView = _webView;
        
        viewController.nativeObject = _nativeObject;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        // 未登录，跳转登录页面
        LoginViewController *viewController = [[UIStoryboard userLoginStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
}

- (void)shareClickWithPlatForm:(DetailOperationType)operationType {
    if (_nativeObject.shareImagePath && _nativeObject.shareImagePath.length > 0) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud show:YES];
        APIHandler *apiHandler = [[APIHandler alloc]init];
        
        [apiHandler downloadFileWithURL:[NSURL URLWithString:_nativeObject.shareImagePath] saveToDocumentFile:@"shareImage" success:^(id obj) {
            [hud hide:YES];
            NSString *strFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"shareImage"];
            UIImage *imgShare = [UIImage imageWithContentsOfFile:strFilePath];
            [self shareWithPlatform:operationType image:imgShare];
        } failed:^(id obj) {
            [hud hide:YES];
            [self shareWithPlatform:operationType image:[UIImage imageNamed:@"AppLogo"]];
        }];
    } else {
        [self shareWithPlatform:operationType image:[UIImage imageNamed:@"AppLogo"]];
    }
}

- (void)shareWithPlatform:(DetailOperationType)operationType image:(UIImage*)image {
    switch (operationType) {
        case DetailOperationTypeShareToWechatSession: {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = _nativeObject.shareUrl;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.title;
            [[UMSocialControllerService defaultControllerService] setShareText:_nativeObject.shareContent shareImage:image socialUIDelegate:self];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
        }
        case DetailOperationTypeShareToWechatTimeline: {
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = _nativeObject.shareUrl;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.title;
            [[UMSocialControllerService defaultControllerService] setShareText:_nativeObject.shareContent shareImage:image socialUIDelegate:self];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
        }
        case DetailOperationTypeShareToQQ: {
            [UMSocialData defaultData].extConfig.qqData.url = _nativeObject.shareUrl;
            [UMSocialData defaultData].extConfig.qqData.title = self.title;
            [[UMSocialControllerService defaultControllerService] setShareText:_nativeObject.shareContent shareImage:image socialUIDelegate:self];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
        }
        case DetailOperationTypeShareToQzone: {
            [UMSocialData defaultData].extConfig.qzoneData.url = _nativeObject.shareUrl;
            [UMSocialData defaultData].extConfig.qzoneData.title = self.title;
            [[UMSocialControllerService defaultControllerService] setShareText:_nativeObject.shareContent shareImage:image socialUIDelegate:self];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
        }
        case DetailOperationTypeShareToWeibo: {
            NSString *strContentWithLink = [_nativeObject.shareContent stringByAppendingFormat:@" %@",_nativeObject.shareUrl];
            [[UMSocialControllerService defaultControllerService] setShareText:strContentWithLink shareImage:image socialUIDelegate:self];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
        }
        case DetailOperationTypeShareToTencent: {
            NSString *strContentWithLink = [_nativeObject.shareContent stringByAppendingFormat:@" %@",_nativeObject.shareUrl];
            [[UMSocialControllerService defaultControllerService] setShareText:strContentWithLink shareImage:image socialUIDelegate:self];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
        }
        default:
            break;
    }
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    _isExpanded = NO;
    [_btnNavRight setTransform:CGAffineTransformMakeRotation(0)];
    [_operationView setAlpha:0];
    if ([LoginedUserHandler loginedUser].logined) {
        APIHandler *apiHandler = [[APIHandler alloc]init];
        [apiHandler getWithAPIName:API_SHARE_NOTIFY parameters:@{@"memberId":[LoginedUserHandler loginedUser].userObj.objectID, @"token":[LoginedUserHandler loginedUser].userObj.token} success:^(id obj) {} failed:^(id obj) {}];
    }
}

#pragma mark - MWPhotoBrowser
- (void)generateMWArray:(NSArray*)arrImagePath {
    _arrMWImage = [[NSMutableArray alloc]init];
    _arrMWThumb = [[NSMutableArray alloc]init];
    if (arrImagePath && arrImagePath.count > 0) {
        for (NSString *strItem in arrImagePath) {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:strItem]];
            [_arrMWImage addObject:photo];
            NSString *strThumbImg = [strItem stringByAppendingString:@"-thumb.jpg"];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:strThumbImg]];
            [_arrMWThumb addObject:photo];
        }
    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _arrMWImage.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _arrMWImage.count) {
        return [_arrMWImage objectAtIndex:index];
    } else {
        return nil;
    }
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _arrMWThumb.count) {
        return [_arrMWThumb objectAtIndex:index];
    } else {
        return nil;
    }
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    [_toolBarBottomSpace setConstant:keyboardRect.size.height];
    [_btnRetract setHidden:NO];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_toolBarBottomSpace setConstant:0];
    [_btnRetract setHidden:YES];
}

#pragma mark - Others
- (BOOL)checkLoginStatus {
    if (![LoginedUserHandler loginedUser].logined) {
        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:nil message:@"\n您尚未登录，还不能评论哦！马上登录吧！\n" buttonTitles:@[@"登录"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [CommonFunction setStyleOfLGAlertView:alertView];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            if (index == 0) {
                // 跳转入登录页面
                UIViewController *viewController = [[UIStoryboard userLoginStoryboard] instantiateInitialViewController];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }];
        [alertView showAnimated:YES completionHandler:nil];
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 未登录不允许评论
    return [self checkLoginStatus];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self btnCommentClick:nil];
    return YES;
}

- (IBAction)btnCommentClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self checkLoginStatus]) {
        // 未登录，不进行提交
        return;
    }
    if (_textFieldComment.text.length == 0) {
        // 未填写内容，不进行提交
        return;
    }
    if (_replyTargetName) {
        // 回复某条评论
        NSString *jsMethod = [_nativeObject.replyFloorMethod stringByAppendingFormat:@"({\"memberId\":\"%@\",\"nick\":\"%@\",\"commentContent\":\"%@\",\"token\":\"%@\"});",[LoginedUserHandler loginedUser].userObj.objectID, [LoginedUserHandler loginedUser].userObj.nickName, _textFieldComment.text,[LoginedUserHandler loginedUser].userObj.token];
        [_webView stringByEvaluatingJavaScriptFromString:jsMethod];
        [_textFieldComment setText:@""];
    } else {
        // 回复作者
        NSString *jsMethod = [_nativeObject.replyAuthorMethod stringByAppendingFormat:@"({\"memberId\":\"%@\",\"nick\":\"%@\",\"commentContent\":\"%@\",\"token\":\"%@\"});",[LoginedUserHandler loginedUser].userObj.objectID, [LoginedUserHandler loginedUser].userObj.nickName, _textFieldComment.text,[LoginedUserHandler loginedUser].userObj.token];
        [_webView stringByEvaluatingJavaScriptFromString:jsMethod];
        [_textFieldComment setText:@""];
        
        // 滚动到最底部
        CGPoint bottomOffset = CGPointMake(0, _webView.scrollView.contentSize.height - _webView.scrollView.bounds.size.height);
        [_webView.scrollView setContentOffset:bottomOffset animated:YES];
    }
}

- (IBAction)btnRetractClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [_textFieldComment setText:@""];
    _replyTargetName = nil;
    [_textFieldComment setPlaceholder:@""];
}

- (IBAction)btnNavRightClick:(UIButton *)sender {
    // 显示或隐藏顶部操作栏
    _isExpanded = !_isExpanded;
    if (_isExpanded) {
        [UIView animateWithDuration:0.3f animations:^{
            [_btnNavRight setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            [_operationView setAlpha:1];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [_btnNavRight setTransform:CGAffineTransformMakeRotation(0)];
            [_operationView setAlpha:0];
        }];
    }
}

- (IBAction)btnNavBackClick:(UIBarButtonItem *)sender {
    if (_webView.canGoBack) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
