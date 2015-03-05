//
//  AppDelegate.m
//  BowHunting
//
//  Created by tang on 12-9-24.
//  Copyright tang 2012年. All rights reserved.
//

#import "cocos2d.h"

#import <AdSupport/AdSupport.h>
#import "AppDelegate.h"
#import "IntroLayer.h"
#import <Parse/Parse.h>
#import <sys/sysctl.h>
#include <sys/utsname.h>
#import "RageIAPHelper.h"
#import "Reachability.h"
#import "GameState.h"
#import "Flurry.h"
#import <sqlite3.h>
#define APP_HANDLED_URL @"App_Handel_Url"
#define ShareToFacebook @"FacebookShare"
#define RequestTOFacebook @"LifeRequest"
#define ReceiveNotification @"REceiveNotification"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

-(UINavigationController *) getRootViewController{
    
    return navController_;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    sleep(2);
    

    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *strCheckFirstRun = [userDefault objectForKey:@"firstrun"];
    NSLog(@"CheckFirstRun==%@",[userDefault objectForKey:@"firstrun"]);
        //[self saveinSqlite];
    if (!strCheckFirstRun)
    {
        [userDefault setObject:@"0" forKey:@"currentDate"];
        [userDefault setObject:@"1" forKey:@"firstrun"];
        [userDefault setInteger:5 forKey:@"life"];
        [userDefault setObject:@"1" forKey:@"levelClear"];
        [userDefault setInteger:0 forKey:@"GainLife"];
        [userDefault setInteger:5 forKey:@"MultiArrows"];
        [userDefault setInteger:5 forKey:@"BoosterArrows"];
        [self saveinSqlite];
        [userDefault synchronize];
   [FBAppEvents activateApp];
    }
    //[userDefault setObject:@"50" forKey:@"levelClear"];
    //[self closeSession];
	// Create the main window

	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    //[RevMobAds startSessionWithAppID:@"53f4806b2d66c5d506804e0f"];
//    [RevMobAds session].testingMode = RevMobAdsTestingModeWithAds;
//
//Commented need to be changed for actual App
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//       
//   [Parse setApplicationId:@"A6MDRE3AD1IRK6M6oVTKEqWnstDFZOkLx8sHMBmU" clientKey:@"HNv2Th5NPzhcZ0S2NYmzj4s0Xdz4OTHsBJnb3Z5F"];        [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//
//    });
//testing
    //-----------
    [Chartboost startWithAppId:@"54b79d7943150f4c0e24dc54" appSignature:@"6b0914379f7f7dd8c2094cf53d8b08e5f2213c11" delegate:self];
    
    [Chartboost cacheRewardedVideo:CBLocationDefault];
    //--------------
    //-----------live
    /*[Chartboost startWithAppId:@"5485f07ac909a6303263a720" appSignature:@"7bd97a4b58368b10633be73ebd06b48a18c2b73c" delegate:self];
    
    [Chartboost cacheRewardedVideo:CBLocationDefault];*/
        //--------------
 dispatch_async(dispatch_get_global_queue(0,0), ^{
       [Parse setApplicationId:@"4stpsQ6w7p9uRUb8ajuwlyU8yG4m7snBgfIHkKxv" clientKey:@"Knb6BZ5E5hyo03YsQFiGXEYNF5WOnC7UEQBcaOnJ"];
       [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    });
    //----Flurry
     [Flurry startSession:@"ZPVT5HW8SWRFFBYFNQM9"];
//--------
    //Live
 /*dispatch_async(dispatch_get_global_queue(0,0), ^{
    [Parse setApplicationId:@"EIRAbJWiTrANkX5CoqJQDlTSxJCR3uHlUDIPZAMd" clientKey:@"QBap4D3gtajlr4LdMpbvFC34irNROU8X5TGk0KhJ"];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    });*/

    
   [self reacheability];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reacheability) name:kReachabilityChangedNotification object:nil];    //Root VIEW Controller
    self.rootViewController = [[[RootViewController alloc] init] autorelease];
//-------------
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
     [self retriveFromSQL];
  
//-------------
    //[self synchronize];
	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGBA8
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
	[director_ setDisplayStats:NO];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	
	return YES;
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString *strInstallationId = currentInstallation.installationId;
    NSLog(@"Installation ID -=-= %@",strInstallationId);
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    //    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];

   
}
// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[director runWithScene: [IntroLayer scene]];
	}
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppEvents logEvent:FBAppEventNameActivatedApp];


//     [[RevMobAds session] showFullscreen];
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimerNotification" object:nil];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}

