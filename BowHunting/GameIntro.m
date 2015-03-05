//
//  GameIntro.m
//  BowHunting
//
//  Created by tang on 12-9-29.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "GameIntro.h"
#import "cocos2d.h"
#import "GameMain.h"
#import "SimpleAudioEngine.h"
#import "BowHuntingTitle.h"
#import "LevelSelectionScene.h"
#import "FriendsInLevel.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "AdMobViewController.h"
#import <GADBannerView.h>
#import <GADRequest.h>
#import <Parse/Parse.h>
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

CGSize ws;
@implementation GameIntro

@synthesize clouds,skyBG,bird,playMI,playButton,musicIsOn,flyArr,bht,storeMI;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameIntro *layer = [GameIntro node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init]))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object:nil];
        
        BOOL networkStatus = [GameState sharedState].networkStatus;
        if(!(networkStatus==NO))
        {
            if(!adm)
            {
                adm= [[AdMobViewController alloc]initWithBOOL:YES];
                [GameState sharedState].bannerAddView =adm.view;
                [[[CCDirector sharedDirector] view] addSubview:adm.view];
            }
        }
        else
        {
            [GameState sharedState].failToLoadBanner=YES;
        }
        
       // [Chartboost showInterstitial:CBLocationHomeScreen];
            //
//        RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
//        [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
//            NSLog(@"show Ad");
//            [fs showAd];
//            //NSLog(@"Ad loaded Revmob");
//            [[CCDirector sharedDirector] pause];
//        } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
//            NSLog(@"Ad error Revmob: %@",error);
//        } onClickHandler:^{
//            //NSLog(@"Ad clicked Revmob");
//        } onCloseHandler:^{
//            //NSLog(@"Ad closed Revmob");
//            [[CCDirector sharedDirector] resume];
//        }];

        //sleep(2);
        
        self.musicIsOn=YES;
        ws=[[CCDirector sharedDirector]winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
        if ([UIScreen mainScreen].scale == 2.f) {
           // NSLog(@"iPad....");
             skyBG=[CCSprite spriteWithFile:@"sky-568h@2x.jpg"];
        }
//        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
//            
//           if ([UIScreen mainScreen].bounds.size.height>500) {
//               
//                skyBG=[CCSprite spriteWithFile:@"sky-568h@2x.jpg"];
//           }
           else{
                skyBG=[CCSprite spriteWithFile:@"sky.png"];
            }
        
//        }
//        else{
//            skyBG=[CCSprite spriteWithFile:@"sky_iPad@2x.jpg"];
//        }
        
        skyBG.position=ccp(ws.width*0.5,ws.height*0.5);
        
        [self addChild:skyBG];
        
        //add clouds clip
        
        clouds=[[Clouds alloc]init];
        clouds.position=ccp(0,ws.height);
        [self addChild:clouds];
        
        bird=[[CCSprite alloc]init];
        
        bird.position=ccp(ws.width*0.5,ws.height*0.6);
        
        self.flyArr=[NSMutableArray array];
        
        for (int i=1; i<=30; i++) {
            
            NSString *flySpriteStr;
            if(i<10){
                flySpriteStr=[NSString stringWithFormat:@"birdFly000%i.png",i];
                
            }else{
                flySpriteStr=[NSString stringWithFormat:@"birdFly00%i.png",i];
            }
            id flySprite=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:flySpriteStr];
            [self.flyArr addObject:flySprite];
        }
        
        id animObj=[CCAnimation animationWithSpriteFrames:flyArr delay:0.05];
        
        id flyMovie=[CCAnimate actionWithAnimation:animObj];
        
        id rp=[CCRepeatForever actionWithAction:flyMovie];
        
        [bird runAction:rp];
        
        bird.scaleX=-1.4;
        bird.scaleY=1.4;
        [self addChild:bird];
        
        self.playMI=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn_play.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn_play2.png"] target:self selector:@selector(playButtonClicked)];
        self.playButton=[CCMenu menuWithItems:self.playMI, nil];
        
        self.playButton.position=ccp(ws.width*0.3,115);
        
        [self addChild:self.playButton];
        
        // Rajeev
        
        self.storeMI=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"storenew.png"] selectedSprite:[CCSprite spriteWithFile:@"storenew.png"] target:self selector:@selector(storeButnClick:)];
        
        CCMenu *menu6 = [CCMenu menuWithItems:self.storeMI, nil];
        menu6.position=ccp(ws.width*0.6,115);
        [self addChild:menu6];
        
