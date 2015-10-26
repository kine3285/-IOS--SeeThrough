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
@property NSDictionary *post;
@end

@implementation Main_Sighted_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]];
    // Do any additional setup after loading the view.
    //deviceTokens에 저장된 디바이스토큰 땡겨오기
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"id"];
    NSString *token = [defaults objectForKey:@"token"];
    
    _userid.text = user;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id":user,@"token": token};
    NSLog(@"id: %@ , token:%@",user,token);
    
    [manager GET:server@"/token_update" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        self.post = (NSDictionary *)responseObject;
        NSString *helpCnt = [_post objectForKey:@"helpcnt"];
        NSLog(@"helpCount is %@", helpCnt);
        [_helpCntLabel setText:[NSString stringWithFormat:@"%@",helpCnt]];
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
-(IBAction)unwindToMainView:(UIStoryboardSegue*)unwindSegue
{
    
    NSLog(@"unwind segue");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"id"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id":user};
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults removeObjectForKey:@"id"];
    //    [defaults synchronize];
    [manager GET:server@"/cnt_update" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.post = (NSDictionary *)responseObject;
        NSString *helpCnt = [_post objectForKey:@"helpcnt"];
        NSLog(@"helpCount is %@", helpCnt);
        [_helpCntLabel setText:[NSString stringWithFormat:@"%@",helpCnt]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
