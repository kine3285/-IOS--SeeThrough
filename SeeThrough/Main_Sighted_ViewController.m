//  Main_Sighted_ViewController.m
//  SeeThrough
//
//  Created by 윤성현 on 9/12/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import "Main_Sighted_ViewController.h"
#import "Sign-In_ViewController.h"
#import "AppDelegate.h"
@interface Main_Sighted_ViewController ()

@end

@implementation Main_Sighted_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //deviceTokens에 저장된 디바이스토큰 땡겨오기
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *mApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *parameters = @{@"token": mApp.deviceTokens};
    NSLog(@"token:%@", mApp.deviceTokens);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"id"];
        [defaults removeObjectForKey:@"pwd"];
        [defaults removeObjectForKey:@"role"];
        [defaults synchronize];


    [self performSegueWithIdentifier:@"logout_s" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
