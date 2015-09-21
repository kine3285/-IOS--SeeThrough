//
//  opentok_ViewController.m
//  SeeThrough
//
//  Created by 윤성현 on 9/12/15.
//  Copyright (c) 2015 윤성현. All rights reserved.
//

#import "opentok_ViewController.h"
#import <OpenTok/OpenTok.h>
#import <UIKit/UIKit.h>

@interface opentok_ViewController ()
<OTSessionDelegate,OTSubscriberKitDelegate,OTPublisherDelegate>
@property NSDictionary *post;

@end

@implementation opentok_ViewController
{
    
    OTSession* _session;
    OTPublisher* _publisher;
    OTSubscriber* _subscriber;
    
}

static bool subscribeToSelf = NO;

//ROLE
static   bool sighted =NO;
static NSString* role  ;

// Replace with your OpenTok API key
static NSString* const kApiKey = @"45339322";

// Replace with your generated session ID
 static NSString*  kSessionId ;
// Replace with your generated token


static NSString*  kToken ;

- (IBAction)quit:(UITapGestureRecognizer*)recognizer {
    
    [self disconnect];
    
}
- (IBAction)changeCameraPosition:(UITapGestureRecognizer*)recognizer {
    
    if(_publisher.cameraPosition==AVCaptureDevicePositionFront)
        _publisher.cameraPosition = AVCaptureDevicePositionBack;
    else
        _publisher.cameraPosition = AVCaptureDevicePositionFront;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"opentok-viewDidLoad");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *user = [defaults objectForKey:@"id"];
    
    role = [NSString stringWithString:[defaults objectForKey:@"role"]];
    
//    role = [NSString stringWithString:@"sighted"];
    
   if([role isEqualToString:@"blind"])
   {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id":user};
    
    [manager GET:@"http://192.168.0.35:3000/help" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.post = (NSDictionary *)responseObject;
             
             kToken=[NSString stringWithString:[_post objectForKey:@"token"]];
             kSessionId=[NSString stringWithString:[_post objectForKey:@"session"]];
             
             NSLog(@"role:%@ \nkToken: %@\nkSessionID: %@",role,kToken,kSessionId);
             
    _session = [[OTSession alloc] initWithApiKey:kApiKey
                                       sessionId:kSessionId
                                        delegate:self];
    
    [self doConnect];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
   }else{
       
       //receive sessionID & Token from push
       
    [self doConnect];
   }
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"opentok-viewDidAppear");
}
//- (void)viewDidDisappear:(BOOL)animated {
//    NSLog(@"opentok-viewDidDisappear");
//}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - OpenTok methods

/**
 * Asynchronously begins the session connect process. Some time later, we will
 * expect a delegate method to call us back with the results of this action.
 */

