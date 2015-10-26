//
//  AppDelegate.m
//  SeeThrough
//
//  Created by 윤성현 on 9/11/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
@interface AppDelegate ()
@property NSDictionary *post;
@end

@implementation AppDelegate
@synthesize deviceTokens;
@synthesize Session;
@synthesize Token;
bool request=false;
bool isConnected=false;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#define iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? 1 : 0
    //APNS
    if (iOS8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    //실행시 뱃지 0개로 초기화
    application.applicationIconBadgeNumber = 0;
    return YES;
}

#pragma mark APPLE APNS
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"DevideToken (%@)", deviceToken);
    
    //디바이스토큰을 디비에 저장하기 위하여 데이터 타입에서 스트링으로 변환
    //[[NSString alloc]initWithData:newDeviceToken encoding:NSUTF8StringEncoding];
    deviceTokens = [[[[deviceToken description]
                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"[AppDelegate]deviceTokens : %@", deviceTokens);
    
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:deviceTokens forKey:@"token"];
                 [defaults synchronize];
    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if(error.code == 3010) {
        NSLog(@"Fail Regist to APNS by Simulator.");
        return;
    }
    
    NSLog(@"Error : Fail Regist to APNS. (%@)", error);
}

//푸쉬알림 눌렀을 때  ConnectView부르게 해야함
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userPushInfo {
    NSLog(@"didReceiveRemoteNotification");
    //push 데이터들 저장    blind_id , sessionid,token;
    NSString *blind_id= [NSString stringWithString:[userPushInfo objectForKey:@"id"]];
    Session=[NSString stringWithString:[userPushInfo objectForKey:@"sessionid"]];
    Token=[NSString stringWithString:[userPushInfo objectForKey:@"token"]];

    
//    NSLog(@"blind_id = %@\nsessionID=%@\ntoken=%@",blind_id,Session,Token);
    //push 요청수락
    
    request=TRUE;

//    NSLog(@"Is request? : %d", request);
    
   //연결여부 확인
    
    __block NSString *verify;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id":blind_id};
    
    [manager GET:server@"/status" parameters:parameters
     
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.post = (NSDictionary *)responseObject;
             
             verify=[NSString stringWithString:[_post objectForKey:@"verify"]];
             
//    NSLog(@"IsReply? : %@", verify);
             
             if([verify isEqualToString:@"true"])
             {
                 //이미 연결된 요청
                 isConnected=true;
                 
             }else{
                 //연결 작업 시작
                 isConnected=false;
             }
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    UIViewController *rootViewController;
    
    NSLog(@"request: %d, isConnected: %d",request,isConnected);
    
        if(request&&!isConnected)
        {
            //push 요청 수락시 연결 화면으로 이동
            NSLog(@"연결 시작 ");
            rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"opentokView"];
            //요청 여부 초기화 (다음 어플 실행시 메인화면 이동)
            request=false;
    
            self.window.rootViewController = rootViewController;
            [self.window makeKeyAndVisible];
    
        }else{
            rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainView_sighted"];
            //요청 여부 초기화 (다음 어플 실행시 메인화면 이동)
            request=false;
            NSLog(@"이미 연결된 요청 ");
    
            self.window.rootViewController = rootViewController;
    
            [self.window makeKeyAndVisible];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"이미 연결된 요청입니다."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show];
            
            //이미 연결된 연결 alert 후 메인 페이지 이동
        }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
}

//for auto login
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"willFinishLaunchingWithOptions");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *user = [defaults objectForKey:@"id"];
    NSString *role = [defaults objectForKey:@"role"];
    
    if(user!=nil)
    {
        NSLog(@"auto login success");
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        UIViewController *rootViewController;
    
        if([role isEqualToString:@"blind"])
        {
            rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainView_blind"];
            
        }else{
            rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainView_sighted"];
        }
        
        //요청 여부 초기화 (다음 어플 실행시 메인화면 이동)
        request=false;
        
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
        
    }else{
        NSLog(@"auto login fail");
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationDidEnterBackground");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.


    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"applicationWillTerminate");
}

@end
