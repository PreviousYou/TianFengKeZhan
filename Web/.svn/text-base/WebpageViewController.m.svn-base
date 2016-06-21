//
//  WebpageViewController.m
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/24.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "WebpageViewController.h"
#import "AppConfig.h"
#import "APIHandler.h"

@interface WebpageViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *defaultHTML = @"<html><p align=\"center\">抱歉，暂无信息</p></html>";
    
    if (_webpageTitle && _webpageTitle.length > 0) {
        [self setTitle:_webpageTitle];
    } else {
        [self setTitle:@"详情"];
    }

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
