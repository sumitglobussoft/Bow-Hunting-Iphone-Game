//
//  RootViewController.m
//  BowHunting
//
//  Created by Sumit Ghosh on 01/04/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "SBJson.h"

#import "UIImageView+WebCache.h"
#define ReceiveNotification @"REceiveNotification"
#define RequestTOFacebook @"LifeRequest"



@interface RootViewController ()
@property (nonatomic, strong) NSNotification *currentNotification;
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    
    self = [super init];
    if (self) {
        
        userDefault = [NSUserDefaults standardUserDefaults];
        addNewLifeCheck=NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNotification:) name:FacebookRequestNotification object:nil];
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self prefersStatusBarHidden];
}

-(BOOL) prefersStatusBarHidden
{
    return YES;
}
#pragma mark -
-(void) checkNotification:(NSNotification *)notification{
    
    [self handleUrlRequest:notification];
}

-(void) handleUrlRequest:(NSNotification *)deepLinkNotification{

    NSURL *targetURL = deepLinkNotification.object;
//    NSLog(@"Target URL == %@",targetURL);
    
    NSString *strUrl  = [NSString stringWithFormat:@"%@",targetURL];
    NSLog(@"Target URL == %@",strUrl);
    NSString *strCheckTargetUrl = [userDefault objectForKey:@"targetUrl"];
    
    if (!strCheckTargetUrl) {
        
        addNewLifeCheck=YES;
        [userDefault setObject:strUrl forKey:@"targetUrl"];
        [userDefault synchronize];
    }
    else if (![strUrl isEqualToString:strCheckTargetUrl]){
      
        addNewLifeCheck=YES;
        [userDefault setObject:strUrl forKey:@"targetUrl"];
        [userDefault synchronize];
    }
   
    NSRange range = [targetURL.query rangeOfString:@"notif" options:NSCaseInsensitiveSearch];
    
    // If the url's query contains 'notif', we know it's coming from a notification - let's process it
    if(targetURL.query && range.location != NSNotFound)
    {
        // Yes the incoming URL was a notification
        // ProcessIncomingRequest(targetURL, callback);
        [self processRequest:targetURL];
    }
}

-(void) processRequest:(NSURL *)targetURL{
    // Extract the notification id
    
    
    
    NSArray *pairs = [targetURL.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [queryParams setObject:val forKey:[kv objectAtIndex:0]];
    }
    
    NSString *requestIDsString = [queryParams objectForKey:@"request_ids"];
    NSArray *requestIDs = [requestIDsString componentsSeparatedByString:@","];
    self.requestIDsAry=[NSArray arrayWithArray:requestIDs];
    self.count=self.requestIDsAry.count-1;
   NSString *requestID1= [self.requestIDsAry lastObject];
    [self checkRequestWithID:requestID1];
    
    [queryParams release];
}
    