//=========================================================================
        
        //preload sounds
        
        if (self.musicIsOn) {
            [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"snd_bg.wav"];
            
        }
                
        if(self.musicIsOn){
            [self schedule:@selector(playBGM) interval:0.5];
        }
        //preload sounds
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"geese1.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"geese2.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"geese3.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"geese_die1.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"geese_die2.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"snd_info.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"snd_game_over.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"snd_yeah.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"snd_move.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"snd_btn.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"snd_grass.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"over_control.wav"];
        
        self.bht=[[BowHuntingTitle alloc]init];
        self.bht.position=ccp(60,ws.height-50);
        [self addChild:self.bht];
        
        //---------------------------------------
        //Connect with Facebook
        
        
       BOOL FBConnected = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
        if (FBConnected==NO)
        {
            self.connectWithFB=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"connectFb.png"] selectedSprite:[CCSprite spriteWithFile:@"connectFb.png"] target:self selector:@selector(connectwithFacebook:)];
            
            self.connectWithFB=[CCMenu menuWithItems:self.connectWithFB, nil];
            self.connectWithFB.position=ccp(ws.width*0.5,70);
            [self addChild:self.connectWithFB];
        }
        else
        {
            self.connectWithFB=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"logoutFb.png"] selectedSprite:[CCSprite spriteWithFile:@"logoutFb.png"] target:self selector:@selector(logOutFacebook:)];
            
            self.connectWithFB=[CCMenu menuWithItems:self.connectWithFB, nil];
            self.connectWithFB.position=ccp(ws.width*0.5,70);
            [self addChild:self.connectWithFB];
   
        }
               appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
        a = 0;
    }
    return self;
}

#pragma mark-
-(void)connectwithFacebook:(id)sender{
    
    //NSLog(@"connect with facebook button clicked.");
    
   
    self.connectWithFB.visible=NO;
    
    //[appDelegate openSessionWithAllowLoginUI:1];
    [appDelegate openSessionWithLoginUI:8 withParams:nil];
  //  [self switchButton:@"logout"];
   
}
-(void)switchButton:(NSString*)buttonType
{
   self.connectWithFB.visible = NO;
    if ([buttonType isEqualToString:@"login"])
    {
        self.connectWithFB=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"connectFb.png"] selectedSprite:[CCSprite spriteWithFile:@"connectFb.png"] target:self selector:@selector(connectwithFacebook:)];
        
        self.connectWithFB=[CCMenu menuWithItems:self.connectWithFB, nil];
        self.connectWithFB.position=ccp(ws.width*0.5,70);
        [self addChild:self.connectWithFB];
    }
    else
    {
        self.connectWithFB=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"logoutFb.png"] selectedSprite:[CCSprite spriteWithFile:@"logoutFb.png"] target:self selector:@selector(logOutFacebook:)];
        
        self.connectWithFB=[CCMenu menuWithItems:self.connectWithFB, nil];
        self.connectWithFB.position=ccp(ws.width*0.5,70);
        [self addChild:self.connectWithFB];
        
    }
}
-(void)logOutFacebook:(id)sender
{
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FacebookConnected];
    [[NSUserDefaults standardUserDefaults] synchronize];
     [self switchButton:@"login"];
    
}


