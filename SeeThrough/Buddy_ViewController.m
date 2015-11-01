//
//  Buddy_ViewController.m
//  SeeThrough
//
//  Created by 최민창 on 2015. 9. 22..
//  Copyright © 2015년 윤성현. All rights reserved.
//

#import "Buddy_ViewController.h"

@interface Buddy_ViewController ()
@property NSDictionary *post;
@end

@implementation Buddy_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id":user};
    [manager GET:server@"/set_friend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.post = (NSDictionary *)responseObject;
        NSMutableArray *receiveArray = [_post objectForKey:@"friends"];
        if(receiveArray == NULL){
            NSLog(@"receiveArray is NULL");
        } else mainArray = receiveArray;
        for(int i=0; i<[mainArray count]; i++)
        {
            NSLog(@"%d : %@\n",i,[mainArray objectAtIndex:i]);
        }
        
            [self->tableView reloadData];
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [mainArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thisCell"];
    
//    UIImage *cellImage = [UIImage imageNamed:@"icon.png"];
//    cell.imageView.image = cellImage;
    
    UIFont *myFont = [UIFont fontWithName:@"Daum" size:20];
    cell.textLabel.font  = myFont;
    cell.textLabel.text = [mainArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 여기서 항목 삭제
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"id"];
    NSString *friend = mainArray[[indexPath row]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id":user,@"friend": friend};
    [manager GET:server@"/del_friend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.post = (NSDictionary *)responseObject;

        for(int i=0; i<[mainArray count]; i++)
        {
            NSLog(@"%d : %@\n",i,[mainArray objectAtIndex:i]);
        }
            mainArray = [_post objectForKey:@"friends"];
            [self->tableView reloadData];
            
            
            //AlertView
            UIAlertView *alertView;
            alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인",nil];
            [alertView setMessage:@"삭제하였습니다."];
            

            [alertView show];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);}];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (IBAction)addBtn:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"id"];
    NSString *friend = textField.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id":user,@"friend": friend};
    
    [manager GET:server@"/add_friend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.post = (NSDictionary *)responseObject;
        
        for(int i=0; i<[mainArray count]; i++)
        {
            NSLog(@"%d : %@\n",i,[mainArray objectAtIndex:i]);
        }
        
        mainArray = [_post objectForKey:@"friends"];

    UIAlertView *alertView;
//이미 있으면 0  없는 아이디면 1
        if([[mainArray objectAtIndex:0] isEqual:@"0"]){
            alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인",nil];
            [alertView setMessage:@"이미 등록된 친구입니다."];
            [alertView show];
        } else if([[mainArray objectAtIndex:0] isEqual:@"1"]){
            alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인",nil];
            [alertView setMessage:@"등록되지 않은 사용자 입니다."];
            [alertView show];
        } else
        {
            //애니메이션 추가된 새로고침
            [tableView beginUpdates];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:YES];
            [tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:YES];
            [tableView endUpdates];
            
            //AlertView
            alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인",nil];
            [alertView setMessage:@"추가하였습니다."];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    textField.text = @"";
    
}
//여백터치시 키보드 숨김
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//return키 누르면 키보드 숨김
-(IBAction)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
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