-(void) checkRequestWithID:(NSString *)requestID
{
   
    FBRequest *req = [[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:requestID];
    [req startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        NSLog(@"Result== %@",result);
        NSLog(@"errror == %@",error);
        if (!error)
        {
            [self lifeRequestUI:result];
            
            
           // [self deleteFBRequest: [requestIDs lastObject]];
        }
        else{
            
            NSLog(@"Error == %@",error.localizedDescription);
            if (self.count>0) {
                self.count = self.count - 1;
                NSString *curReqID = [NSString stringWithFormat:@"%@",[self.requestIDsAry objectAtIndex:self.count]];
                [self checkRequestWithID:curReqID];
            }
            else{
                return;
            }
        }
    }];
    
//    [FBRequestConnection startWithGraphPath:[requestIDs lastObject] parameters:dict HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
//        //NSLog(@"Result== %@",result);
//        //NSLog(@"errror == %@",error);
//        if (!error)
//        {
//            [self lifeRequestUI:result];
//            
////            [self deleteFBRequest: [requestIDs objectAtIndex:0]];
//           [self deleteFBRequest: [requestIDs lastObject]];
//        }
//        else{
////            [self deleteFBRequest: [requestIDs objectAtIndex:0]];
//            [self deleteFBRequest: [requestIDs lastObject]];
//            NSLog(@"Error == %@",error.localizedDescription);
//        }
//    }];
}
-(void)lifeRequestUI :(id)result {
    
    if ([result objectForKey:@"from"])
    {
        NSString *from = [[result objectForKey:@"from"] objectForKey:@"name"];
        self.senderName = from;
        self.strSenderFbId = [[result objectForKey:@"from"] objectForKey:@"id"];
        NSString *toName = [[result objectForKey:@"to"] objectForKey:@"name"];
        self.currentUserName = toName;
        
        // NSLog(@"From == %@",from);
        // NSLog(@"aaa--- %@",self.strSenderFbId);
        //callback(from, id);
        
        NSString *mes = [result objectForKey:@"message"];
        // NSLog(@"Message == %@",mes);
        
        if ([mes isEqualToString:@"sending life request" ]) {
            //[[[UIAlertView alloc] initWithTitle:from message:@"Send Request for Life" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
            customView = [[[UIView alloc]initWithFrame:CGRectMake(60, 30, 400, 250)] autorelease];
            customView.layer.cornerRadius=10.0;
            customView.layer.borderWidth=3.0f;
            
            rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
            
            UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 400, 250)] autorelease];
            backImage.image=[UIImage imageNamed:@"tablebg.png"];
            [customView addSubview:backImage];
            
            [rootViewController.view addSubview:customView];
            
            UILabel *lblReqHeading = [[[UILabel alloc]initWithFrame:CGRectMake(150, 30, 200, 50)] autorelease];
            lblReqHeading.textAlignment=NSTextAlignmentCenter;
            lblReqHeading.font=[UIFont boldSystemFontOfSize:25];
            lblReqHeading.text=[NSString stringWithFormat:@"%@",from];
            [customView addSubview:lblReqHeading];
            
            UILabel *lblReq = [[[UILabel alloc]initWithFrame:CGRectMake(155, 80, 250, 80)] autorelease];
            lblReq.textAlignment=NSTextAlignmentLeft;
            lblReq.lineBreakMode=2;
            lblReq.numberOfLines=0;
            lblReq.font=[UIFont systemFontOfSize:17];
            lblReq.text=[NSString stringWithFormat:@"Request you for life"];
            [lblReq sizeToFit];
            [customView addSubview:lblReq];
            
            NSString *ImageURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",self.strSenderFbId];
            //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
            
            UIImageView *imageV = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 120, 120)] autorelease];
            //imageV.image=[UIImage imageWithData:imageData];
            [imageV setImageWithURL:[NSURL URLWithString:ImageURL] placeholderImage:[UIImage imageNamed:@"Icon.png"]];
            [customView addSubview:imageV];
            
            UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btnSend.frame=CGRectMake(80, 170, 100, 60);
            [btnSend setBackgroundImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
            [btnSend addTarget:self action:@selector(btnSendAction:) forControlEvents:UIControlEventTouchUpInside];
            [customView addSubview:btnSend];
            
            UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btnCancel.frame=CGRectMake(220, 170, 100, 60);
            [btnCancel setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
            [btnCancel addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
            [customView addSubview:btnCancel];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:1.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            [UIView commitAnimations];
        }
        
        else if ([mes isEqualToString:@"sending extra life"]) {
            
            //if (addNewLifeCheck) {
            //NSLog(@"Got Life");
            
            [self lifeAcceptUI];
            //}
            // NSLog(@"Life already added");
        }
        else if([mes isEqualToString:@"Invite Friends"]){
            NSLog(@"Invititaion");
        }
        else{
            NSLog(@"Error");
        }
    }
}
-(void)lifeAcceptUI{
    customView = [[UIView alloc]initWithFrame:CGRectMake(60, 30, 400, 250)];
    customView.layer.cornerRadius=10.0;
    customView.layer.borderWidth=3.0f;
    
    rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
    
    UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 400, 250)] autorelease];
    backImage.image=[UIImage imageNamed:@"tablebg.png"];
    [customView addSubview:backImage];
    
    [rootViewController.view addSubview:customView];
    
    UILabel *lblReqHeading = [[[UILabel alloc]initWithFrame:CGRectMake(150, 30, 200, 50)] autorelease];
    lblReqHeading.textAlignment=NSTextAlignmentCenter;
    lblReqHeading.font=[UIFont boldSystemFontOfSize:25];
    lblReqHeading.text=[NSString stringWithFormat:@"%@",self.senderName];
    [customView addSubview:lblReqHeading];
    
    UILabel *lblReq = [[[UILabel alloc]initWithFrame:CGRectMake(155, 80, 250, 80)] autorelease];
    lblReq.textAlignment=NSTextAlignmentLeft;
    lblReq.lineBreakMode=2;
    lblReq.numberOfLines=0;
    lblReq.font=[UIFont systemFontOfSize:15];
    lblReq.text=[NSString stringWithFormat:@"Sent you extra life"];
    [customView addSubview:lblReq];
    
    NSString *ImageURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",self.strSenderFbId];
   // NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    
    UIImageView *imageV = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 120, 120)] autorelease];
    [imageV setImageWithURL:[NSURL URLWithString:ImageURL] placeholderImage:[UIImage imageNamed:@"Icon.png"]];    [customView addSubview:imageV];
    UIButton *acceptBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    acceptBtn.frame=CGRectMake(80, 170, 100, 60);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [acceptBtn addTarget:self action:@selector(lifeAcceptButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:acceptBtn];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCancel.frame=CGRectMake(220, 170, 100, 60);
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:btnCancel];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [UIView commitAnimations];
}

