//
//  SettingViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/16.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "SettingViewController.h"
#import "UIStoryboard+SAGetter.h"
#import "WebpageAdvancedViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UISwitch *switchSound;
@property (weak, nonatomic) IBOutlet UISwitch *switchVibration;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblVersion setText:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [_switchSound setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:@"SoundEnabled"] boolValue]];
    [_switchVibration setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:@"VibrationEnabled"] boolValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *strURL;
        NSString *strTitle;
        if (indexPath.row == 0) {
            strURL = @"http://api.tenfuncycle.com:8080/tfkz/static/modules/app/company.html";
            strTitle = @"关于天风客栈";
        } else if (indexPath.row == 1) {
            strURL = @"http://api.tenfuncycle.com:8080/tfkz/static/modules/app/score_rule.html";
            strTitle = @"积分规则说明";
        } else {
            return;
        }
        WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
        [viewController setSourceType:WebpageSourceTypeURL];
        [viewController setWebpageURL:[NSURL URLWithString:strURL]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)switchSoundValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@(sender.on) forKey:@"SoundEnabled"];
}

- (IBAction)switchVibrationValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@(sender.on) forKey:@"VibrationEnabled"];
}

@end