#pragma connectivity check
-(void)reacheability
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    BOOL networkStatus = NO;
    if(status == NotReachable)
    {
        networkStatus = NO;
        NSLog(@"stringgk////");
//        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet ConnectionFirst" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    }
    else if (status == ReachableViaWiFi)
    {
        NSLog(@"reachable");
        networkStatus = YES;
        
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        networkStatus = YES;
    }
    [GameState sharedState].networkStatus=networkStatus;
    
    [[NSUserDefaults standardUserDefaults] setBool:networkStatus forKey:CurrentNetworkStatus];
   [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Network Status %hhd",[GameState sharedState].networkStatus);
    // Do any additional setup after loading the view.
    
}




#pragma mark -
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}
-(BOOL) openSessionWithLoginUI:(NSInteger)value withParams: (NSDictionary *)dict
{
    [self retriveFromSQL];
    NSArray *permissions = [NSArray arrayWithObjects:@"public_profile",@"user_friends",@"publish_actions", nil];
    
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session
    [FBSession setActiveSession:session];
    ms_friendCache = NULL;
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                if(FBSession.activeSession.isOpen)
                {
                    
                if (error==nil) {
                    
                    
//                    BOOL check = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
//                    
//                    if (check==NO) {
//                        
//                        NSLog(@"Share Game play start story");
//                        
//                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"play",FacebookType,@"Playing Bow Hunting Chief",FacebookTitle,@"Enjoying a new exciting game NOW!",FacebookDescription,@"start",FacebookActionType, nil];
//                        
//                        [self storyPostwithDictionary:dict];
//                    }
                    
    
                    
                    
                    FBAccessTokenData *tokenData= session.accessTokenData;
                    
                    NSString *accessToken = tokenData.accessToken;
                    NSLog(@"AccessToken==%@",accessToken);
                    
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                    [self fetchFacebookGameFriends:accessToken];
                    
                    if (value==1) {
                        
                       
                        [self shareOnFacebookWithParams:dict];
                        
                    }
                    else if (value == 2){
                        
                        
                        [self sendRequestToFriends:dict];
                        
                    }
                    else if(value == 8){
                        
                    }
                    else if(value==3)
                    {
                        
                        [self shareOnFacebook];
                    }
                    else if(value==7)
                    {
                        [self sendRequestToFriendsTaggable:[GameState sharedState].selectedFrndsStringTag];
                    }
                    else
                    {
                        NSLog(@"Unknown Value");
                    }
                    
                    
                    
                    [FBRequestConnection
                     startForMeWithCompletionHandler:^(FBRequestConnection *connection,id<FBGraphUser> user,NSError *error){
                         
                          NSString *userID = [NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
                         
                         NSLog(@"User name %@",[user objectForKey:@"name"]);
                             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FacebookConnected];
                             [[NSUserDefaults standardUserDefaults] setObject:userID forKey:
                              ConnectedFacebookUserID];
                         [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"name"] forKey:
                          UserFbName];
                         [self synchronize];
                         //[self checkFbFriendPlaying];
                         //[self checkUserLevel];

                         [session release];
                         [self updateFacebookID];
                     }];
                    
                    // [self retriveAllfriends];
                }
                else{
                    [session release];
                    NSLog(@"Session not open==%@",error);
                }
                    
                }
                // Respond to session state changes,
                // ex: updating the view
            }];
    
    return YES;
}
- (BOOL)openSessionWithAllowLoginUI:(NSInteger)isLoginReq{
    
    self.CurrentValue = isLoginReq;
    NSArray *permissions = [NSArray arrayWithObjects:@"public_profile",@"user_friends",@"publish_actions", nil];
    
    
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session
    [FBSession setActiveSession:session];
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if (error==nil) {
                    //[NSThread detachNewThreadSelector:@selector(fetchFacebookGameFriends) toTarget:self withObject:nil];
                    
                    FBAccessTokenData *tokenData= session.accessTokenData;
                    
                    NSString *accessToken = tokenData.accessToken;
                    //NSLog(@"AccessToken==%@",accessToken);
                   
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                    
                    [self fetchFacebookGameFriends:accessToken];
                    
                    [FBRequestConnection
                     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                       id<FBGraphUser> user,
                                                       NSError *error){
                         
                         NSString *userInfo = @"";
                         userInfo = [userInfo
                                     stringByAppendingString:
                                     [NSString stringWithFormat:@"Name: %@\n\n",
                                      [user objectForKey:@"id"]]];
                        // NSLog(@"userinfo = %@",userInfo);
                         NSArray *ary=[userInfo componentsSeparatedByString:@":"];
                         if([ary count]>1){
                             userInfo=[ary objectAtIndex:1];
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@" " withString:@""];
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                            // NSLog(@"sender id=%@",userInfo);
                             
                             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FacebookConnected];
                             [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:ConnectedFacebookUserID];
                         }
                     }];
                    
                   // [self retriveAllfriends];
                }
                else{
                    
                    NSLog(@"Session not open==%@",error);
                }
                
               // Respond to session state changes,
                // ex: updating the view
            }];
    return YES;
}
- (void) checkSessionState:(FBSessionState)state {
    switch (state) {
        case FBSessionStateOpen:
            break;
        case FBSessionStateCreated:
            break;
        case FBSessionStateCreatedOpening:
            break;
        case FBSessionStateCreatedTokenLoaded:
            break;
        case FBSessionStateOpenTokenExtended:
            // I think this is the state that is calling
            break;
        case FBSessionStateClosed:
            break;
        case FBSessionStateClosedLoginFailed:
            break;
        default:
            break;
    }
}
-(void) fetchFacebookGameFriends:(NSString *)accessToken
{
    NSString *query =
    @"SELECT uid, name, pic_small FROM user WHERE is_app_user = 1 and uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() )";
    
    NSDictionary *queryParam = @{ @"q": query, @"access_token":accessToken };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"parameters:queryParam HTTPMethod:@"GET"completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else {
            // NSLog(@"Result: %@", result);
            
            NSArray *friendInfo = (NSArray *) result[@"data"];
            
            NSLog(@"Array Count==%lu",(unsigned long)[friendInfo count]);
            
            //NSLog(@"\n\nArray==%@",friendInfo);
            
            NSMutableArray *frndsarray = [[NSMutableArray alloc] init];
            
            for (int i =0; i<friendInfo.count; i++) {
                NSDictionary *dict = [friendInfo objectAtIndex:i];
                NSString *fbID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                NSLog(@"Friends Id==%@",fbID);
                [frndsarray addObject:fbID];
                
            }//End For Loop
            
            [[NSUserDefaults standardUserDefaults] setObject:frndsarray forKey:FacebookGameFrindes];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"Friends Ids==%@@",[[NSUserDefaults standardUserDefaults]objectForKey:FacebookGameFrindes]);

            
            FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/invitable_friends?fields=name,picture,id"];
            
            [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                NSLog(@"Invitable Friends==%@",result[@"data"]);
                
                NSArray *invite_friendInfo = (NSArray *) result[@"data"];
                
                                NSLog(@"Array Count==%lu",(unsigned long)[invite_friendInfo count]);
                //                NSLog(@"ARRAY = %@",invite_friendInfo);
                //========================
                NSMutableArray *inviteFrndsAry = [[NSMutableArray alloc] init];
                
                for (int i =0; i<invite_friendInfo.count; i++) {
                    NSDictionary *dict = [invite_friendInfo objectAtIndex:i];
                    NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
                    
                    NSString *aid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                    //NSLog(@"aid = %@",aid);
                    [aDict setObject:aid forKey:@"uid"];
                    NSString *name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                    [aDict setObject:name forKey:@"name"];
                    NSDictionary *secDict = [[dict objectForKey:@"picture"] objectForKey:@"data"];
                    NSString *picUrl = [NSString stringWithFormat:@"%@",[secDict objectForKey:@"url"]];
                    [aDict setObject:picUrl forKey:@"pic_small"];
                    
                    [inviteFrndsAry addObject:aDict];
                    NSLog(@"Invite Friends==%@",inviteFrndsAry);
                    [aDict release];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:inviteFrndsAry forKey:FacebookInviteFriends];
                
                NSLog(@"Invite Friends==%@",[[NSUserDefaults standardUserDefaults]objectForKey:FacebookInviteFriends]);
                
                NSArray *allFrndsArray = [friendInfo arrayByAddingObjectsFromArray:inviteFrndsAry];
                NSLog(@"All Friends Array = %@",allFrndsArray);
                [[NSUserDefaults standardUserDefaults] setObject:allFrndsArray forKey:FacebookAllFriends];
                
                
                [inviteFrndsAry release];
                [frndsarray release];
                if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(displayFacebookFriendsList)]) {
                    
                    //[self.delegate displayFacebookFriendsList];
                }
            }];
        }
    }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
   
    [PFFacebookUtils handleOpenURL:url];
    
    [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        NSString *accessToken = call.accessTokenData.accessToken;
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"Facebook Access Token"];
        //NSLog(@"App Link Data = %@",call.appLinkData);
       // NSLog(@"call == %@",call);
        if (call.appLinkData && call.appLinkData.targetURL) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FacebookRequestNotification object:call.appLinkData.targetURL];
        }
        
    }];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //NSLog(@"Url== %@", url);
    return [FBSession.activeSession handleOpenURL:url];
}
-(void)updateFacebookID
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        currentInstallation[@"PlayerFacebookId"]=[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
        [currentInstallation saveInBackground];
        [currentInstallation saveInBackgroundWithBlock:^(BOOL succedss,NSError * error){
            NSLog(@"error updating fbID %@",error);
            
        }];
        


    });
}
#pragma mark Facebook
#pragma mark -
-(void) shareOnFacebookWithParams:(NSDictionary *)params
{
    
    if (self.openGraphDict != nil)
    {
        [self storyPostwithDictionary:self.openGraphDict];
    }
  else
  {
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
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:life forKey:@"life"];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)]) {
                        [self.delegate updateAfterRequestSent:NO];
                    }

                                       NSLog(@"posted on wall");
                }
            }//End Else Block Result Check
        }
    }];
  
  }

}

