//
//  LifeOver.m
//  BowHunting
//
//  Created by Sumit Ghosh on 26/03/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "LifeOver.h"
#import "Clouds.h"
#import "GameIntro.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "AdMobFullScreenViewController.h"
#import "GameState.h"
#import "FriendsViewControllerTaggable.h"
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"
#define RequestTOFacebook @"LifeRequest"

@implementation LifeOver
@synthesize lblNextLifeTime,timeText,menuAskFrnd,lblMoreLifeNow,menuMoreLife,menuBack;

CGSize ws;

-(id)init
{
	if( (self=[super init]))
    {
      [[GameState sharedState].bannerAddView removeFromSuperview];
        
        BOOL networkStatus = [GameState sharedState].networkStatus;//[[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
        if(!(networkStatus==NO))
        {
            if(!adm)
            {
                adm= [[AdMobViewController alloc]initWithBOOL:YES];
                [GameState sharedState].bannerAddView =adm.view;
                [[[CCDirector sharedDirector] view] addSubview:adm.view];
            }
        }
        

        ws=[[CCDirector sharedDirector]winSize];
        
        //create sky etc..
        
        viewController = (UIViewController*)[(AppController *)[UIApplication sharedApplication].delegate getRootViewController];
        
        viewController = (UIViewController*)[(AppController *)[[UIApplication sharedApplication] delegate] getRootViewController];
        BOOL checkInternet=[GameState sharedState].networkStatus;//[[NSUserDefaults standardUserDefaults]objectForKey:CurrentNetworkStatus];
        if (checkInternet) {
            
            adf = [[AdMobFullScreenViewController alloc]init];
      
            //[self adMob];
            
        }

          //[Chartboost showRewardedVideo:CBLocationStartup];
      //  [viewController presentViewController:adf animated:NO completion:nil];
//-----------
         //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoFriendsViewTaggable) name:@"RefillLife" object:nil];
        //----------
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTimeNotification:) name:@"TimerNotification" object:nil];
        
        CCSprite *sky=[CCSprite spriteWithFile:@"gameOverSky.png"];
        sky.position=ccp(ws.width/2,ws.height/2);
        [self addChild:sky];
        
        Clouds *c=[[[Clouds alloc]init] autorelease];
        c.position=ccp(0,ws.height);
        [self addChild:c];
        
        CCMenuItemImage *imageNomorelives = [CCMenuItemImage itemWithNormalImage:@"no more lives button.png" selectedImage:@"no more lives button.png"];
        imageNomorelives.position=ccp(ws.width/2,ws.height/2+110);
        [self addChild:imageNomorelives];
        
        self.lblNextLifeTime=[CCLabelBMFont labelWithString:@"Time to next life" fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
        self.lblNextLifeTime.position=ccp(ws.width/2-20,ws.height/2+50);
        [self addChild:self.lblNextLifeTime];
        
        
        self.timeText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i: %i",min,sec] fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
        self.timeText.position=ccp(ws.width/2,ws.height/2+20);
        
        
       userDefault = [NSUserDefaults standardUserDefaults];
       remTime = (int)[userDefault integerForKey:@"timeRem"];
        //[self calculateTime:remTime];
        [self compareDate];
       // [self updateTime:remTime];
        [self addChild:self.timeText];
        
//        if (remTime) {
//            
//            min=remTime/60;
//            sec=remTime%60;
//            
//            if (sec<10) {
//                self.timeText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i: 0%i",min,sec] fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
//            }
//            else{
//                self.timeText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i: %i",min,sec] fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
//            }
//            self.timeText.position=ccp(ws.width/2,ws.height/2+20);
//            [self addChild:self.timeText];
//            
//            [self schedule:@selector(update) interval:1];
//        }
        
//        CCMenuItem *menuItemAskFrnds = [CCMenuItemImage itemWithNormalImage:@"refill_lives.png" selectedImage:@"refill_lives.png" target:self selector:@selector(refillLife)];
//        
//        menuAskFrnd = [CCMenu menuWithItems: menuItemAskFrnds, nil];
//        menuAskFrnd.position = ccp(ws.width/2, 130);
//        [menuAskFrnd alignItemsHorizontally];
//        [self addChild:menuAskFrnd z:100];
        
        CCMenuItem *menuItemMoreLife = [CCMenuItemImage itemWithNormalImage:@"more lives now.png" selectedImage:@"more lives now.png" target:self selector:@selector(moreLivesButtonClicked:)];
        
        menuMoreLife = [CCMenu menuWithItems: menuItemMoreLife, nil];
        menuMoreLife.position = ccp(ws.width/2, 80);
        [menuMoreLife alignItemsHorizontally];
        [self addChild:menuMoreLife z:100];
        
        CCMenuItem *menuItemBack = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"back.png" target:self selector:@selector(back:)];
        
        menuBack = [CCMenu menuWithItems: menuItemBack, nil];
        menuBack.position = ccp(40, ws.height-35);
        [menuBack alignItemsHorizontally];
        [self addChild:menuBack z:100];
    }
    return self;
}

