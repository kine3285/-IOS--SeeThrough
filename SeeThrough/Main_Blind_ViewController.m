//
//  Main_Blind_ViewController.m
//  SeeThrough
//
//  Created by 윤성현 on 9/12/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import "Main_Blind_ViewController.h"
#import "Sign-In_ViewController.h"
#import "opentok_ViewController.h"

@interface Main_Blind_ViewController ()

@end

@implementation Main_Blind_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"main-viewDidLoad");
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"main-viewDidAppear");
}
- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"main-in-viewDidDisappear");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)opentok:(id)sender {
    NSLog(@"move to opentok");
    [self performSegueWithIdentifier:@"opentok" sender:self];
}



- (IBAction)logout:(id)sender {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"id"];
        [defaults removeObjectForKey:@"pwd"];
        [defaults removeObjectForKey:@"role"];
        [defaults synchronize];
    
    [self performSegueWithIdentifier:@"logout_b" sender:self];

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
