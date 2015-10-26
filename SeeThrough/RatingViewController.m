//
//  RatingViewController.m
//  SeeThrough
//
//  Created by 최민창 on 2015. 10. 1..
//  Copyright © 2015년 윤성현. All rights reserved.
//

#import "RatingViewController.h"
#import "MBProgressHUD.h"
@interface RatingViewController (){
UISwipeGestureRecognizer *swipeLeftToRightGesture;
UISwipeGestureRecognizer *swipeRightToLeftGesture;
}
@property NSDictionary *post;
@property (weak, nonatomic) IBOutlet UILabel *message;
@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]];
}
- (IBAction)goToMain:(id)sender {
    [self performSegueWithIdentifier:@"backMainBlindView" sender:self];
}
- (IBAction)setBlock:(id)sender {
    //블랙리스트추가
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id":user};
    [manager GET:server@"/rating" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.post = (NSDictionary *)responseObject;
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);}];
    
    [self performSegueWithIdentifier:@"backMainBlindView" sender:self];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