#pragma mark-
-(void) checkTimeNotification:(NSNotification *)notification{
    
    NSLog(@"Notification Received");
    
    [self compareDate];
}
-(void) updateTime:(int)timeRem{
    
    remTime = timeRem;
    if(remTime>300)
    {
        remTime=300;
    }
    if (remTime)
    {
        
        min=remTime/60;
        sec=remTime%60;
        
        if (sec<10)
        {
            
        [self.timeText setString:[NSString stringWithFormat:@"%i: 0%i",min,sec]];
            
        }
        else
        {
        [self.timeText setString:[NSString stringWithFormat:@"%i: %i",min,sec]];

        }
        
        [self unschedule:@selector(Timer)];
        self.timeText.visible = YES;
        [self.lblNextLifeTime setString:@"Time to next life"];
        [self schedule:@selector(Timer) interval:1];
    }
}
-(void)Timer
{
    
    remTime--;
    [[NSUserDefaults standardUserDefaults] setInteger:remTime forKey:@"timeRem"];
    int minute = remTime/60;
    int second = remTime%60;
    
    if (second<10) {
        [self.timeText setString:[NSString stringWithFormat:@"%i:0%i",minute,second]];
    }
    else{
        [self.timeText setString:[NSString stringWithFormat:@"%i:%i",minute,second]];
    }
    
    if (remTime==0)
    {
        [self unschedule:@selector(Timer)];
        
        int life = (int)[userDefault integerForKey:@"life"];
        
        life++;
        [userDefault setInteger:life forKey:@"life"];
        [userDefault synchronize];

        remTime=300;
        
        if (life<5) {
            [self schedule:@selector(Timer) interval:1];
            [self.timeText setString:[NSString stringWithFormat:@"5:00"]];
        }
        else{
            self.timeText.visible = NO;
            [self.lblNextLifeTime setString:@"Full of life"];
            self.lblNextLifeTime.visible = YES;
            [self unschedule:@selector(Timer)];
            [userDefault setInteger:5 forKey:@"life"];
            [self.timeText setString:@"Full Of Lives..!"];
            [userDefault setObject:0 forKey:@"currentDate"];
            [userDefault setObject:0 forKey:@"GainLife"];
        }
    }
}


