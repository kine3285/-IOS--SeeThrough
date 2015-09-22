//
//  Sign-In_ViewController.m
//  SeeThrough
//
//  Created by 윤성현 on 9/12/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import "Sign-In_ViewController.h"

@interface Sign_In_ViewController ()
@property NSDictionary *post;
@end

@implementation Sign_In_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"sign-in-viewDidLoad");
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"sign-in-viewDidAppear");
}
- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"sign-in-viewDidDisappear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id": _id_text.text,@"pwd": _password_text.text};
    __block NSString* verify=NULL;
    __block NSString* role;
    

    [manager GET:server@"/sign-In" parameters:parameters

         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.post = (NSDictionary *)responseObject;
             
             verify=[NSString stringWithString:[_post objectForKey:@"verify"]];
             
             if([verify isEqualToString:@"success"])
             {
                 //login & move to main View
                 NSLog(@"login & move to main View");
                 role=[NSString stringWithString:[_post objectForKey:@"role"]];
                 
                 //for auto login
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:_id_text.text forKey:@"id"];
                 [defaults setObject:_password_text.text forKey:@"pwd"];
                 [defaults setObject:role forKey:@"role"];
                 
                 [defaults synchronize];
                 
                 if([role isEqualToString:@"sighted"])
                     [self performSegueWithIdentifier:@"main_sighted" sender:self];
                 else
                     [self performSegueWithIdentifier:@"main_blind" sender:self];
                 
                 
             }else{
                 //alert login fail message
                 NSLog(@"alert login fail message");
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
    
    
    
}

-(IBAction)unwindToSignInView:(UIStoryboardSegue*)unwindSegue
{
    
    NSLog(@"unwind segue");
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:@"id"];
//    [defaults synchronize];
    
    
}

@end
