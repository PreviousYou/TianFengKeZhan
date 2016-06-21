//
//  ReportViewController.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/8.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//



#import "BaseViewController.h"
#import "WebpageNativeObject.h"
#import "LoginedUserHandler.h"

typedef NS_ENUM(NSUInteger, viewBasicTagNumber) {

    UIImageViewBasicTagNumber = 100,
    
    UIButtonBasicTagNumber = 1000
    
};

@interface ReportViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong, nonatomic) UIWebView *webView;//主webView

@property (strong, nonatomic) WebpageNativeObject *nativeObject; //Native对象

- (IBAction)btnAction:(UIButton *)sender;

- (IBAction)submitBtnAction:(UIButton *)sender;

@end