-(void) sendRequestToFriends:(NSDictionary *)params{
    if (self.openGraphDict != nil) {
        [self storyPostwithDictionary:self.openGraphDict];
    }
    
    if (!ms_friendCache) {
        ms_friendCache = [[FBFrictionlessRecipientCache alloc] init];
    }
    if (self.openGraphDict != nil) {
        [self storyPostwithDictionary:self.openGraphDict];
    }
    [ms_friendCache prefetchAndCacheForSession:nil];
    
    NSString *title = [NSString stringWithFormat:@"%@",[params objectForKey:@"Title"]];
    NSString *message = [NSString stringWithFormat:@"%@",[params objectForKey:@"message"]];
    NSLog(@"Message==%@",message);
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:message title:title parameters:params handler:^(FBWebDialogResult result, NSURL *url, NSError *error){
        if (error) {
            // Case A: Error launching the dialog or sending request.
            NSLog(@"Error sending request.==%@",[error localizedDescription]);
            if ([title isEqualToString:@"invite friends"]) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)]) {
                    [self.delegate updateAfterRequestSent:NO];
                }
            }
        } else {
            NSLog(@"Result url==%@",url);
            //===============================================
            
            
            //===============================================
            if (result == FBWebDialogResultDialogNotCompleted) {
                // Case B: User clicked the "x" icon
                NSLog(@"User canceled request.");
                if ([title isEqualToString:@"Invite Friends"]) {
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)]) {
                        [self.delegate updateAfterRequestSent:NO];
                    }
                }
            } else {
                
                NSLog(@"Request Sent.");
                if (self.delegate  != nil && [self.delegate respondsToSelector:@selector(hideFacebookFriendsList)]) {
                    [self.delegate hideFacebookFriendsList];
                }
                if ([title isEqualToString:@"invite friends"]) {
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)]) {
                        [self.delegate updateAfterRequestSent:YES];
                        
                    }
                }
                
            }//End Else Block
            
        }//End else block error check
    }friendCache:ms_friendCache];
    
}
-(void) sendRequestToFriendsTaggable:(NSMutableString *)params
{
        NSMutableDictionary<FBGraphObject> *object =
    [FBGraphObject openGraphObjectForPostWithType:@"bowhuntingchief:level"
                                            title:@""
                                            image:@"fbstaging://graph.facebook.com/staging_resources/MDExNDQyNjIzMzQyNjc3NjM2OjUxMDY4MTkwNg==" url:@"https://itunes.apple.com/us/app/bow-hunting-chief/id853508979?ls=1&mt=8"
                                      description:@"Completed Level in Bow Hunting Chief."];
    
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject openGraphActionForPost];
    action[@"tags"]=[GameState sharedState].selectedFrndsStringTag;
    action[@"level"]=object;
    
    
    [FBRequestConnection startForPostWithGraphPath:@"me/bowhuntingchief:complete"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
                                   
                                     
                                     if (!error)
                                     {
    [[[UIAlertView alloc] initWithTitle:@"Story Shared !!" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
//                                         NSLog(@"self.friends count is ======= %d",self.friendsCount);
//                                        int life=5;
//                                          
//                                          [[NSUserDefaults standardUserDefaults] setInteger:life forKey:@"life"];
//                                          if (self.delegate && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)])
//                                         {
//                                              [self.delegate updateAfterRequestSent:NO];
//                                          }

                                         
                                     }
                                     else{
                                         NSLog(@"error %@",error.description);
                                        // [[AppDelegate sharedAppDelegate]showToastMessage:@"Error on posting to facebook, please try again later . "];;
                                         
                                     }
                                     // handle the result
                                 }];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(void) storyPostwithDictionary:(NSDictionary *)dict{
    
    //http://www.screencast.com/t/S0YR7HvL4L
    
    NSString *description = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookDescription]];
    NSString *title = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookTitle]];
    
    NSString *type = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookType]];
    
    NSString *actionType = [NSString stringWithFormat:@"/me/bowhuntingchief:%@",[dict objectForKey:FacebookActionType]];
    NSLog(@"Type = %@", type);
    NSLog(@"Action  =%@",actionType);
    
    
    //http://www.screencast.com/t/S0YR7HvL4L
            id<FBGraphObject> object =
            [FBGraphObject openGraphObjectForPostWithType:[NSString stringWithFormat:@"bowhuntingchief:%@",type] title:title image:@"fbstaging://graph.facebook.com/staging_resources/MDExNDQyNjIzMzQyNjc3NjM2OjUxMDY4MTkwNg==" url:@"https://itunes.apple.com/us/app/bow-hunting-chief/id853508979?ls=1&mt=8" description:description];
            
            id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
            [action setObject:object forKey:type];
            
            // create action referencing user owned object
            [FBRequestConnection startForPostWithGraphPath:actionType graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error) {
                    NSLog(@"OG story posted, story id: %@", [result objectForKey:@"id"]);
                  //  [[[UIAlertView alloc] initWithTitle:@"OG story posted" message:@"Check your Facebook profile or activity log to see the story." delegate:self cancelButtonTitle:@"OK!"otherButtonTitles:nil] show];
                    
                } else {
                    // An error occurred
                    NSLog(@"Encountered an error posting to Open Graph: %@", error);
                }
            }];
    
}

