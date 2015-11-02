//
//  Buddy_ViewController.h
//  SeeThrough
//
//  Created by 최민창 on 2015. 9. 22..
//  Copyright © 2015년 윤성현. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFnetworking/AFNetworking.h>
#import "STconstants.h"
@interface Buddy_ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    IBOutlet UITableView *tableView;
    
    __weak IBOutlet UITextField *textField;
    NSMutableArray *mainArray;
}
- (IBAction)addBtn:(id)sender;
-(IBAction)textFieldReturn:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *lastfriendLabel;


@end
