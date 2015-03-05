//
//  PurchaseArrowScene.m
//  BowHunting
//
//  Created by GBS-ios on 7/18/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "PurchaseArrowScene.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "GameOver.h"
#import "GameState.h"
#import "AdMobViewController.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import <CommonCrypto/CommonDigest.h>
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"
@implementation PurchaseArrowScene
- (id)init {
    if ((self = [super init])) {
        
        layer = [[PurchaseArrowLayer alloc] init] ;
        [self addChild:layer];
    }
    return self;
}

-(id) initWithGameMain:(GameMain *)gameMain{
    if ((self = [super init])) {
        
        layer = [[PurchaseArrowLayer alloc] initWithGameMain:gameMain];
        [self addChild:layer];
    }
    return self;
}
@end


@implementation PurchaseArrowLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PurchaseArrowLayer *layer = [PurchaseArrowLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)initWithGameMain:(GameMain *)gameMain{
    
    if ([super init]) {
        CGSize ws = [CCDirector sharedDirector].winSize;
        
        NSLog(@"remain time = %d",gameMain.theTime);
        
//        AdMobViewController *adm = [[AdMobViewController alloc]init];
//        bannerView = adm.view;
//        [[[CCDirector sharedDirector] openGLView] addSubview:bannerView];
        
        [self chartBoostVideo];
        //-------------------
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareOnFacebookForRefill) name:@"Refill" object:nil];
        //---------------
        self.purchaseGameMain = gameMain;
        //[gameMain release];
        CCSprite *sky=[CCSprite spriteWithFile:@"bg_purchase.png"];
        sky.position=ccp(ws.width/2,ws.height/2);
        
        [self addChild:sky];
        
        
        CCSprite *out_arr=[CCSprite spriteWithFile:@"outof_purchase.png"];
        //avaarrows.scaleY = 0.3;
        out_arr.anchorPoint=ccp(0,0);
        out_arr.position=ccp(ws.width/2-80, ws.height/2+50);
        [sky addChild:out_arr];
        
        CCSprite *avaarrows=[CCSprite spriteWithFile:@"getmorearrow_purchase.png"];
        //avaarrows.scaleY = 0.3;
        avaarrows.anchorPoint=ccp(0,0);
        avaarrows.position=ccp(ws.width/2-90, ws.height/2+30);
        [sky addChild:avaarrows];
        
        
        CCMenuItemImage *invite = [CCMenuItemImage itemWithNormalImage:@"refill_arrows.png" selectedImage:@"refill_arrows.png" target:self selector:@selector(refillArrows)];
        CCMenuItemImage *tweet = [CCMenuItemImage itemWithNormalImage:@"tweet_purchase.png" selectedImage:@"tweet_purchase.png" target:self selector:@selector(tweetAction)];
        CCMenuItemImage *purchase = [CCMenuItemImage itemWithNormalImage:@"purchase_purchase.png" selectedImage:@"purchase_purchase.png" target:self selector:@selector(purchaseAction)];
        CCMenuItemImage *giveup = [CCMenuItemImage itemWithNormalImage:@"giveup_purchase.png" selectedImage:@"giveup_purchase.png" target:self selector:@selector(giveupActionInPurchase)];
        
        CCMenu *purchaseMenu = [CCMenu menuWithItems:invite,tweet,purchase,giveup, nil];
        purchaseMenu.position = ccp(ws.width/2, ws.height/2-50);
        //[purchaseMenu alignItemsVerticallyWithPadding:5];
        [purchaseMenu alignItemsVertically];
        
        [sky addChild:purchaseMenu];
    }
    
    return self;
}
-(id)init{
    
    if ([super init]) {
        
        CGSize ws = [CCDirector sharedDirector].winSize;
        
        
        CCSprite *sky=[CCSprite spriteWithFile:@"gameOverSky.png"];
        sky.position=ccp(ws.width/2,ws.height/2);
        
        [self addChild:sky];
        
        CCLabelBMFont *out_of_arrow=[CCLabelBMFont labelWithString:@"out of arrows!" fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
        out_of_arrow.position=ccp(ws.width/2, ws.height/2+110);
        [sky addChild:out_of_arrow];
        
        
        CCLabelTTF *lttf = [CCLabelTTF labelWithString:@"get more arrows and complete the level" fontName:@"arial" fontSize:15];
        lttf.position =ccp(ws.width/2, ws.height/2+80);
        lttf.color = ccBLACK;
        [sky addChild:lttf];
        
        
        CCMenuItem *invite_frnds = [CCMenuItemFont itemWithString:@"Invite Friends" target:self selector:@selector(shareOnFacebook)];
        
        CCMenuItem *tweet = [CCMenuItemFont itemWithString:@"Tweet" target:self selector:@selector(tweetAction)];
        
        CCMenuItem *purchase = [CCMenuItemFont itemWithString:@"Purchase" target:self selector:@selector(purchaseAction)];
        
        CCMenuItem *giveup = [CCMenuItemFont itemWithString:@"Giveup" target:self selector:@selector(giveupActionInPurchase)];
        
        CCMenu *menu = [CCMenu menuWithItems:invite_frnds,tweet,purchase,giveup, nil];
        [menu alignItemsVerticallyWithPadding:2];
        menu.position = ccp(ws.width/2, ws.height/2-50);
        
        [sky addChild:menu];
        
        
        
    }
    [self.purchaseGameMain removeChild:self.purchaseGameMain.spriteWinLoose cleanup:YES];
    return self;
}
-(void)actionResume:(id)sender{
    [[CCDirector sharedDirector] popScene];
}

#pragma mark -
-(void) gotoFriendsView{
    
//    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
//    appDelegate.delegate = nil;
//    RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
//    CGRect frame = [UIScreen mainScreen].bounds;
//    NSLog(@"Frame Height==%f",frame.size.height);
//    NSLog(@"Frame width==%f",frame.size.width);
//    
//    if (!self.fbFrnds) {
//        self.fbFrnds = [[[FriendsViewController alloc] initWithHeaderTitle:@"Invite Friends"] autorelease];
//    }
//    else{
//        [self.fbFrnds updateFriendsView];
//    }
//    self.fbFrnds.delegate =self;
//    NSArray *frndsListArray = [[NSUserDefaults standardUserDefaults] objectForKey:FacebookInviteFriends];
//    self.fbFrnds.isLifeRequest = NO;
//    NSLog(@"frnds = %@",frndsListArray);
//    self.fbFrnds.friendListArray = [NSArray arrayWithArray:frndsListArray];
//    self.fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);
//    
//    //fbFrnds.headerTitle = @"Ask Life";
//
//        
//        self.fbFrnds.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        [viewCntrler presentViewController:self.fbFrnds animated:YES completion:nil];
//       
//
//}


AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
appDelegate.delegate = nil;
RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
CGRect frame = [UIScreen mainScreen].bounds;
if (!self.fbFrnds) {
    self.fbFrnds = [[[FriendsViewController alloc] initWithHeaderTitle:@"Invite Friends"] autorelease];
    [self.fbFrnds updateFriendsView];
    //WithNibName:@"FriendsViewController" bundle:nil];
}
else{
    [self.fbFrnds updateFriendsView];
}
self.fbFrnds.delegate =self;
NSArray *frndsListArray = [[NSUserDefaults standardUserDefaults] objectForKey:FacebookInviteFriends];
NSLog(@"frnds = %@",frndsListArray);
self.fbFrnds.friendListArray = [NSArray arrayWithArray:frndsListArray];
self.fbFrnds.isLifeRequest = NO;
self.fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);

//fbFrnds.headerTitle = @"Ask Life";
[UIView animateWithDuration:1 animations:^{
    
    self.fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    [viewCntrler presentViewController:self.fbFrnds animated:YES completion:nil];
    //[viewCntrler.view addSubview:fbFrnds.view];
}];
}

