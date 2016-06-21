//
//  ChatViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/17.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "ChatViewController.h"
#import "LoginedUserHandler.h"

@interface ChatViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    NSString *visitorID = [LoginedUserHandler loginedUser].userObj.name;
    if (visitorID.length > 9) {
        visitorID = [visitorID substringFromIndex:visitorID.length - 9];
    }
    
    NSString *strURL = [NSString stringWithFormat:@"http://kefu.qycn.com/vclient/chat/?originPageUrl=http://www.96005656.com/kefu.html&websiteid=107603&visitorid=%@&originPageTitle=客服&m=m",visitorID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_webView loadRequest:request];
}
@end
