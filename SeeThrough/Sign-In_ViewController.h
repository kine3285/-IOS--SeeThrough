//
//  Sign-In_ViewController.h
//  SeeThrough
//
//  Created by 윤성현 on 9/12/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFnetworking/AFNetworking.h>
#import "STconstants.h"
@interface Sign_In_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *id_text;
@property (weak, nonatomic) IBOutlet UITextField *password_text;
@property (weak, nonatomic) IBOutlet UIView *signinView;
-(IBAction)textFieldReturn:(id)sender;

@end