#pragma mark -

-(void)inviteFriendsActionInPurchase
{
    [bannerView removeFromSuperview];
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.openGraphDict = nil;
    	//[[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object:nil];
    
    BOOL check = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    
    if (check == NO) {
        [appDelegate openSessionWithLoginUI:8 withParams:nil];
        appDelegate.delegate = self;
    }
    else{
        [self gotoFriendsView];
    }
   
    /*NSLog(@"Invite Facebook Friends");
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"Invitation"], @"message", nil];
    NSString *lifeReq = [jsonWriter stringWithObject:challenge];
    
    
    // Create a dictionary of key/value pairs which are the parameters of the dialog
    
    // 1. No additional parameters provided - enables generic Multi-friend selector
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:lifeReq, @"data",@"invite friends",@"Title",@"Invite Friends",@"message",nil];
    
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
    appDelegate.openGraphDict = nil;
    if (FBSession.activeSession.isOpen) {
        
        [appDelegate sendRequestToFriends:params];
    }
    else{
        [appDelegate openSessionWithLoginUI:2 withParams:params];
    }
    */
}
-(void)refillArrows
{

    [GameState sharedState].shareDecide=@"arrow";
    if(![GameState sharedState].shareOnfb)
    {
         [GameState sharedState].shareOnfb=TRUE;
        [Chartboost showInterstitial:CBLocationHomeScreen];
       
       
  
    }
}
-(void) shareOnFacebookForRefill
{
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object:nil];
    
    NSString *strPostMessage = [NSString stringWithFormat:@"Hi Friends, Please join me in Bow Hunting Chief. Select your arrows and hunt as many birds as you can and get more points. Lets see who is the best hunter amongst us!"];
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     strPostMessage, @"description",
     @"https://itunes.apple.com/us/app/bow-hunting-chief/id853508979?ls=1&mt=8", @"link",@"Bow Hunting Chief",@"name",
     @"http://i.imgur.com/LaDdDX0.png?1",@"picture",
     nil];

    BOOL networkStatus =[GameState sharedState].networkStatus; //[[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
     //   return;
    }
    else
    {
    NSLog(@"Share on facebook");
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
        BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
        if(fbCheck)
        {

            if (FBSession.activeSession.isOpen)
            {
            [appDelegate shareOnFacebook];
            }
            else
            {
            [appDelegate openSessionWithLoginUI:3 withParams:params];
            }
        }
        else
        {
            [appDelegate shareOnFacebook];  
        }
        
    }
    
}

