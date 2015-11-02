//
//  Main_Sighted_ViewController.h
//  SeeThrough
//
//  Created by 윤성현 on 9/12/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFnetworking/AFNetworking.h>
#import "STconstants.h"
@interface Main_Sighted_ViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *helpCntLabel;
@property (weak, nonatomic) IBOutlet UILabel *userid;
- (IBAction)imageButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UILabel *levelCntLabel;
@property (strong, nonatomic) IBOutlet UILabel *helperLevel;
@property (strong, nonatomic) IBOutlet UILabel *lastlabel;
@property (strong, nonatomic) IBOutlet UIImageView *crownImage;

@end
