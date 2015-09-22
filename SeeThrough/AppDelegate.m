//
//  AppDelegate.m
//  SeeThrough
//
//  Created by 윤성현 on 9/11/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize deviceTokens;
@synthesize Session;
@synthesize Token;

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
    // 取得エラーの原因がシミュレーターによるものだった場合なにもしない
    if(error.code == 3010) {
        NSLog(@"Fail Regist to APNS by Simulator.");
        return;
    }
    
    NSLog(@"Error : Fail Regist to APNS. (%@)", error);
}

//푸쉬알림 눌렀을 때  ConnectView부르게 해야함
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userPushInfo {
    NSString  *acme1 = [userPushInfo objectForKey:@"message"];
    NSLog(@"userPushInfo : %@", userPushInfo);
    NSLog(@"string : %@", acme1);
    NSDictionary *acme = [userPushInfo valueForKey:@"message"];
    NSLog(@"string1 : %@", acme);
    
}

//for auto login
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"applicationWillTerminate");
}

@end