#pragma mark-
-(void)compareDate {
    
    NSString *strDate = [userDefault objectForKey:@"currentDate"];
    
    if (![strDate isEqualToString:@"0"]) {
        
        NSDate *currentDate = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSString *strCurrentDate = [formatter stringFromDate:currentDate];
        
        currentDate=[formatter dateFromString:strCurrentDate];
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSDate *oldDate = [formatter1 dateFromString:strDate];
        
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
        NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDate  toDate:currentDate  options:0];
        
        //int months = (int)[conversionInfo month];
        int days = (int)[conversionInfo day];
        int hours = (int)[conversionInfo hour];
        int minutes = (int)[conversionInfo minute];
        int seconds = (int)[conversionInfo second];
        
        //NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
        
        [self getExtraLife:days andHour:hours andMin:minutes andSec:seconds];
        [formatter release];
        [formatter1 release];
        [gregorianCal release];
    }
    else{
        
        self.timeText.visible = NO;
        [self.lblNextLifeTime setString:@"Full of life"];
        
    }
}
-(void)getExtraLife :(int)aday andHour:(int)ahour andMin:(int)amin andSec:(int)asec {
   
    int hoursInMin = ahour*60;
    hoursInMin=hoursInMin+amin;
    
    int extralife =hoursInMin/5;
    
    int gotLife = (int)[userDefault integerForKey:@"GainLife"];
    int totalTime = hoursInMin*60+asec;
    if (gotLife!=0) {
        hoursInMin = hoursInMin - gotLife*5;
        totalTime = totalTime - gotLife*5*60;
    }
    
   // int life = (int)[userDefault integerForKey:@"life"];
    int rem =amin%5;
    
    int remTimeforLife = rem*60+asec;
    
    remTimeforLife=300-remTimeforLife;
    
    if (aday>0 || hoursInMin>=25) {
        
        [userDefault setInteger:5 forKey:@"life"];
        [userDefault setObject:@"0" forKey:@"currentDate"];
        self.timeText.visible = NO;
        [self.lblNextLifeTime setString:@"Full of life"];
        [userDefault setInteger:0 forKey:@"GainLife"];
    }
    else if(totalTime>=300){
        
        if(extralife>=5){
            
            [userDefault setInteger:5 forKey:@"life"];
            [userDefault synchronize];
            [userDefault setObject:@"0" forKey:@"currentDate"];
            self.timeText.visible = NO;
            [self.lblNextLifeTime setString:@"Full of life"];
            [userDefault setInteger:0 forKey:@"GainLife"];
        }
        else{
            if (extralife>5) {
                extralife = 5;
            }
            if (gotLife==0) {
                [userDefault setInteger:extralife forKey:@"GainLife"];
                
            }
            else{
                [userDefault setInteger:extralife forKey:@"GainLife"];
                extralife = extralife - gotLife;
            }
            //--------
            [userDefault setInteger:extralife forKey:@"life"];
            [userDefault synchronize];
            NSLog(@"remaining time %d",remTimeforLife);
            [self updateTime:remTimeforLife];
        }
    }
    else{
        [self updateTime:remTimeforLife];
    }

    
}
#pragma mark
#pragma mark Button methods
#pragma mark ==============================================

-(void)back:(id)sender
{
    [[GameState sharedState].bannerAddView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefillLife" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimerNotification" object:nil];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameIntro scene]]];
}

-(void)askFrndsButtonClicked:(id)sender {
   // NSLog(@"Ask Friends Button Click");

    
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.openGraphDict = nil;
    BOOL check = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    
    if (check == NO) {
        [appDelegate openSessionWithLoginUI:8 withParams:nil];
        appDelegate.delegate = self;
    }
    else{
        [self gotoFriendsView];
    }

}
-(void) shareOnFb
{
    
    NSString *strPostMessage = [NSString stringWithFormat:@"Hi Friends, Please join me in Bow Hunting Chief. Select your arrows and hunt as many birds as you can and get more points. Lets see who is the best hunter amongst us!"];
    
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     strPostMessage, @"description",
     @"https://itunes.apple.com/us/app/bow-hunting-chief/id853508979?ls=1&mt=8", @"link",@"Bow Hunting Chief",@"name",
     @"http://i.imgur.com/LaDdDX0.png?1",@"picture",
     nil];
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        [GameState sharedState].shareOnfb=FALSE;
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            
            //NSLog(@"result==%u",result);
            //NSLog(@"Url==%@",resultUrl);
            if (result == FBWebDialogResultDialogNotCompleted) {
                NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
                // NSLog(@"User cancel Request");
            }//End Result Check
            else{
                NSString *sss= [NSString stringWithFormat:@"%@",resultUrl];
                if ([sss rangeOfString:@"post_id"].location == NSNotFound) {
                    // NSLog(@"User Cancel Share");
                }
                else{
                    int life=5;
                    [self lifeFilled];
                    [[NSUserDefaults standardUserDefaults] setInteger:life forKey:@"life"];
                    
                    NSLog(@"posted on wall");
                }
            }//End Else Block Result Check
        }
    }];

}
-(void)shareFbForRefillLive
{
 [GameState sharedState].shareDecide=@"life";
    NSString *strPostMessage = [NSString stringWithFormat:@"Hi Friends, Please join me in Bow Hunting Chief. Select your arrows and hunt as many birds as you can and get more points. Lets see who is the best hunter amongst us!"];
    
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     strPostMessage, @"description",
     @"https://itunes.apple.com/us/app/bow-hunting-chief/id853508979?ls=1&mt=8", @"link",@"Bow Hunting Chief",@"name",
     @"http://i.imgur.com/LaDdDX0.png?1",@"picture",
     nil];
    
    appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
    if([[NSUserDefaults standardUserDefaults] objectForKey:FacebookConnected])
    {
        if (FBSession.activeSession.isOpen)
        {
            [self shareOnFb];
        }
        else
        {
            [appDelegate openSessionWithLoginUI:1 withParams:params];
        }
    }
    else
    {
        [self shareOnFb];
    }
  
}
-(void) refillLife
{
   
    if(![GameState sharedState].shareOnfb)
    {
         [GameState sharedState].shareOnfb=TRUE;
     [Chartboost showInterstitial:CBLocationHomeScreen];
   
        
    }
    //---------------------------------------
    //NSLog(@"Messaga == %@",strPostMessage);
}

