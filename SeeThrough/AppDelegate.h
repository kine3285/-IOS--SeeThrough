//
//  AppDelegate.h
//  SeeThrough
//
//  Created by 윤성현 on 9/11/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFnetworking/AFNetworking.h>
#import "STconstants.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString* deviceTokens;
    NSString* Session;
    NSString* Token;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString *deviceTokens;
@property (nonatomic, retain) NSString *Session;
@property (nonatomic, retain) NSString *Token;
//edit by minchang

@end