-(void)lifeAcceptButtonAction:(id)sender{
    int lifeUserDefault = (int)[userDefault integerForKey:@"life"];
    //NSLog(@"Life Before added -==- %d",lifeUserDefault);
    NSString *title = [NSString stringWithFormat:@"Thank you %@ for extra life",self.senderName];
    NSString *description = [NSString stringWithFormat:@"%@ got one extra life gifted by %@",self.currentUserName,self.senderName];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"life",FacebookType,title,FacebookTitle,description,FacebookDescription,@"say",FacebookActionType, nil];
   // NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"thanks for life",FacebookType,title,FacebookTitle,description,FacebookDescription,@"say",FacebookActionType, nil];
    AppController *appDelegate = (AppController*)[UIApplication sharedApplication].delegate;
    [appDelegate storyPostwithDictionary:dict];
    
    if (lifeUserDefault<=4) {
        lifeUserDefault++;
        [userDefault setInteger:lifeUserDefault forKey:@"life"];
        // NSLog(@"Life After added -==- %d",lifeUserDefault);
        [userDefault synchronize];
        
        //[[[UIAlertView alloc] initWithTitle:@"Congratulation!" message:[NSString stringWithFormat:@"You got new life from %@",self.senderName] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        
    }
    [self btnCancelAction:nil];
}
#pragma mark -
-(void) deleteFBRequest:(NSString *)requestId {
    
    FBRequestConnection *requestConnection = [[FBRequestConnection alloc] init];
//    NSString *accessTOken = [[NSUserDefaults standardUserDefaults]objectForKey:@"Facebook Access Token"];
//    
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:accessTOken,@"access_token", nil];
    
    FBRequest *deleteRequest = [FBRequest requestForDeleteObject:requestId];
    //FBRequest *deleteRequest = [[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:[requestIDs objectAtIndex:0] parameters:dict HTTPMethod:@"DELETE"];
    
    
    [requestConnection addRequest:deleteRequest completionHandler:^(FBRequestConnection *connetion, id result, NSError *error){
       
        if (error) {
            NSLog(@"Error == %@",error.localizedDescription);
        }
        else{
            //NSLog(@"Result--%@",result);
        }
    }];
    [requestConnection start];
}
-(void) newdeleteFBRequest:(id)requestId {
    
    FBRequestConnection *requestConnection = [[FBRequestConnection alloc] init];
    //    NSString *accessTOken = [[NSUserDefaults standardUserDefaults]objectForKey:@"Facebook Access Token"];
    //
    //    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:accessTOken,@"access_token", nil];
    
    FBRequest *deleteRequest = [FBRequest requestForDeleteObject:requestId];
    //FBRequest *deleteRequest = [[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:[requestIDs objectAtIndex:0] parameters:dict HTTPMethod:@"DELETE"];
    
    
    [requestConnection addRequest:deleteRequest completionHandler:^(FBRequestConnection *connetion, id result, NSError *error){
        
        if (error) {
            NSLog(@"Error == %@",error.localizedDescription);
        }
        else{
            //NSLog(@"Result--%@",result);
        }
    }];
    [requestConnection start];
}
#pragma mark -
-(void)btnSendAction:(id)sender {
    //NSLog(@"Send BUtton clicked");
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"got extra life"], @"message", nil];
    NSString *lifeReq = [jsonWriter stringWithObject:challenge];
    
    
    [jsonWriter release];
    // Create a dictionary of key/value pairs which are the parameters of the dialog
    
    // 1. No additional parameters provided - enables generic Multi-friend selector
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:self.strSenderFbId,@"to",lifeReq, @"data",@"sending extra life",@"message",@"Send Live",@"Title",nil];
    
    
    //self.currentUserName=[[NSUserDefaults standardUserDefaults]objectForKey:@"ConnectedFacebookUserName"];
    NSString *title = [NSString stringWithFormat:@"Sent extra life to %@",self.senderName];
    NSString *des = [NSString stringWithFormat:@"Now %@ has one extra life gifted by %@", self.senderName, self.currentUserName];
    NSLog(@"Des = %@",des);
    
    NSDictionary *storyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"life",FacebookType,title,FacebookTitle,des,FacebookDescription,@"send",FacebookActionType, nil];
    
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate=nil;
    appDelegate.openGraphDict = storyDict;
    if (FBSession.activeSession.isOpen) {
        
        //[self sendLifeToFrnd];
         [appDelegate sendRequestToFriends:params];
        
    }
    else{
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLifeToFrnd) name:RequestTOFacebook object:nil];
        //[appDelegate openSessionWithAllowLoginUI:2];
        [appDelegate openSessionWithLoginUI:2 withParams:params];
    }
    
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"life",FacebookType,@"Sent Life",FacebookTitle,@"Gave Life",FacebookDescription,@"send",FacebookActionType, nil];
//    [appDelegate storyPostwithDictionary:dict];
    customView.hidden=YES;
}
-(void) sendLifeToFrnd{
    
//    SBJsonWriter *jsonWriter = [SBJsonWriter new];
//    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"Life sent"], @"Text", nil];
//    NSString *lifeReq = [jsonWriter stringWithObject:challenge];
    
    
    // Create a dictionary of key/value pairs which are the parameters of the dialog
    
    // 1. No additional parameters provided - enables generic Multi-friend selector
    // 2. Optionally provide a 'to' param to direct the request at a specific user
    //@"286400088", @"to", // Ali
    // 3. Suggest friends the user may want to request, could be game context specific?
    //[suggestedFriends componentsJoinedByString:@","], @"suggestions",
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"New Life", @"message",
                                     self.strSenderFbId,@"to",
                                     nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:@"Send new life" title:@"New Life" parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            // Case A: Error launching the dialog or sending request.
            NSLog(@"Error sending request.==%@",[error localizedDescription]);
        } else {
            
           // NSLog(@"Result url==%@",resultUrl);
            
            if (result == FBWebDialogResultDialogNotCompleted) {
                // Case B: User clicked the "x" icon
                NSLog(@"User canceled request.");
                customView.hidden=YES;
            } else {
                
                NSLog(@"Request Sent.");
                customView.hidden=YES;
            }//End Else Block
        }//End else block error check
    }];// end FBWebDialogs
}

-(void)btnCancelAction:(id)sender {
    NSLog(@"Cancel Button Click");
    customView.hidden=YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