- (void)doConnect
{
    OTError *error = nil;
    
    [_session connectWithToken:kToken error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

/**
 * Sets up an instance of OTPublisher to use with this session. OTPubilsher
 * binds to the device camera and microphone, and will provide A/V streams
 * to the OpenTok session.
 */
- (void)doPublish
{
    
    _publisher =
    [[OTPublisher alloc] initWithDelegate:self name:role];
    
    _publisher.cameraPosition = AVCaptureDevicePositionBack;
    
    
    if(sighted)
        _publisher.publishVideo=NO;
    
    
    OTError *error = nil;
    [_session publish:_publisher error:&error];
    
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
    
    
}

/**
 * Cleans up the publisher and its view. At this point, the publisher should not
 * be attached to the session any more.
 */
- (void)cleanupPublisher {
    [_publisher.view removeFromSuperview];
    _publisher = nil;
    // this is a good place to notify the end-user that publishing has stopped.
}

/**
 * Instantiates a subscriber for the given stream and asynchronously begins the
 * process to begin receiving A/V content for this stream. Unlike doPublish,
 * this method does not add the subscriber to the view hierarchy. Instead, we
 * add the subscriber only after it has connected and begins receiving data.
 */
- (void)doSubscribe:(OTStream*)stream
{
    _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
    
    NSLog(@"구독 시작 ");
    
    
    
    OTError *error = nil;
    [_session subscribe:_subscriber error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
    
    NSLog(@"name is (%@)", stream.name);
}

/**
 * Cleans the subscriber from the view hierarchy, if any.
 * NB: You do *not* have to call unsubscribe in your controller in response to
 * a streamDestroyed event. Any subscribers (or the publisher) for a stream will
 * be automatically removed from the session during cleanup of the stream.
 */
- (void)cleanupSubscriber
{
    [_subscriber.view removeFromSuperview];
    _subscriber = nil;
}

-(void)disconnect
{
    OTError* err =nil;
    [_session disconnect:&err];
    if(err){
        NSLog(@"disconnect failed with error: (%@)",err);
    }
    
}
# pragma mark - OTSession delegate callbacks

- (void)sessionDidConnect:(OTSession*)session
{
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    
    // Step 2: We have successfully connected, now instantiate a publisher and
    // begin pushing A/V streams into OpenTok.
    [self doPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage =
    [NSString stringWithFormat:@"Session disconnected: (%@)",
     session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
}


- (void)session:(OTSession*)mySession
  streamCreated:(OTStream *)stream
{
    NSLog(@"session streamCreated (%@)", stream.streamId);
    
    // Step 3a: (if NO == subscribeToSelf): Begin subscribing to a stream we
    // have seen on the OpenTok session.
    if (nil == _subscriber && !subscribeToSelf)
    {
        [self doSubscribe:stream];
    }
}

- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
    NSLog(@"session streamDestroyed (%@)", stream.streamId);
    
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
    }
}

- (void)  session:(OTSession *)session
connectionCreated:(OTConnection *)connection
{
    NSLog(@"session connectionCreated (%@)", connection.connectionId);
}

- (void)    session:(OTSession *)session
connectionDestroyed:(OTConnection *)connection
{
    NSLog(@"session connectionDestroyed (%@)", connection.connectionId);
    if ([_subscriber.stream.connection.connectionId
         isEqualToString:connection.connectionId])
    {
        [self cleanupSubscriber];
    }
    
    OTError* err =nil;
    [_session unpublish:_publisher error:&err];
    if(err){
        NSLog(@"publishing failed with error: (%@)",err);
    }
    
}

- (void) session:(OTSession*)session
didFailWithError:(OTError*)error
{
    NSLog(@"didFailWithError: (%@)", error);
}

# pragma mark - OTSubscriber delegate callbacks

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)",
          subscriber.stream.connection.connectionId);
    assert(_subscriber == subscriber);
    
    if(sighted)
    {
        [_subscriber.view setFrame:CGRectMake(0, 0,  [[UIScreen mainScreen] applicationFrame].size.width,
                                              [[UIScreen mainScreen] applicationFrame].size.height)];
        [self.view addSubview:_subscriber.view];
    }else
    {
        [self.view addSubview:_publisher.view];
        [_publisher.view setFrame:CGRectMake(0, 0,  [[UIScreen mainScreen] applicationFrame].size.width,
                                             [[UIScreen mainScreen] applicationFrame].size.height)];
    }
}

- (void)subscriber:(OTSubscriberKit*)subscriber
  didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@",
          subscriber.stream.streamId,
          error);
}

# pragma mark - OTPublisher delegate callbacks

- (void)publisher:(OTPublisherKit *)publisher
    streamCreated:(OTStream *)stream
{
    // Step 3b: (if YES == subscribeToSelf): Our own publisher is now visible to
    // all participants in the OpenTok session. We will attempt to subscribe to
    // our own stream. Expect to see a slight delay in the subscriber video and
    // an echo of the audio coming from the device microphone.
    if (nil == _subscriber && subscribeToSelf)
    {
        [self doSubscribe:stream];
    }
}

- (void)publisher:(OTPublisherKit*)publisher
  streamDestroyed:(OTStream *)stream
{
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
    }
    
    [self cleanupPublisher];
    
    [self performSegueWithIdentifier:@"rate" sender:self];
}

- (void)publisher:(OTPublisherKit*)publisher
 didFailWithError:(OTError*) error
{
    NSLog(@"publisher didFailWithError %@", error);
    [self cleanupPublisher];
}

- (void)showAlert:(NSString *)string
{
    // show alertview on main UI
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OTError"
                                                        message:string
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show];
    });
}
@end