#pragma mark -
-(void)storeButnClick:(id)sender {
   // [viewHost1 removeFromSuperview];
    [[GameState sharedState].bannerAddView removeFromSuperview];
    BOOL networkStatus = [GameState sharedState].networkStatus;
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }

    /*
    RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    FriendsViewController *fbFrnds = [[FriendsViewController alloc] initWithHeaderTitle:@"Ask Life"];//WithNibName:@"FriendsViewController" bundle:nil];
    fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);;
    
    //fbFrnds.headerTitle = @"Ask Life";
    [UIView animateWithDuration:1 animations:^{
        
        fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewCntrler presentViewController:fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];
    //[self displayArrowPurchaseSprite];
   return;
    */
    if(!self.storeLayer){
        self.storeLayer=[[[Store alloc]init] autorelease];
        [self addChild:self.storeLayer];
    }
    else{
        ((Store*)self.storeLayer).visible=YES;
    }
}
-(void) displayArrowPurchaseSprite{
    
    
    CCSprite *sky=[CCSprite spriteWithFile:@"score_bg5.png"];
    sky.position=ccp(ws.width/2,ws.height/2);
    
    [self addChild:sky];
    
    
    CCSprite *out_arr=[CCSprite spriteWithFile:@"outof_purchase.png"];
    //avaarrows.scaleY = 0.3;
    out_arr.anchorPoint=ccp(0,0);
    out_arr.position=ccp(ws.width/2-80, ws.height/2+50);
    [self addChild:out_arr];
    
    CCSprite *avaarrows=[CCSprite spriteWithFile:@"getmorearrow_purchase.png"];
    //avaarrows.scaleY = 0.3;
    avaarrows.anchorPoint=ccp(0,0);
    avaarrows.position=ccp(ws.width/2-90, ws.height/2+30);
    [self addChild:avaarrows];
    
    
    CCMenuItemImage *invite = [CCMenuItemImage itemWithNormalImage:@"invite_purchase.png" selectedImage:@"invite_purchase.png" target:self selector:@selector(inviteFriendsAction)];
    CCMenuItemImage *tweet = [CCMenuItemImage itemWithNormalImage:@"tweet_purchase.png" selectedImage:@"tweet_purchase.png" target:self selector:@selector(tweetAction)];
    CCMenuItemImage *purchase = [CCMenuItemImage itemWithNormalImage:@"purchase_purchase.png" selectedImage:@"purchase_purchase.png" target:self selector:@selector(purchaseAction)];
    CCMenuItemImage *giveup = [CCMenuItemImage itemWithNormalImage:@"giveup_purchase.png" selectedImage:@"giveup_purchase.png" target:self selector:@selector(giveupAction)];
    
    CCMenu *purchaseMenu = [CCMenu menuWithItems:invite,tweet,purchase,giveup, nil];
    purchaseMenu.position = ccp(ws.width/2, ws.height/2-50);
    //[purchaseMenu alignItemsVerticallyWithPadding:5];
    [purchaseMenu alignItemsVertically];
    
    [self addChild:purchaseMenu];
        
    
}


-(void)back:(id)sender {
    
    skyBG.visible = YES;
    clouds.visible = YES;
    bird.visible = YES;
    self.playButton.visible=YES;
    self.storeMI.visible=YES;
    self.bht.visible=YES;
}

//play background music
-(void)playBGM{
    [self unschedule:@selector(playBGM)];
    
    if(self.musicIsOn){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"snd_bg.wav" loop:YES];
    }
}
//play button clicked handler

-(void) playButtonClicked{
    [self stop];
    
    //[viewHost1 removeFromSuperview];
    //show game main
    
//    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene:self.musicIsOn]]];
   //  FriendsInLevel * frObj=[[FriendsInLevel alloc]init];
    
   // LevelSelectionScene *obj = [[[LevelSelectionScene alloc]init:self.musicIsOn] autorelease];
    //[[GameState sharedState].bannerAddView removeFromSuperview];
    BOOL fbConnected=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
    if(fbConnected)
    {
        if([GameState sharedState].screenForPlay)
        {
            if(!friendLevel)
            {
                friendLevel=[FriendsInLevel alloc];
                friendLevel.musicIsOn=YES;
                
                [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.8 scene:[FriendsInLevel scene]]];
            }
           
        }
        else
        {
            if(!levelObj)
            {
            levelObj= [[LevelSelectionScene alloc]init:self.musicIsOn];
            [self addChild:levelObj];
            }
        }
        }
    else
    {
        if(!levelObj)
        {
            levelObj = [[LevelSelectionScene alloc]init:self.musicIsOn];
            [self addChild:levelObj];
        }
        
    }

    
    //[self addChild:obj];
    
}

