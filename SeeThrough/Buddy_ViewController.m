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
    mainArray = [[NSMutableArray alloc] initWithObjects: nil];
    
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
    cell.textLabel.text = [mainArray objectAtIndex:indexPath.row];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 여기서 항목 삭제
    NSString *delName = mainArray[[indexPath row]];
    [mainArray removeObject:delName];
    [self->tableView reloadData];
    UIAlertView *alertView;
    alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인",nil];
    [alertView setMessage:@"삭제하였습니다."];
    [alertView show];
    
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

//    NSLog(@"id: %@ , token:%@",user,token);
    
    [manager GET:server@"/add_friend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.post = (NSDictionary *)responseObject;
        
        NSString * addname=[NSString stringWithString:[_post objectForKey:@"friends"]];
        
        NSLog(@"friends: %@", addname);
    UIAlertView *alertView;
        
        if(![addname isEqualToString:@"fail"])
        {
            
    [mainArray addObject:addname];
    //    [self->tableView reloadData]; 그냥 새로고침
    //애니메이션 추가된 새로고침
    [tableView beginUpdates];
    [tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:YES];
    [tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:YES];
    [tableView endUpdates];
    
    //AlertView
    alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인",nil];
    [alertView setMessage:@"추가하였습니다."];
            
        }else{
    alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인",nil];
    [alertView setMessage:@"등록되지 않은 아이디 입니다."];
        }
    [alertView show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    
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
