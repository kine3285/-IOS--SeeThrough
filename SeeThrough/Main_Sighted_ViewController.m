//  Main_Sighted_ViewController.m
//  SeeThrough
//
//  Created by 윤성현 on 9/12/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import "Main_Sighted_ViewController.h"
#import "Sign-In_ViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface Main_Sighted_ViewController ()
@property NSDictionary *post;
@end

@implementation Main_Sighted_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _crownImage.hidden=YES;
    [self.imageButton.layer setCornerRadius:50];
    [self.imageButton.layer setMasksToBounds:YES];
    [self.imageButton.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    [self.imageButton.layer setBorderWidth:5];
    
    
    
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
        
        
        int cnt =[helpCnt intValue];
        NSString *num1 = @"신입 도우미";
        NSString *num2 = @"초보 도우미";
        NSString *num3 = @"숙련된 도우미";
        NSString *num4 = @"도움 전문가";
        NSString *master = @"최고 레벨을\n달성하셨습니다!";
        if(cnt < 10){
            [_helperLevel setText:[NSString stringWithFormat:@"%@",num1]];
            [_levelCntLabel setText:[NSString stringWithFormat:@"%d", 10-cnt]];
        } else if(cnt>=10 && cnt<20){
            [_helperLevel setText:[NSString stringWithFormat:@"%@",num2]];
            [_levelCntLabel setText:[NSString stringWithFormat:@"%d", 20-cnt]];
        } else if(cnt>=20 && cnt<40){
            [_helperLevel setText:[NSString stringWithFormat:@"%@",num3]];
            [_levelCntLabel setText:[NSString stringWithFormat:@"%d", 30-cnt]];
        } else if(cnt>=40){
            [_helperLevel setText:[NSString stringWithFormat:@"%@",num4]];
            _levelCntLabel.hidden=YES;
            [_lastlabel setText:[NSString stringWithFormat:@"%@",master]];

            _crownImage.hidden=NO;
            
        }
        
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

- (IBAction)imageButtonClick:(id)sender {
    UIActionSheet *myActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        myActionSheet = [[UIActionSheet alloc]initWithTitle:@"선택하세요" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:@"사진찍기" otherButtonTitles:@"사진첩에서 고르기", nil];
    }
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]&&[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        myActionSheet = [[UIActionSheet alloc]initWithTitle:@"선택하세요" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진첩에서 고르기", nil];
    }
    UIView *keyView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
    [myActionSheet showInView:keyView];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex  == [actionSheet cancelButtonIndex]){
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    [imagePickerController setDelegate:self];
    
    if(buttonIndex == [actionSheet destructiveButtonIndex]){
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else if (buttonIndex == [actionSheet firstOtherButtonIndex]){
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePickerController setAllowsEditing:YES];
    [self presentModalViewController:imagePickerController animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    UIImage *rectImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [_imageButton setImage:rectImage forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
}

@end