-(void) tweetAction
{
    	[[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object:nil];
    BOOL networkStatus = [GameState sharedState].networkStatus;//[[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
     //   return;
    }
    
    else
    {
        NSLog(@"Tweet on Tweeter");
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
    [appDelegate twitterAuthorization];
    }
    
}
-(void) purchaseAction{
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object:nil];
    BOOL networkStatus = [GameState sharedState].networkStatus;//[[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
     //   return;
    }
    else
    {
    NSLog(@"Purchase");
    //[self.purchaseGameMain resumeGameWithArrowPurchase];
    AppController *appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
    [appDelegate fullPackArwAction:nil];
    }
}
-(void) giveupActionInPurchase{
    NSLog(@"Give Up");
    
    [self actionResume:nil];

    [self.purchaseGameMain levelFailedSceneDisplay];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Refill" object:nil];
   
}
-(void)chartBoostVideo
{
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object:nil];
    BOOL networkStatus = [GameState sharedState].networkStatus;//[[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    if(networkStatus==YES)
    {

    [Chartboost showRewardedVideo:CBLocationStartup];
    
        AppController *appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
    }
}
#pragma mark -
-(void) updateAfterRequestSent:(BOOL)value{
    
    if (value == YES)
    {
        NSLog(@"Update");
        NSLog(@"In Purchase");
         
        [self.purchaseGameMain resumeGameWithArrowPurchase];
        
        [self actionResume:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Refill" object:nil];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Process not completed" message:@"Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}
-(void) updatePurchaseScene:(BOOL)value{
   
    if (value == YES)
    {
        NSLog(@"Update");
        NSLog(@"In Purchase");
        [self.purchaseGameMain resumeGameWithArrowPurchase];
        
        [self actionResume:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Refill" object:nil];

    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Process not completed" message:@"Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}
- (void)didCompleteRewardedVideo:(CBLocation)location
withReward:(int)reward
{
    
}
- (void)didCloseRewardedVideo:(CBLocation)location
{
    
}
@end