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


@end
