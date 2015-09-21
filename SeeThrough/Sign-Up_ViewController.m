//
//  Sign-Up_ViewController.m
//  SeeThrough
//
//  Created by 윤성현 on 9/12/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import "Sign-Up_ViewController.h"

@interface Sign_Up_ViewController ()
@property NSDictionary *post;
@end

@implementation Sign_Up_ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"sign-up-viewDidLoad");
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"sign-up-viewDidAppear");
}
- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"sign-up-viewDidDisappear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sign_up:(id)sender {
    
    NSString* email = _id_text.text;
    NSString* password = _password_text.text;
    NSString* pwd_verify = _password_re_text.text;
    NSString* title = (NSMutableString*)[_role_segCntrl titleForSegmentAtIndex:[_role_segCntrl selectedSegmentIndex]];
    
    NSString* role;
    
    if([title isEqualToString:@"도우미"])
       role= @"sighted";
    else
       role= @"blind";
        
    
    __block NSString* verify;
    if(![password isEqualToString:pwd_verify])
    {
        //alert password is not Equal to passwor_verify
       NSLog(@" password is not Equal to passwor_verify");
    }else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameters = @{@"id": email,@"pwd": password,@"role":role};
        
        [manager GET:@"http://192.168.0.35:3000/sign-Up" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.post = (NSDictionary *)responseObject;
            
            verify=[NSString stringWithString:[_post objectForKey:@"verify"]];
            
            NSLog(@"verify: %@", verify);
            
           if([verify isEqualToString:@"success"])
           {
               //alert signup success & move to main View
                NSLog(@"signup success & move to main View");
               
                 //for auto login
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:_id_text.text forKey:@"id"];
                 [defaults setObject:_password_text.text forKey:@"pwd"];
                 [defaults setObject:role forKey:@"role"];
                 [defaults synchronize];
               
               if([role isEqualToString:@"sighted"])
                   [self performSegueWithIdentifier:@"_main_sighted" sender:self];
               else
                   [self performSegueWithIdentifier:@"_main_blind" sender:self];
        
               
           }else{
               
               //alert ID is already exist
                 NSLog(@" ID is already exist");
           }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
            
    
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