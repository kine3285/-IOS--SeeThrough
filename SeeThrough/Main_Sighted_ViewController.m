//  Main_Sighted_ViewController.m
//  SeeThrough
//
//  Created by 윤성현 on 9/12/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import "Main_Sighted_ViewController.h"
#import "Sign-In_ViewController.h"
@interface Main_Sighted_ViewController ()

@end

@implementation Main_Sighted_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *user = [defaults objectForKey:@"id"];
    NSString *token = @"test";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id":user,@"token": token};
    
    [manager GET:@"http://192.168.0.35:3000/token_updatae" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
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