-(void) displayFacebookFriendsList{
    [self gotoFriendsView];
}
-(void) gotoFriendsView
{
    
    AppController * appDelegateL = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegateL.delegate = nil;
    RootViewController *viewCntrler = (RootViewController*)[appDelegateL getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    if (!self.fbFrnds) {
        self.fbFrnds = [[[FriendsViewController alloc] initWithHeaderTitle:@"Ask Life"] autorelease];
        [self.fbFrnds updateFriendsView];
        //WithNibName:@"FriendsViewController" bundle:nil];
    }
    else{
        [self.fbFrnds updateFriendsView];
    }
    self.fbFrnds.delegate = nil;
    NSArray *frndsListArray = [[NSUserDefaults standardUserDefaults] objectForKey:FacebookAllFriends];
    NSLog(@"frnds = %@",frndsListArray);
    self.fbFrnds.friendListArray = [NSArray arrayWithArray:frndsListArray];
    self.fbFrnds.isLifeRequest = YES;
    self.fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);;
    
    //fbFrnds.headerTitle = @"Ask Life";
    [UIView animateWithDuration:1 animations:^{
        
        self.fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewCntrler presentViewController:self.fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];
}

-(void)moreLivesButtonClicked:(id)sender {
    
    
    self.menuAskFrnd.visible=NO;
    self.menuMoreLife.visible=NO;
    self.menuBack.visible=NO;
    
    if(!self.storeLayer){
        self.storeLayer=[[[Store alloc]init] autorelease];
        [self addChild:self.storeLayer];
    }
    else{
        ((Store*)self.storeLayer).visible=YES;
    }
    
    //NSLog(@"More Lives Button Click");
}

#pragma mark
#pragma mark Send REquest to friends method
#pragma mark ==============================================

-(void) sendRequestToFrnds{
    
//    int level = [userDefault integerForKey:@"level"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"Life Request"], @"message", nil];
    NSString *lifeReq = [jsonWriter stringWithObject:challenge];
    
    [jsonWriter release];
    // Create a dictionary of key/value pairs which are the parameters of the dialog
    
    // 1. No additional parameters provided - enables generic Multi-friend selector
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     // 2. Optionally provide a 'to' param to direct the request at a specific user
                                     //@"286400088", @"to", // Ali
                                     // 3. Suggest friends the user may want to request, could be game context specific?
                                     //[suggestedFriends componentsJoinedByString:@","], @"suggestions",
                                     lifeReq, @"data",@"Live Request",@"title",@"Request for Life",@"message",
                                     nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:@"Request for Life" title:@"Live Request" parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            // Case A: Error launching the dialog or sending request.
            NSLog(@"Error sending request.==%@",[error localizedDescription]);
        } else {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:RequestTOFacebook object:nil];
          //  NSLog(@"Result url==%@",resultUrl);
            //==========================================================
            
            //On Cancel
            // Result url==fbconnect://success?error_code=4201&error_message=User+canceled+the+Dialog+flow
            
            //On Send
            //Result url==fbconnect://success?request=532786970172029&to%5B0%5D=100004995941963
            //===========================================================
            if (result == FBWebDialogResultDialogNotCompleted) {
                // Case B: User clicked the "x" icon
               // NSLog(@"User canceled request.");
            } else {
                
                NSLog(@"Request Sent.");
            }//End Else Block
        }//End else block error check
    }];// end FBWebDialogs
}
-(void) updateAfterRequestSent:(BOOL)value
{
    [self lifeFilled];
}

