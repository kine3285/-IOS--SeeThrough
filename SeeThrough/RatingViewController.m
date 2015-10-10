//
//  RatingViewController.m
//  SeeThrough
//
//  Created by 최민창 on 2015. 10. 1..
//  Copyright © 2015년 윤성현. All rights reserved.
//

#import "RatingViewController.h"

@interface RatingViewController (){
UISwipeGestureRecognizer *swipeLeftToRightGesture;
UISwipeGestureRecognizer *swipeRightToLeftGesture;
}
@property NSDictionary *post;
@end
//;ㅏㅓ;ㅣㅏㅓ
@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    swipeLeftToRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(swipedScreenRight:)];
    [swipeLeftToRightGesture setNumberOfTouchesRequired: 1];
    [swipeLeftToRightGesture setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer: swipeLeftToRightGesture];
    
    swipeRightToLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(swipedScreenLeft:)];
    [swipeRightToLeftGesture setNumberOfTouchesRequired: 1];
    [swipeRightToLeftGesture setDirection: UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer: swipeRightToLeftGesture];
    
}

- (void)swipedScreenRight:(UISwipeGestureRecognizer*)swipeGesture {
    //왼쪽에서 오른쪽으로 스와이프할떄 이벤트
    
    
    [self performSegueWithIdentifier:@"backMainBlindView" sender:self];
    
    // Move your image views as desired
}

- (void)swipedScreenLeft:(UISwipeGestureRecognizer*)swipeGesture1 {
    //오른쪽에서 왼쪽으로 스와이프할때 이벤트
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