//stop actions

-(void)stop{
    [self.bht stop];
    [self.bird stopAllActions];
    [self.clouds stop];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}

#pragma mark -

-(void) inviteFriendsAction{
    BOOL networkStatus = [GameState sharedState].networkStatus;
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    if (a == 0) {
        [appDelegate openSessionWithLoginUI:8 withParams:nil];
        a = 1;
    }
    else{
        NSString *title = [NSString stringWithFormat:@"new highscore 135640"];
        NSString *description = [NSString stringWithFormat:@"hey i got new highscore 135640 in level 2!"];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"highscore",FacebookType,title,FacebookTitle,description,FacebookDescription,@"get",FacebookActionType, nil];
        
        
        appDelegate.openGraphDict = dict;
        [appDelegate storyPostwithDictionary:dict];
    }
    
    
    
   
    
    /*
    NSLog(@"Invite Facebook Friends");
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"Invitation"], @"message", nil];
    NSString *lifeReq = [jsonWriter stringWithObject:challenge];
    
    
    // Create a dictionary of key/value pairs which are the parameters of the dialog
    
    // 1. No additional parameters provided - enables generic Multi-friend selector
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:lifeReq, @"data",nil];
    
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    
    if (FBSession.activeSession.isOpen) {
        
        [appDelegate sendRequestToFriends:params];
    }
    else{
        [appDelegate openSessionWithLoginUI:2 withParams:params];
    }
    */
    
}



-(void) tweetAction{
    BOOL networkStatus = [GameState sharedState].networkStatus;
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    NSLog(@"Tweet on Tweeter");
    /*
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
    [appDelegate twitterAuthorization];*/
    NSString *title = [NSString stringWithFormat:@"beat Sukhmeet Singh"];
    NSString *description = [NSString stringWithFormat:@"%@ at level 2 and got score 135640!",title];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"friend",FacebookType,title,FacebookTitle,description,FacebookDescription,@"beat",FacebookActionType, nil];
    
    appDelegate.openGraphDict = dict;
    [appDelegate storyPostwithDictionary:dict];
}
-(void) purchaseAction{
    BOOL networkStatus = [GameState sharedState].networkStatus;
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    NSLog(@"Purchase");
    
    NSString *title = [NSString stringWithFormat:@"i sent extra life to Sukhmeet Singh"];
    NSString *des = [NSString stringWithFormat:@"Now Sukhmeet Singh has one extra life gifted by Avinash kashyap"];
    NSDictionary *storyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"life",FacebookType,title,FacebookTitle,des,FacebookDescription,@"send",FacebookActionType, nil];
    appDelegate.openGraphDict = storyDict;
    [appDelegate storyPostwithDictionary:storyDict];
}
-(void) giveupAction{
    NSLog(@"Give Up");
    NSString *title = [NSString stringWithFormat:@"Thank you Sukhmeet Singh for extra life"];
    NSString *description = [NSString stringWithFormat:@"Avinash kashyap got one extra life gifted by Sukhmeet Singh"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"life",FacebookType,title,FacebookTitle,description,FacebookDescription,@"say",FacebookActionType, nil];
    [appDelegate storyPostwithDictionary:dict];
}

-(void) first{
    
}
-(void) second{
    
}
-(void) updateAfterRequestSent:(BOOL)value{
    if (value==YES) {
        NSLog(@"Update");
        
    }
    else{
        NSLog(@"Not");
    }
}
@end