#pragma mark Life Filled
-(void)lifeFilled
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefillLife" object:nil];
       rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    float xCordinate;
    UIImageView * upperView;
if(!backgroundView)
{
    if(frame.size.width==320)
    {
        xCordinate=frame.size.height;
        backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)] autorelease];
        upperView = [[[UIImageView alloc]initWithFrame:CGRectMake(40,40, frame.size.height-80, frame.size.width-80)] autorelease];

    }
    else
    {
        xCordinate=frame.size.width;
          backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        upperView = [[[UIImageView alloc]initWithFrame:CGRectMake(40,40, frame.size.width-80, frame.size.height-80)] autorelease];

    }

    
        [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbg.png"]]];
        
        [rootViewController.view addSubview:backgroundView];
               //-----------------------------------------
    
        upperView.image=[UIImage imageNamed:@"popup.png"];
        [backgroundView addSubview:upperView];
    
    
        CGRect rect;
        if(frame.size.height>480)
            rect=CGRectMake(xCordinate/2-50, 200, 100, 50);
        else
            rect=CGRectMake(xCordinate/2-50, 200, 100, 50);
        UIButton * playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = rect;
        UIImage *btnImage = [UIImage imageNamed:@"btn_play.png"];
        
        [playButton setImage:btnImage forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:playButton];
        
        //-------
        //--------lower view
        
        //-------level and target
        //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [UIView animateWithDuration:0.6f animations:^(void)
         {
             UILabel * lifeFilled=[[UILabel alloc]initWithFrame:CGRectMake(20, 30,upperView.frame.size.width-40, 80)];
             lifeFilled.text=@"Hey you got 5 lives\n enjoy the game!";
             lifeFilled.lineBreakMode=YES;
             lifeFilled.numberOfLines=0;
            // lifeFilled.textColor=[UIColor colorWithRed:(CGFloat)157/255 green:(CGFloat)214/255 blue:(CGFloat)254/255 alpha:1.0];
             lifeFilled.textAlignment=NSTextAlignmentCenter;
             lifeFilled.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:30];
             [upperView addSubview:lifeFilled];
        }];
//        if(frame.size.height>480)
//            rect=CGRectMake(frame.size.height-250, 60, 210, 90);
//        else
//            rect=CGRectMake(frame.size.height-240, 60, 210, 50);
//        
//        target=[[UILabel alloc]initWithFrame:rect];
//        target.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
//        
//        target.text=[NSString stringWithFormat:@"Targeted Birds-30"];
//        [self.backgroundView addSubview:target];
        
//    }
//    else
//    {
//        backgroundView.hidden=NO;
//        
//        [rootViewController.view addSubview:backgroundView];
////        level.text=[NSString stringWithFormat:@"Level-%d",(int)levelno];
////        target.text=[NSString stringWithFormat:@"Targeted Birds-30"];
//        
//        
//    }
    }
   
}
-(void)playButtonAction
{
    self.timeText.visible = NO;
    [self.lblNextLifeTime setString:@"Full of life"];
    [[GameState sharedState].bannerAddView removeFromSuperview];
  [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameIntro scene]]];
     [backgroundView removeFromSuperview];
}

#pragma mark Taggable
-(void)gotoFriendsViewTaggable
{
    
    BOOL facebookConnection = [[NSUserDefaults standardUserDefaults] objectForKey:FacebookConnected];
    
    NSLog(@"facebook status is %d",facebookConnection);
    
    if(facebookConnection==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please login with Facebook" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    viewController = (UIViewController*)[(AppController *)[UIApplication sharedApplication].delegate getRootViewController];
    
   
    CGRect frame = [UIScreen mainScreen].bounds;
    fbFrnds = [[FriendsViewControllerTaggable alloc] initWithHeaderTitle:@"Ask Life"];//
    fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);
    
    [UIView animateWithDuration:1 animations:^{
        
        fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewController presentViewController:fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];
}
-(void)dealloc {

    [super dealloc];
}
@end