#pragma mark-
#pragma mark Tweet
-(void) twitterAuthorization{
    
    //[[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:TwitterConsumerKey andSecret:TwitterConsumerSecret];
   [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"Xg3ACDprWAH8loEPjMzRg" andSecret:@"9LwYDxw1iTc6D9ebHdrYCZrJP4lJhQv5uf4ueiPHvJ0"];
    [[FHSTwitterEngine sharedEngine] setDelegate:self];
    [[FHSTwitterEngine sharedEngine] loadAccessToken];
    
    if ([FHSTwitterEngine sharedEngine].isAuthorized) {
        NSLog(@"a");
        
        [self postTweet];
        
        
    }
    else{
        NSLog(@"Display Login ");
        [[FHSTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:navController_ withCompletion:^(BOOL success) {
            NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
            if (success) {
                NSLog(@"b");
                [self postTweet];
            }
            else{
                
                NSLog(@" Failure");
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)]) {
                    [self.delegate updateAfterRequestSent:NO];
                }
            }
            
        }];
        
    }
}
-(NSString *) loadAccessToken{
    NSLog(@"Access Token = =%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"]);
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

-(void) storeAccessToken:(NSString *)accessToken{
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}
-(void) postTweet{
    //Hey, am playing this exciting game called Bow Hunting Chief. Check it out!
    NSString *tweet = @"Hey, am playing this exciting game called Bow Hunting Chief. Check it out!\nhttps://itunes.apple.com/us/app/bow-hunting-chief/id853508979?mt=8";
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            UIImage *image = [UIImage imageNamed:@"Icon@2x.png"];
            NSData *data = UIImageJPEGRepresentation(image, 0.9);
            NSError *returnCode = [[FHSTwitterEngine sharedEngine] postTweet:tweet withImageData:data];
        
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            
            NSLog(@"Return COde = %@",returnCode);
            if (returnCode) {
                NSLog(@"POsted");
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)]) {
                    [self.delegate updateAfterRequestSent:NO];
                }
            } else {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)]) {
                    NSLog(@"in post tweet if block");
                    [self.delegate updateAfterRequestSent:YES];
                }
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    });
    
}
-(void)shareOnFacebook
{
    //---------------------------------------
    //NSLog(@"Messaga == %@",strPostMessage);
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
                    NSLog(@"Update");
                    NSLog(@"In Purchase");
                    if (self.delegate && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)]) {
                        [self.delegate updateAfterRequestSent:YES];
                    }

                    NSLog(@"posted on wall");
                }
            }//End Else Block Result Check
        }
    }];

}
-(void)fullPackArwAction:(id)sender {
    //    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"booster"];
    
    UINavigationController *rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
    CGSize ws = [CCDirector sharedDirector].winSize;
    activityInd=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(ws.width/2, ws.height/2, 50, 50)];
    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityInd.color=[UIColor redColor];
    
    [rootViewController.view addSubview:activityInd];
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"powerBooster"];
    
    [activityInd startAnimating];
    RageIAPHelper *rage = [RageIAPHelper sharedInstance];
    rage.delegate = self;
    [rage requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            
            if (products.count <=0) {
                
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            else{
                SKProduct * product =  products[0];
                
                NSLog(@"Buying %@...", product.productIdentifier);
                [[RageIAPHelper sharedInstance] buyProduct:product];
                
                //                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"powerBooster"];
            }
        }
        [activityInd stopAnimating];
    }];
    [activityInd stopAnimating];
}
-(void)updateAfterArrowPurchase:(BOOL)value{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)]) {
        [self.delegate updateAfterRequestSent:value];
    }
}
- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward
{
    videoWatched=TRUE;
    int life=1;
  [[NSUserDefaults standardUserDefaults] setInteger:life forKey:@"life"];
}
- (void)didCloseRewardedVideo:(CBLocation)location
{
    if(videoWatched)
    {
   // [[GameState sharedState].bannerAddView removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateAfterRequestSent:)]) {
        NSLog(@"After Video Watched");
        videoWatched=FALSE;
        [self.delegate updateAfterRequestSent:YES];
    }
    }
    else
    {
        [Chartboost showInterstitial:CBLocationHomeScreen];
    }
 
}
- (void)didDismissRewardedVideo:(CBLocation)location
{
    
}
- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error
{
    NSLog(@"Error %lu location %@",(unsigned long)error,location);
     [Chartboost showInterstitial:CBLocationHomeScreen];
}
- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location
{
    
    return YES;
    
}
#pragma mark Interstetial add
- (BOOL)shouldRequestInterstitial:(CBLocation)location
{
    return YES;
}
- (BOOL)shouldDisplayInterstitial:(CBLocation)location
{
    return YES;
}
- (void)didFailToLoadInterstitial:(CBLocation)location
                        withError:(CBLoadError)error
{
    NSLog(@"Error in interstetial%lu",(unsigned long)error);
    if([GameState sharedState].shareOnfb)
    {
        if([[GameState sharedState].shareDecide isEqualToString:@"arrow"])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Refill" object:nil];
            

        }
        else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefillLife" object:nil];
            

        }
  
      
    }
}
- (void)didCloseInterstitial:(CBLocation)location
{
    if([GameState sharedState].shareOnfb)
    {

        if([[GameState sharedState].shareDecide isEqualToString:@"arrow"])
        {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Refill" object:nil];
        
            
        }
        else
        {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefillLife" object:nil];
       
        
        }
    }
}
#pragma mark Sqlite DB and Retrive--
-(void)saveinSqlite
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    //NSLog(@"%@",paths);
    // Check to see if the database file already exists
    
    
    /*if (databaseAlreadyExists == YES) {
     return;
     }*/
    
    // Open the database and store the handle as a data member
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle) == SQLITE_OK)
    {
        // Create the database if it doesn't yet exists in the file system
        
        
        // Create the PERSON table
        const char *sqlStatement = "CREATE TABLE  GameScoreFinal (ID INTEGER PRIMARY KEY AUTOINCREMENT, Level TEXT, Score TEXT,PlayerFbId TEXT)";
        /*NSString *insert=[NSString stringWithFormat:@"insert into person(id,firsrtname) VALUES(\"%@\",\"%@\")",1,"hunny"];*/
        /*  const char *insert="INSERT INTO PERSON (FIRSTNAME, LASTNAME, BIRTHDAY) VALUES ('""1'""'hunny'""'singh'""'1992-08-14')";*/
        char *error;
        if (sqlite3_exec(_databaseHandle, sqlStatement, NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"table created");
            // Create the ADDRESS table with foreign key to the PERSON table
            
            NSLog(@"Database and tables created.");
        }
        else
        {
            NSLog(@"````Error: %s", error);
        }
    }
    
    
}
-(void)retriveFromSQL
{
    localData=[[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    NSLog(@"Connected fb user id %@",[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]);

    // Check to see if the database file already exists
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    NSString *query = [NSString stringWithFormat:@"select * from GameScoreFinal where PlayerFbId = \"%@\" ORDER BY Level Desc",connectedFBid];
    sqlite3_stmt *stmt=nil;
    if(sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK)
        NSLog(@"error to open");
    
    if (sqlite3_prepare_v2(_databaseHandle, [query UTF8String], -1, &stmt, NULL)== SQLITE_OK)
    {
        NSLog(@"prepared");
    }
    else
        NSLog(@"error");
    // sqlite3_step(stmt);
    @try
    {
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            
            char *level = (char *) sqlite3_column_text(stmt,1);
            char *score = (char *) sqlite3_column_text(stmt,2);
            char *playerFbid = (char *) sqlite3_column_text(stmt,3);
           NSString *strLevel= [NSString  stringWithUTF8String:level];
            
            NSString *strScore  = [NSString stringWithUTF8String:score];
             NSString *playerFBid  = [NSString stringWithUTF8String:playerFbid];
            NSLog(@"player FB ID %@",playerFBid);
            if([playerFBid isEqualToString:@"Master"])
            {
                master=TRUE;
            }
            NSLog(@"Level %@ and Score %@ ",strLevel,strScore);
            NSString * keyLevel=strLevel;
            NSString * keyScore=strScore;
            NSMutableDictionary * temp=[[NSMutableDictionary alloc]init];
            [temp setObject:keyLevel forKey:@"Level"];
            [temp setObject:keyScore forKey:@"Score"];
            [temp setObject:playerFBid forKey:@"PlayerFbID"];
            [localData addObject:temp];
        }
    }
    @catch(NSException *e)
    {
        NSLog(@"%@",e);
    }
    

}
-(void)checkUserLevel
{
    if([GameState sharedState].networkStatus)
    {
        PFQuery * queryUser=[PFQuery queryWithClassName:ParseScoreTableName];
      NSLog(@"Connected fb user id %@",[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]);
        [queryUser whereKey:@"PlayerFacebookID" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]];
        [queryUser selectKeys:@[@"level"]];
        queryUser.limit=1;
        [queryUser orderByDescending:@"level"];
        dispatch_async(dispatch_get_global_queue(0,0),^{
            
            NSArray * temp=[queryUser findObjects];
            if([temp count]>0)
            {
               //----level clear---
                PFObject * objUser=[temp objectAtIndex:0];
                //NSLog(@"User Prvious level in parse %@",objUser[@"level"]);
              
                [[NSUserDefaults standardUserDefaults] setInteger:([objUser[@"level"] intValue]+1)forKey:@"levelClear"];
            }
            else
            {
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"Master"] isEqualToString:@"FirstRun"])
                {
                    
                }
                else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"Master"] isEqualToString:@"FirstRun"])
                {
                    
                }
                PFObject * saveObj=[PFObject objectWithClassName:@"GameScore"];
                saveObj[@"PlayerFacebookID"]=[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
                [saveObj saveInBackgroundWithBlock:^(BOOL success,NSError * error){
                    
                }];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"levelClear"];
            }
            // NSLog(@"User Prvious level in parse %d",[[NSUserDefaults standardUserDefaults]integerForKey:@"levelClear"]);
        });
        
    }
    
}
-(void)synchronize
{
    PFQuery * queryUser=[PFQuery queryWithClassName:ParseScoreTableName];
    NSLog(@"Connected fb user id %@",[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]);
    [queryUser whereKey:@"PlayerFacebookID" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]];
    [queryUser orderByDescending:@"level"];
   dispatch_async(dispatch_get_global_queue(0,0),^{
        NSArray *temp=[queryUser findObjects];
       //if data is present in parse
       if([temp count]>0)
       {
           if([localData count]>[temp count])
           {
               
               for(int i=0;i<[localData count];i++)
               {
                  
                   if(i<[temp count])
                   {
                        PFObject * objUserData=[temp objectAtIndex:i];
                       NSDictionary * temp=[localData objectAtIndex:i];
                       [temp objectForKey:@"Score"];
                       if([objUserData[@"level"] integerValue]==[[temp objectForKey:@"Level"] integerValue])
                       {
                           if([objUserData[@"Score"] integerValue]<[[temp objectForKey:@"Score"] integerValue])
                           {
                               objUserData[@"Score"]=[NSNumber numberWithInt:[[temp objectForKey:@"Score"] intValue]];
                               [objUserData saveInBackground];
                           }//if
                       }//if
                       
                   }
                   else
                   {
                       PFObject * objUserData=[PFObject objectWithClassName:@"GameScore"];
                       //-------------------
                       NSDictionary * localtemp=[localData objectAtIndex:i];
                       ;
                       [localtemp objectForKey:@"Score"];
                       objUserData[@"level"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Level"] intValue]];
                       objUserData[@"Score"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Score"] intValue]];
                       objUserData[@"PlayerFacebookID"]=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
                       //----------------------
                       BOOL result=[objUserData save];
                       NSLog(@"result %d",result);
                   }
 
                }//for
               
           }
           else
           {
           for(int i=0;i<[temp count];i++)
           {
               PFObject * objUserData=[temp objectAtIndex:i];
               for(int j=0;j<[localData count];j++)
               {
                   
                   NSDictionary * temp=[localData objectAtIndex:j];
                   [temp objectForKey:@"Score"];
                   if([objUserData[@"level"] integerValue]==[[temp objectForKey:@"Level"] integerValue])
                   {
                       if([objUserData[@"Score"] integerValue]<[[temp objectForKey:@"Score"] integerValue])
                       {
                            objUserData[@"Score"]=[NSNumber numberWithInt:[[temp objectForKey:@"Score"] intValue]];
                           [objUserData saveInBackground];
                       }//if
                   }//if
                  
               }//for
           }//for
           }//for
           //check highest level
           //if local data there compare.
           if([localData count]>0)
           {
               NSDictionary * localtemp=[localData objectAtIndex:0];
               PFObject * objUserData=[temp objectAtIndex:0];
               if([objUserData[@"level"] integerValue]>
                  [[localtemp objectForKey:@"Level"] integerValue])
               {
                     [[NSUserDefaults standardUserDefaults] setInteger:([objUserData[@"level"] intValue]+1)forKey:@"levelClear"];
               }
               else
               {
                  [[NSUserDefaults standardUserDefaults] setInteger:([[localtemp objectForKey:@"Level"] integerValue]+1)forKey:@"levelClear"];
               }
           }//if
           else
           {//if local data is not there make parse data highest.
                PFObject * objUserData=[temp objectAtIndex:0];
                [[NSUserDefaults standardUserDefaults] setInteger:([objUserData[@"level"] intValue]+1)forKey:@"levelClear"];
           }
           
       }//if
       else
       {
            //if data is not there
           if(master)
           {
               for(int i=0;i<[localData count];i++)
               {
                   PFObject * objUserData=[PFObject objectWithClassName:@"GameScore"];
                   //-------------------
                   NSDictionary * localtemp=[localData objectAtIndex:i];
                   ;
                   [localtemp objectForKey:@"Score"];
                   objUserData[@"level"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Level"] intValue]];
                    objUserData[@"Level"]=[localtemp objectForKey:@"Level"] ;
                   objUserData[@"Score"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Score"] intValue]];
                   objUserData[@"PlayerFacebookID"]=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
                   //----------------------
                   BOOL result=[objUserData save];
                   NSLog(@"result %d",result);
               }
               [self deleteLocalDataBase];
           }
           else
           {
              //if not master
               [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"levelClear"];
           }
    }
  
   });
       NSLog(@"Local Data %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"LocalScoredDictionary"]);
    
}
-(void)deleteLocalDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"-------%@",paths);
    sqlite3_stmt *stmt=nil;
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    
    const char *sql = "Delete from GameScoreFinal";
    
    
    if(sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK)
        NSLog(@"error to open");
    if(sqlite3_prepare_v2(_databaseHandle, sql, -1, &stmt, NULL)!=SQLITE_OK)
    {
        NSLog(@"error to prepare");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
        
        
    }
    if(sqlite3_step(stmt)==SQLITE_DONE)
    {
        NSLog(@"Delete successfully");
    }
    else
    {
        NSLog(@"Delete not successfully");
        
    }
    sqlite3_finalize(stmt);
    sqlite3_close(_databaseHandle);

    
}
-(void)checkFbFriendPlaying
{
    if([GameState sharedState].networkStatus)
    {
        
        PFQuery * query=[PFQuery queryWithClassName:@"GameScore"];
        NSArray *friendArr=[[NSUserDefaults standardUserDefaults]objectForKey:FacebookGameFrindes];
        [query whereKey:@"PlayerFacebookID" containedIn:friendArr];
        [query orderByDescending:@"level"];
        dispatch_async(dispatch_get_global_queue(0,0),^{
            NSArray * temp=[query findObjects];
            NSLog(@"Facebook Friends on that level %@",temp);
            dispatch_async(dispatch_get_main_queue(),^(void) {
                
                if([temp count]>0)
                {
                    [GameState sharedState].screenForPlay=TRUE;
                    
                }
                else
                {
                    [GameState sharedState].screenForPlay=FALSE;
                    
                }
                
                
            });
            
        });
    }
}

@end

