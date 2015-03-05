//
//  HelloWorldLayer.m
//  BowHunting
//
//  Created by tang on 12-9-24.
//  Copyright tang 2012年. All rights reserved.
//


// Import the interfaces
#import "GameMain.h"
#import "GameOver.h"
#import "Clouds.h"
#import "GameIntro.h"
#import "Clouds.h"
#import "BowArrow.h"
#import "Bird.h"
#import "SwitchButton.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "GamePauseScene.h"
#import "ccTypes.h"
#import "GameState.h"
#import "LifeOver.h"
#import "CCAction.h"
#import "CCActionInterval.h"
#import "PurchaseArrowScene.h"
#import "AdMobViewController.h"
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"
#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation

CGSize ws;
@implementation GameMain
@synthesize skyBG,sun,ground2,ground1,clouds,br,gameUICMC,scoreMC,timeMC,birdCMC,num_arrows,currentSpeed,speedPlus,birdsArr,musicIsOn,pauseBtn;
@synthesize num_objects,timeText,scoreText,musicBtn,currentArrow,arrowsArr,infoText,shootAble,birdsAreCreated,birdsShootedNum,score,theTime,limitTime,gameOverLayer,lifeText,levelText,viewController,lifeOverLayer,spriteWinLoose,powerBoosterBtn,multipleArrowBtn, arrArrows,avalibleArrowsLabel;
@synthesize currentLevel;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.

+(CCScene *) scene:(BOOL)gbmIsOn
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameMain *layer = [[GameMain alloc]initWithBOOL:gbmIsOn];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) initWithBOOL:(BOOL)bgmIsOn
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        [[GameState sharedState].bannerAddView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object:nil];
        
      /*  BOOL networkStatus = [GameState sharedState].networkStatus;
        if(!(networkStatus==NO))
        {
            if(!adm)
            {
                adm= [[AdMobViewController alloc]initWithBOOL:NO];
                [GameState sharedState].bannerAddView =adm.view;
                [[[CCDirector sharedDirector] view] addSubview:adm.view];
            }
        }
        else
        {*/
            //[GameState sharedState].failToLoadBanner=YES;
        //}
        
        userDefault=[NSUserDefaults standardUserDefaults];
        gameOverBannerCheck=NO;
        
        self.musicIsOn=bgmIsOn;
        self.isTouchEnabled=YES;
        
		ws=[[CCDirector sharedDirector]winSize];
        arrTrees = [[NSMutableArray alloc] init];
        
        /////////////
        self.birdsAreCreated=NO;
//        self.currentSpeed=1.0f;
//        self.speedPlus=0.1f;
        self.num_objects=8;
//        self.limitTime=120;
        self.limitTime=120;
        // Code for Background Images
        
        self.skyBG=[CCSprite spriteWithFile:@"sky.png"];
        self.skyBG.position=ccp(ws.width/2,ws.height/2);
        [self addChild:self.skyBG];
        
        self.sun=[CCSprite spriteWithSpriteFrameName:@"sun.png"];
        self.sun.position=ccp(100,ws.height-60);
        [self addChild:self.sun];
        
        self.clouds=[[Clouds alloc]init] ;
        self.clouds.position=ccp(0,ws.height);
        [self addChild:self.clouds];
        
        self.ground2=[CCSprite spriteWithFile:@"ground2.png"];
        self.ground2.anchorPoint=ccp(0.5,0);
        self.ground2.position=ccp(ws.width/2,46);
        [self addChild: self.ground2];
        
        self.birdCMC=[[CCSprite alloc]init] ;
        [self addChild:self.birdCMC];
        
        self.ground1=[CCSprite spriteWithFile:@"ground1.png"];
        self.ground1.anchorPoint=ccp(0.5,0);
        self.ground1.position=ccp(ws.width/2,0);
        [self addChild: self.ground1];
        
        self.br=[[BowArrow alloc]init] ;
        self.br.rotation=-90;
        self.br.position=ccp(ws.width/2,0);
        self.br.scale=1.0;
        [self addChild:self.br];
        
        self.gameUICMC=[[CCSprite alloc]init] ;
        
        [self addChild:self.gameUICMC];
        
        self.musicBtn=[[SwitchButton alloc]init] ;
        [self.musicBtn initWithImageStr:@"musicOn1.png" O2:@"musicOn2.png" O3:@"musicOff1.png" O4:@"musicOff2.png" Open:self.musicIsOn];
        
        self.timeMC=[[CCSprite alloc]init];
        
        [self.gameUICMC addChild:self.timeMC];
        CCSprite *timeIMG=[CCSprite spriteWithSpriteFrameName:@"time.png"];
        timeIMG.anchorPoint=ccp(0,1);
         timeIMG.position=ccp(4,ws.height-11);
       // timeIMG.position=ccp(4,ws.height-42);
        [self.timeMC addChild:timeIMG];
        
        //Rajeev
        
        self.arrArrows=[[NSMutableArray alloc]init];
      
        self.pauseBtn=[CCMenuItemImage itemWithNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(pauseBtnClicked:)];
        
        CCMenu *menu = [CCMenu menuWithItems:self.pauseBtn, nil];
        menu.position = ccp(ws.width-25,60);
        [menu alignItemsVertically];
        [self addChild:menu];
        
        self.timeText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i",self.limitTime] fntFile:@"BerlinSansFBDemi45FFFFFF.fnt"];
        self.timeText.anchorPoint=ccp(0,1);
        self.timeText.position=ccp(64,ws.height-15);
       // self.timeText.position=ccp(64,ws.height-45);
       /* if([GameState sharedState].failToLoadBanner)
        {
            timeIMG.position=ccp(4,ws.height-11);
            self.timeText.position=ccp(64,ws.height-15);
 
        }*/
        [self.timeMC addChild:self.timeText];
   // ==================================================================================================
        
        
        // Code for Power Booster Arrows
        
        wrapperMultiArrows = [[KeychainItemWrapper alloc] initWithIdentifier:@"powerboosters" accessGroup:nil];
        
        NSString *numpowerBooster = [wrapperMultiArrows objectForKey:(__bridge id)kSecAttrAccount];
        NSLog(@"number of power booster %@",numpowerBooster);
        int retrievedBoosterArrows = [numpowerBooster intValue];
        //NSLog(@"Multiple arrow before reset -==- %d",retrievedMultiArrows);
        int userDefBoosterArrow=(int)[userDefault integerForKey:@"BoosterArrows"];
        int totalBoosterarrows=retrievedBoosterArrows+userDefBoosterArrow;
        NSLog(@"Power Booster arrow before reset -==- %d",retrievedBoosterArrows);
        
        
            self.powerBoosterBtn=[CCMenuItemImage itemWithNormalImage:@"multiplearrow.png" selectedImage:@"multiplearrow.png" target:self selector:@selector(powerBoosterBtnAction:)];
            
            self.menuPowerBooster = [CCMenu menuWithItems:self.powerBoosterBtn, nil];
            self.menuPowerBooster.position=ccp(ws.width-140, 30);
            [self addChild:self.menuPowerBooster];
            
            self.powerBoosterArrowCount=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i x",totalBoosterarrows] fntFile:@"BerlinSansFBDemi45FFFFFF.fnt"];
            
            self.powerBoosterArrowCount.position=ccp(ws.width-180, 30);
            [self addChild:self.powerBoosterArrowCount];
//        if (retrievednumpowerBoosterArrows>0) {
//            menuPowerBooster.enabled = YES;
//        }
//        else{
//            menuPowerBooster.enabled = NO;
//        }
        
        // =======================================================================================
        
        // Code for Multi Arrows
        
        
               self.multipleArrowBtn=[CCMenuItemImage itemWithNormalImage:@"muti arrow icon.png" selectedImage:@"muti arrow icon.png" target:self selector:@selector(multipleArrowBtnAction:)];
        //////////////////////
        NSString *numHints = [wrapperMultiArrows objectForKey:(__bridge id)kSecValueData];
        
        int retrievedMultiArrows = [numHints intValue];
        //NSLog(@"Multiple arrow before reset -==- %d",retrievedMultiArrows);
        int userDefMultiArrow=(int)[userDefault integerForKey:@"MultiArrows"];
        int totalmultiarrows=retrievedMultiArrows+userDefMultiArrow;

        
        ////////////////////////////
               self.menuMultipleArrow =[CCMenu menuWithItems:self.multipleArrowBtn, nil];
               self.menuMultipleArrow.position=ccp(ws.width-70, 30);
               [self addChild:self.menuMultipleArrow];
               
               self.multipleArrowCount=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i x",totalmultiarrows] fntFile:@"BerlinSansFBDemi45FFFFFF.fnt"];
               
               self.multipleArrowCount.position=ccp(ws.width-110, 30);
        
               [self addChild:self.multipleArrowCount];
        
        
//        if (retrievedMultiArrows>0) {
//            menuMultipleArrow.enabled = YES;
//        }
//        else{
//            menuMultipleArrow.enabled = NO;
//        }
        
        //Rajeev
        
        self.scoreMC=[[CCSprite alloc]init] ;
        [self.gameUICMC addChild:self.scoreMC];
        CCSprite *scoreIMG=[CCSprite spriteWithSpriteFrameName:@"score.png"];
        scoreIMG.anchorPoint=ccp(0,0);
        scoreIMG.position=ccp(4,10);
        [self.scoreMC addChild:scoreIMG];
        
        self.score = (int)[userDefault integerForKey:@"score"];
       // NSLog(@"Level at starting -==- %d",self.score);
        
        self.scoreText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",self.score] fntFile:@"BerlinSansFBDemi45FFFFFF.fnt"];
        
        self.scoreText.anchorPoint=ccp(0,0);
        self.scoreText.position=ccp(64,10);
        [self.scoreMC addChild:self.scoreText];
        //=========================
        self.availableArrowMC=[[CCSprite alloc]init] ;
        [self.gameUICMC addChild:self.availableArrowMC];
        CCSprite *avaarrows=[CCSprite spriteWithFile:@"arrows.png"];
        //avaarrows.scaleY = 0.3;
        //avaarrows.scale = 0.7;
        avaarrows.anchorPoint=ccp(0,0);
        avaarrows.position=ccp(4,40);
        [self.availableArrowMC addChild:avaarrows];
        
        self.avalible_arrows = 0;
        self.avalibleArrowsLabel=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",self.avalible_arrows] fntFile:@"BerlinSansFBDemi45FFFFFF.fnt"];
        self.avalibleArrowsLabel.anchorPoint=ccp(0,0);
        self.avalibleArrowsLabel.position=ccp(74,33);
        [self.availableArrowMC addChild:self.avalibleArrowsLabel];
        
        
        //--------------------------------
        self.musicBtn.position=ccp(ws.width-25,25);
        [self.gameUICMC addChild:self.musicBtn];
        
        self.infoText=[CCLabelBMFont labelWithString:@"Level 1" fntFile:@"a_Assuan.fnt"];
        
        self.infoText.position=ccp(ws.width/2,ws.height/2);
        [self.gameUICMC addChild:self.infoText];
        
        self.infoText.visible=NO;
        
        self.shootAble=NO;

        
        // Life setting Code
        
        
               //[userDefault setInteger:5 forKey:@"life"];
        int life = (int)[userDefault integerForKey:@"life"];
        
        NSLog(@"Life at starting -==- %d",life);
        
        // ========================================================================================
        
        // Extra Life Code
        NSString *numlife = [wrapperMultiArrows objectForKey:(__bridge id)kSecAttrLabel];
        
        int retrievednumLife = [numlife intValue];
        //NSLog(@"Life before reset -==- %d",retrievednumLife);
        
        if (retrievednumLife>0) {
        
            BOOL checkExtraLife = [userDefault boolForKey:@"elife"];
            
            if (!checkExtraLife) {
                [userDefault setBool:YES forKey:@"elife"];
                
                //NSLog(@"Rem Life BEfore -== %d",[GameState sharedState].remLife);
            
                life=life+retrievednumLife;
                
                [userDefault setInteger:life forKey:@"life"];
                [userDefault synchronize];
                
               // NSLog(@"retrieve Life -== %d  \n Rem Life -== %d", retrievednumLife,[GameState sharedState].remLife);
            }
        }
        self.birdsNo=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Birds Shot:%d",self.birdsShootedNum] fntFile:@"BerlinSansFBDemi45FFFFFF.fnt"];
        self.birdsNo.anchorPoint=ccp(0,1);
        self.birdsNo.position=ccp(5,80);
        [self addChild:self.birdsNo];

        //==============================================================================================
        
        // Level Setting Code
        
        int levelValue = (int)[userDefault integerForKey:@"level"];
       // NSLog(@"Level at starting -==- %d",levelValue);
        
        if (levelValue<=0) {
            
            self.levelText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Level: 1"] fntFile:@"BerlinSansFBDemi45FFFFFF.fnt"];
            
             self.lifeText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Life: %i",life] fntFile:@"BerlinSansFBDemi45FFFFFF.fnt"];
             [self showLevelInfoThenGoNextLevel:@"Ready" theLevel:1 theLife:life];
        }
        else{

            self.lifeText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Life: %i",life] fntFile:@"BerlinSansFBDemi45FFFFFF.fnt"];
            
             self.levelText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Level: %d",levelValue] fntFile:@"BerlinSansFBDemi45FFFFFF.fnt"];
            [self showLevelInfoThenGoNextLevel:@"Ready" theLevel:levelValue theLife:life];
        }
        self.lifeText.anchorPoint=ccp(0, 1);
        self.lifeText.position=ccp(ws.width-90, ws.height-15);
        [self addChild:self.lifeText];
        
        self.levelText.anchorPoint=ccp(0, 1);
        self.levelText.position=ccp(ws.width/2-40, ws.height-15);
     //   self.levelText.position=ccp(ws.width/2-40, ws.height-45);
        [self addChild:self.levelText];
        /*if([GameState sharedState].failToLoadBanner)
        {
              self.lifeText.position=ccp(ws.width-90, ws.height-15);
             self.levelText.position=ccp(ws.width/2-40, ws.height-15);
            
        }*/
        self.birdsNo.position=ccp(5,80);
        [self compareDate];
    }
	return self;
}

//RAJEEV

#pragma mark
#pragma mark Extra Life Code
#pragma mark ================================

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
        gameOverBannerCheck=YES;
        
        int levelValue = (int)[userDefault integerForKey:@"level"];
        int life = (int)[userDefault integerForKey:@"life"];
        
        if(levelValue==0){
            [self showLevelInfoThenGoNextLevel:@"Ready" theLevel:1 theLife:life];
        }
        else{
            [self showLevelInfoThenGoNextLevel:@"Ready" theLevel:levelValue theLife:life];
        }
    }
}
-(void)getExtraLife :(int)day andHour:(int)hour andMin:(int)min andSec:(int)sec
{
    [self setupLocalNotifications];
    int hoursInMin = hour*60;
    hoursInMin=hoursInMin+min;
    
    int totalTime = min*60+sec;
    
    int life = (int)[userDefault integerForKey:@"life"];
    int rem =min%5;
    
    int remTimeforLife = rem*60+sec;
    
    remTimeforLife=300-remTimeforLife;
    
    [userDefault setInteger:remTimeforLife forKey:@"timeRem"];
    [userDefault synchronize];
    
    NSString *numHints = [wrapperMultiArrows objectForKey:(__bridge id)kSecAttrLabel];
    
    int retrievedMultiArrows = [numHints intValue];
    //NSLog(@"Multiple arrow before reset -==- %d",retrievedMultiArrows);

    if (day>0 || hoursInMin>=25) {
        [self.lifeText setString:[NSString stringWithFormat:@"Life: 5"]];
        [userDefault setInteger:5 forKey:@"life"];
        [userDefault setObject:@"0" forKey:@"currentDate"];
    }
    else if(totalTime>=300){
       // int extralife =min/30;
        
       //life=life+extralife;
        
        if(life>5){
            [self.lifeText setString:[NSString stringWithFormat:@"Life: 5"]];
            [userDefault setInteger:5 forKey:@"life"];
            [userDefault setObject:@"0" forKey:@"currentDate"];
        }
        if (life<6) {
            [self.lifeText setString:[NSString stringWithFormat:@"Life: %i",life]];
            [userDefault setObject:@"0" forKey:@"currentDate"];
            [userDefault setInteger:life forKey:@"life"];
        }
        [userDefault synchronize];
    }
    
    if (life>0 || retrievedMultiArrows>0)
    {
        int levelValue = (int)[userDefault integerForKey:@"level"];
        [GameState sharedState].checkLife=YES;
        [GameState sharedState].checkLevelClear=NO;
        gameOverBannerCheck=YES;
        [self showLevelInfoThenGoNextLevel:@"Ready" theLevel:levelValue theLife:life];
    }
    
    else{
        
        if (!gameOverBannerCheck) {
            [self unschedule:@selector(updateTimeDisplay)];
            [self showLifeOver];
        }
        else{
             [GameState sharedState].checkLife=NO;
        }
    }
}
- (void)setupLocalNotifications {
    
    //BOOL check = [[NSUserDefaults standardUserDefaults]boolForKey:@"checkLivesNotification"];
    // if(check){
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification * localNotification = [[[UILocalNotification alloc] init] autorelease];
    
    // current time plus 9000(2.5 hrs) secs
    
    NSDate *now = [NSDate date];
    NSDate *dateToFire = [now dateByAddingTimeInterval:9000];
    
    NSLog(@"now time main: %@", now);
    NSLog(@"fire time main: %@", dateToFire);
    
    localNotification.fireDate = dateToFire;
    
    localNotification.alertBody =@"% Bow hunting is full of Lives Now! ";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"checkLivesNotification"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // }
}
#pragma mark
#pragma mark Button Action Code
#pragma mark ================================


-(void)multipleArrowBtnAction:(id)sender
{
     //[wrapperMultiArrows resetKeychainItem];
   NSString *numHints = [wrapperMultiArrows objectForKey:(__bridge id)kSecValueData];
   
    int retrievedHints = [numHints intValue];
      int userDefmulArrow=(int)[userDefault integerForKey:@"MultiArrows"] ;
    int multipleArrow=userDefmulArrow+retrievedHints;

    if(retrievedHints>0)
    {
        retrievedHints--;
        NSString *str = [NSString stringWithFormat:@"%i",retrievedHints];
        [wrapperMultiArrows setObject:str forKey:(__bridge id)kSecValueData];
        
        
    }

    // retrievedHints=5;
//    if (retrievedHints<=0) {
//        return;
//    }
  
    if(userDefmulArrow>0)
    {
        userDefmulArrow--;
        [userDefault setInteger:userDefmulArrow forKey:@"MultiArrows"];
        [userDefault synchronize];
        
    }

          if(multipleArrow>0)
    {
     
        
        if (self.shootAble) {
            
            multipleArrow--;
            
        [self.multipleArrowCount setString:[NSString stringWithFormat:@"%i x",multipleArrow]];            //NSLog(@"Multi Arrow after reset -==- %d",retrievedHints);
            
            self.br.rotation=-90;
            self.br.position=ccp(ws.width/2,0);
            
            if (multipleArrow>0)
            {
                if(self.currentArrow){
                    self.currentArrow.visible=NO;
                }
            }
            
            else{
                [wrapperMultiArrows resetKeychainItem];
                
                self.menuMultipleArrow.enabled = NO;
                
                //            self.multipleArrowBtn.visible =NO;
                //            self.multipleArrowCount.visible=NO;
                //
                //            [self removeChild:self.multipleArrowCount cleanup:YES];
                //            [self removeChild:self.multipleArrowBtn cleanup:YES];
                //            [self.multipleArrowBtn release];
            }
            
            for (int i=1; i<12; i++) {
                
                CCSprite *spriteMultipleArrow = [CCSprite spriteWithFile:@"multiplearrow.png"];
                spriteMultipleArrow.position=ccp(50+i*30, 100);
                [self addChild:spriteMultipleArrow];
                
                self.currentArrow=spriteMultipleArrow;
                
                id moveUp = [CCMoveBy actionWithDuration:2.5 position:ccp(0,+300)];
                id seq = [CCSequence actions:moveUp, nil];
                [spriteMultipleArrow runAction:seq];
                
                [arrTrees addObject:spriteMultipleArrow];
            }
            [self schedule:@selector(update:) interval:0.2f];
            
            [self scheduleOnce:@selector(hidePower) delay:3.0];
        }//self.shootable
        if (self.shootAble)
        {
            [self.br playShootMovie];
            [[SimpleAudioEngine sharedEngine]playEffect:@"snd_move.wav"];
        }
    }//multiarrow8
        
        
        
    
}
-(void)powerBoosterBtnAction:(id)sender {
    
    [self unschedule:@selector(update:)];
    
    NSString *numHints = [wrapperMultiArrows objectForKey:(__bridge id)kSecAttrAccount];
    
    int retrievedHints = [numHints intValue];
    int userDefBoosterArrow=(int)[userDefault integerForKey:@"BoosterArrows"] ;
    int boosterArrow=userDefBoosterArrow+retrievedHints;
    if(retrievedHints>0)
    {
        retrievedHints--;
        
        NSString *str = [NSString stringWithFormat:@"%i",retrievedHints];
        [wrapperMultiArrows setObject:str forKey:(id)kSecAttrAccount];
        
        
        
    }
    
    // retrievedHints=5;
    //    if (retrievedHints<=0) {
    //        return;
    //    }
    
    if(userDefBoosterArrow>0)
    {
        userDefBoosterArrow--;
        [userDefault setInteger:userDefBoosterArrow forKey:@"BoosterArrows"];
        [userDefault synchronize];
        
    }

    if (self.shootAble){
        
        boosterArrow--;
        
//        NSString *str = [NSString stringWithFormat:@"%i",retrievedHints];
//        [wrapperMultiArrows setObject:str forKey:(id)kSecAttrAccount];
//        
        [self.powerBoosterArrowCount setString:[NSString stringWithFormat:@"%i x",boosterArrow]];
        
        //NSLog(@"PowerBooster Arrow after reset -==- %d",retrievedHints);
        
        if (boosterArrow>0) {
            if(self.currentArrow){
                self.currentArrow.visible=NO;
            }
        }
        
        else{
            self.menuPowerBooster.enabled = NO;
//            self.powerBoosterBtn.visible =NO;
//            self.powerBoosterArrowCount.visible=NO;
//            
//            [self removeChild:self.powerBoosterBtn cleanup:YES];
//            [self removeChild:self.powerBoosterArrowCount cleanup:YES];
//            [self.powerBoosterBtn release];
        }
        
        self.br.rotation=-90;
        self.br.position=ccp(ws.width/2,0);
        
        CCSprite *spriteBoosterSky = [CCSprite spriteWithFile:@"booster arrow power.png"];
        spriteBoosterSky.position=ccp(ws.width/2, 100);
        [self addChild:spriteBoosterSky];
        
        id moveUp = [CCMoveBy actionWithDuration:1.5 position:ccp(0,+300)];
        id seq = [CCSequence actions:moveUp, nil];
        [spriteBoosterSky runAction:seq];
        
        [GameState sharedState].checkBooster=NO;
        
        if (self.shootAble) {
            [self shootWithPowerBooster];
        }
        if (self.shootAble) {
            [self.br playShootMovie];
            [[SimpleAudioEngine sharedEngine]playEffect:@"snd_move.wav"];
        }
        
        //NSLog(@"Birds Arrary Count -=-=-= %lu",(unsigned long)[self.birdsArr count]);
        for (int i=0; i<[self.birdsArr count]; i++) {
            
            Bird *b=(Bird*)[self.birdsArr objectAtIndex:i];
            [b fallAllBirds];
            
            self.score+=100+((int)(b.position.y/20));
            [self.scoreText setString:[NSString stringWithFormat:@"%i",self.score]];
            
            [userDefault setDouble:self.score forKey:@"score"];
            [userDefault synchronize];
            
            self.birdsShootedNum++;
             [self.birdsNo setString:[NSString stringWithFormat:@"Birds Shot: %i",self.birdsShootedNum]];
        }
    }
}
-(void)pauseBtnClicked:(id)sender {
    NSLog(@"Game Pause");
    
    GamePauseScene *actionScene = [[GamePauseScene alloc] init];
    [[CCDirector sharedDirector] pushScene:actionScene];
}

#pragma mark
#pragma mark Setting Level and start Game methods
#pragma mark ==============================================

//start game (or start a new game)

-(void)startGame:(int) level
{
    
    currentLevel=level;
    
    if(!self.birdsAreCreated){
        self.arrowsArr=[[NSMutableArray alloc]init] ;
        self.birdsArr=[[NSMutableArray alloc]init] ;
        for (int i=0; i<self.num_objects; i++) {
            Bird *  bird;
            if (level>=25) {
            bird =[[Bird alloc]initWithSpeed:0.8f+0.1f*25];
               
            }
            else{
                bird =[[Bird alloc]initWithSpeed:0.8f+0.1f*level] ;
            }
            
            bird.gm=self;
            [birdsArr addObject:bird];
            
            [self.birdCMC addChild:bird];
        }
        self.birdsAreCreated=YES;
    }
    
    [GameState sharedState].levelNumber=level;
    
    self.theTime=self.limitTime;
    [self.timeText setString:[NSString stringWithFormat:@"%i",self.theTime]];
    self.shootAble=YES;
    [self unschedule:@selector(updateTimeDisplay)];
    [self schedule:@selector(updateTimeDisplay) interval:1];
    
    [self unschedule:@selector(updateArrowDisplay)];
    [self schedule:@selector(updateArrowDisplay) interval:1];
    self.birdsShootedNum=0;
    
    [self resetBirds];
    [self unschedule:@selector(loop)];
    [self schedule:@selector(loop)];
    self.theTime=self.limitTime;
    [[SimpleAudioEngine sharedEngine] playEffect:@"geese3.wav"];
}

//show info and go next level
-(void)showLevelInfoThenGoNextLevel:(NSString*) info theLevel:(int)level theLife:(int)life {
    
    //[self.levelText setString:[NSString stringWithFormat:@"Level: %i",[GameState sharedState].levelNumber]];
    [self.levelText setString:[NSString stringWithFormat:@"Level: %i",level]];
    if (gameOverBannerCheck) {
        
        if (level>0 && level<=10) {
            
            self.num_arrows=5;
        }
        else if (level>10 && level<=20){
            self.num_arrows=30;
        }
        else if (level>20){
            self.num_arrows=30;
        }
        
        //NSLog(@"NUmber of Birds to Hit -==--= %d",self.num_arrows);
        
        int a = 0;
        if (self.num_arrows%4==0) {
            a = self.num_arrows/4;
        }
        else{
            a = self.num_arrows/4+1;
        }
        
        self.avalible_arrows = self.num_arrows + a ;
        NSLog(@"a  = %d",self.avalible_arrows);
        [self.avalibleArrowsLabel setString:[NSString stringWithFormat:@"%d",self.avalible_arrows]];
        
        [GameState sharedState].remLife=life;
        
        self.labelTarget = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Target : %i",self.num_arrows] fontName:@"Marker Felt" fontSize:64];
        
        
        // ask director the the window size
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // position the label on the center of the screen
        
        self.labelTarget.position = ccp(size.width /2 , size.height-90 );
        self.labelTarget.color=ccRED;
        // add the label as a child to this Layer
        
        [self addChild: self.labelTarget];
        
        id fadeIn = [CCFadeIn actionWithDuration:3];
        id fadeOut = [CCFadeOut actionWithDuration:2];

        id sequence = [CCSequence actions:fadeIn, fadeOut, nil];
        
        [self.labelTarget runAction:sequence];
        
        self.birdsShootedNum=0;
        self.br.rotation=-90;
        self.br.position=ccp(ws.width/2,0);
        
        self.pauseBtn.visible=YES;
        
        NSString *numHints = [wrapperMultiArrows objectForKey:(__bridge id)kSecValueData];
        int retrievedHints = [numHints intValue];
       
        
        if (retrievedHints>0) {
            //self.multipleArrowBtn.visible=YES;
            //self.multipleArrowCount.visible=YES;
            self.menuMultipleArrow.enabled = YES;
        }
        else{
            //self.multipleArrowBtn.visible=NO;
            if([userDefault integerForKey:@"MultiArrows"]>0)
            {
                self.menuMultipleArrow.enabled = YES;
            }
            else
            {
            self.menuMultipleArrow.enabled = NO;
            }
        }
        
        NSString *numPowerBooster = [wrapperMultiArrows objectForKey:(__bridge id)kSecAttrAccount];
        
       int retrievedPowerBooster = [numPowerBooster intValue];
        
        if (retrievedPowerBooster>0) {
//            self.powerBoosterBtn.visible=YES;
//            self.powerBoosterArrowCount.visible=YES;
            self.menuPowerBooster.enabled = YES;
        }
        else{
            if([userDefault integerForKey:@"BoosterArrows"]>0)
            {
                self.menuPowerBooster.enabled=YES;
            }
            else{
                //self.powerBoosterBtn.visible=NO;
                self.menuPowerBooster.enabled = NO;
            }
            
        }
        
        self.score=0;
        [self.scoreText setString:@"0"];
        
        if (level>=10 && level<20) {
            [self.skyBG setTexture:[[CCTextureCache sharedTextureCache] addImage:@"5.png"]];
        }
        if (level>=20 && level<30) {
            [self.skyBG setTexture:[[CCTextureCache sharedTextureCache] addImage:@"3.png"]];
        }
        if (level>=30 && level<40) {
            [self.skyBG setTexture:[[CCTextureCache sharedTextureCache] addImage:@"4.png"]];
        }
        if (level>=40 && level<51) {
            [self.skyBG setTexture:[[CCTextureCache sharedTextureCache] addImage:@"2.png"]];
        }
        self.infoText.scale=0;
        self.infoText.visible=YES;
        
        id cccfND=[CCCallFuncND actionWithTarget:self selector:@selector(showCompleteInfoCompleted:data:) data:(void *)level];
        id delay=[CCDelayTime actionWithDuration:1];
        
        id scaleTo1 = [CCScaleTo actionWithDuration:0.6 scale:1.0];
        
        id scale_ease_in = [CCEaseBackOut actionWithAction:[[scaleTo1 copy] autorelease]];
        
        id scaleTo0 = [CCScaleTo actionWithDuration:0.2 scale:0];
        
        // Rajeev
        
        if (level) {
            [self.infoText setString:@"Ready"];
        }
        
        id seq =[CCSequence actions:delay,scale_ease_in,[CCDelayTime actionWithDuration:0.6] ,scaleTo0,cccfND,nil];
        
        [self.infoText runAction:seq];
    }
}

//showLevelInfoThenGoNextLevel completed
-(void) showCompleteInfoCompleted:(id)sender data:(int)data{
    [self startGameShowLevel:data];
}

//start a new game , shpw level info
-(void)startGameShowLevel:(int) level
{
    
    id cccfND=[CCCallFuncND actionWithTarget:self selector:@selector(completed:data:) data:(void *)level];
    id delay=[CCDelayTime actionWithDuration:0.3];
    
    id scaleTo1 = [CCScaleTo actionWithDuration:0.6 scale:1.0];
    
    id scaleTo0 = [CCScaleTo actionWithDuration:0.2 scale:0];
    
    id scale_ease_in = [CCEaseBackOut actionWithAction:[[scaleTo1 copy] autorelease]];
    
    self.infoText.scale=0;
    
    [self.infoText setString:[NSString stringWithFormat:@"Level-%i",level]];
    
    id seq =[CCSequence actions:delay,scale_ease_in,[CCDelayTime actionWithDuration:0.6],scaleTo0,cccfND,nil];
    
    [self.infoText runAction:seq];
}

//cccfND 

-(void) completed:(id)sender data:(int)data
{
    [self.infoText setVisible:NO];
    self.shootAble=YES;
    [self startGame:data];
}

#pragma mark
#pragma mark Update , Schedule, Reset methods
#pragma mark ==============================================

-(void)hidePower
{
    [self unschedule:@selector(update:)];
}
- (void)update:(ccTime)dt {
    
    arrTrees1 = arrTrees.mutableCopy;
    
    for (CCSprite *trees in arrTrees1) {
        
        for (int i=0; i<[self.birdsArr count]; i++) {
            
            Bird *b=(Bird*)[self.birdsArr objectAtIndex:i];
            
            if(trees&&trees&&!b.isDead){
                CGRect aRect=CGRectMake(trees.position.x-(trees.contentSize.width/2), trees.position.y- (trees.contentSize.height/2), 10, 10);
                CGRect birdRect=CGRectMake(b.position.x-(b.contentSize.width/2) , b.position.y-(b.contentSize.height/2),25 , 25);
                //CGPoint pp=CGPointMake(self.currentArrow.position.x, self.currentArrow.position.y);
                if(CGRectIntersectsRect(aRect, birdRect)){
                    self.currentArrow.visible=NO;
                    if(b.scaleX>0){
                        [b fallWithArrowRotation:atan2f(self.br.position.x-b.position.x,self.br.position.y-b.position.y)*180/M_PI+90];
                    }
                    else{
                        [b fallWithArrowRotation:-atan2f(self.br.position.x-b.position.x,self.br.position.y-b.position.y)*180/M_PI+90];
                    }
                    [arrTrees1 removeObject:trees];
                    [self removeChild:trees cleanup:YES];
                    
                    self.score+=100+((int)(b.position.y/20));
                    [self.scoreText setString:[NSString stringWithFormat:@"%i",self.score]];
                    
                    [userDefault setDouble:self.score forKey:@"score"];
                    [userDefault synchronize];
                    
                    self.birdsShootedNum++;
                   [self.birdsNo setString:[NSString stringWithFormat:@"Birds Shot: %i",self.birdsShootedNum]];
                    return;
                }// End if Block
            }// End if block
        }// End for loop
    }// End for loop
    
}

//update time text
-(void)updateTimeDisplay{
    self.theTime--;
    [self.timeText setString:[NSString stringWithFormat:@"%i",self.theTime]];
    if (self.theTime==0) {
        
        //Rajeev
        [self hideBirds];
        
        if (self.birdsShootedNum>=self.num_arrows) {
            
            [self levelCompletedSceneDisplay];
        }
        
        else {
            [self levelFailedSceneDisplay];
        }
    }//End of Main If statement
}

-(void) levelFailedSceneDisplay
{
    self.birdsShootedNum=0;
     [self.birdsNo setString:[NSString stringWithFormat:@"Birds Shot: %i",self.birdsShootedNum]];
    [self hideBirds];
    int lifeUserDefault = (int)[userDefault integerForKey:@"life"];
    
    lifeUserDefault--;
    
    NSString *numlife = [wrapperMultiArrows objectForKey:(__bridge id)kSecAttrLabel];
    int retrievednumLife = [numlife intValue];
    // NSLog(@"Power Booster arrow before reset -==- %d",retrievednumLife);
    
    if (retrievednumLife>0) {
        
        retrievednumLife--;
        NSString *lifeString = [NSString stringWithFormat:@"%i",retrievednumLife];
        
        [wrapperMultiArrows setObject:lifeString forKey:(__bridge id)kSecAttrLabel];
        
        if(retrievednumLife==0){
            [userDefault setBool:NO forKey:@"elife"];
            [userDefault synchronize];
        }
    }
    if(lifeUserDefault<0){
        [userDefault setInteger:0 forKey:@"life"];
    }
    else{
        [userDefault setInteger:lifeUserDefault forKey:@"life"];
    }
    
    [userDefault synchronize];
    
    NSString *str =[userDefault objectForKey:@"currentDate"];
    
    if (lifeUserDefault<5 && [str isEqualToString:@"0"]) {
        
        NSDate* now = [NSDate date];
        //NSLog(@"%@ seconds since recevedData was called last", now);
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        NSString *dateStr = [df stringFromDate:now];
        
        [userDefault setObject:dateStr forKey:@"currentDate"];
        [df autorelease];
    }
    
    [userDefault synchronize];
    
    [self.lifeText setString:[NSString stringWithFormat:@"Life: %i",lifeUserDefault]];
    [GameState sharedState].checkLife=YES;
    [GameState sharedState].checkLevelClear=NO;
    
    if (lifeUserDefault<=0) {
        gameOverBannerCheck=YES;
        [self compareDate];
        self.theTime=-1;
    }// End of If statement ([GameState sharedState].remLife==0)
    
    [self unschedule:@selector(updateTimeDisplay)];
    self.shootAble=NO;
    self.birdsAreCreated=NO;
    
    spriteWinLoose = [CCSprite spriteWithFile:@"level failed banner.png"];
    spriteWinLoose.position=ccp(ws.width+185, ws.height/2);
    [self addChild:spriteWinLoose];
    
    id moveLeft;
    
    if ([UIScreen mainScreen].bounds.size.height > 500) {
        moveLeft = [CCMoveBy actionWithDuration:1 position:ccp(-475,0)];
    }
    else {
        moveLeft = [CCMoveBy actionWithDuration:1 position:ccp(-425,0)];
    }
    
    id seq = [CCSequence actions:moveLeft, nil];
    [spriteWinLoose runAction:seq];
    
    [self scheduleOnce:@selector(showGameOver) delay:2.5];


}

-(void) levelCompletedSceneDisplay{
    [GameState sharedState].checkLevelClear=YES;
    [GameState sharedState].checkLife=YES;
    
    [self hideBirds];
    [self unschedule:@selector(updateTimeDisplay)];
    self.shootAble=NO;
    spriteWinLoose = [CCSprite spriteWithFile:@"wonderful level completed.png"];
    NSLog(@"Life==%@",[userDefault objectForKey:@"life"]);
    spriteWinLoose.position=ccp(ws.width+185, ws.height/2);
    [self addChild:spriteWinLoose];
    id moveLeft;
    
    if([UIScreen mainScreen].bounds.size.height >500){
        moveLeft  = [CCMoveBy actionWithDuration:1 position:ccp(-475,0)];
    }
    else{
        moveLeft = [CCMoveBy actionWithDuration:1 position:ccp(-425,0)];
    }
    
    id seq = [CCSequence actions:moveLeft, nil];
    [spriteWinLoose runAction:seq];
    
    [self scheduleOnce:@selector(showGameOver) delay:2.5];
    
    [userDefault synchronize];


    [FBAppEvents logEvent:FBAppEventNameAchievedLevel];

    [GameState sharedState].levelNumber++;
    
    [userDefault setInteger:[GameState sharedState].levelNumber forKey:@"level"];
    
    int level=(int)[userDefault integerForKey:@"levelClear"];
    
    if ([GameState sharedState].levelNumber>level) {
        [userDefault setInteger:[GameState sharedState].levelNumber forKey:@"levelClear"];
    }
    
    //NSLog(@"Level After Clear -==- %d",[GameState sharedState].levelNumber);
    [userDefault synchronize];
    
    //            [self.levelText setString:[NSString stringWithFormat:@"Level: %i",[GameState sharedState].levelNumber]];
}
#pragma mark -
-(void) updateArrowDisplay{
    
    //NSLog(@"no of arrow%d",self.avalible_arrows);
    if (self.avalible_arrows==0) {
        
        [self unschedule:@selector(updateArrowDisplay)];
        //[self unschedule:@selector(updateTimeDisplay)];
        
        [self scheduleOnce:@selector(prepareGameOverCompletionScene) delay:1.4];
        
        NSLog(@"Over");
    }

    
}
-(void) prepareGameOverCompletionScene{
    
    if (self.birdsShootedNum>=self.num_arrows){
        NSLog(@"Level Completed");
        
        //if (theTime==0) {
        [GameState sharedState].checkLevelClear=YES;
        [GameState sharedState].checkLife=YES;
        
        [self hideBirds];
        [self unschedule:@selector(updateTimeDisplay)];
        self.shootAble=NO;
            self.shootAble=NO;
            spriteWinLoose = [CCSprite spriteWithFile:@"wonderful level completed.png"];
            spriteWinLoose.position=ccp(ws.width+185, ws.height/2);
            [self addChild:spriteWinLoose];
            id moveLeft;
            
            if([UIScreen mainScreen].bounds.size.height >500){
                moveLeft  = [CCMoveBy actionWithDuration:1 position:ccp(-475,0)];
            }
            else{
                moveLeft = [CCMoveBy actionWithDuration:1 position:ccp(-425,0)];
            }
            
            id seq = [CCSequence actions:moveLeft, nil];
            [spriteWinLoose runAction:seq];
            
            [self scheduleOnce:@selector(showGameOver) delay:2.5];
        
        
        
        [GameState sharedState].levelNumber++;
        
        //[userDefault setInteger:[GameState sharedState].levelNumber forKey:@"level"];
        
        int level=(int)[userDefault integerForKey:@"levelClear"];
        
        if ([GameState sharedState].levelNumber>level) {
            [userDefault setInteger:[GameState sharedState].levelNumber forKey:@"levelClear"];
        }
        
        //NSLog(@"Level After Clear -==- %d",[GameState sharedState].levelNumber);
        [userDefault synchronize];
        
      
        
        
    }
    else{
        NSLog(@"Level not completed");
        self.shootAble=NO;
        self.birdsAreCreated=NO;
        [self scheduleOnce:@selector(displayArrowPurchaseSpriteInMain) delay:0.7];
    }
}
-(void) displayArrowPurchaseSpriteInMain{
    PurchaseArrowScene *actionScene = [[PurchaseArrowScene alloc] initWithGameMain:self] ;
    actionScene.purchaseGameMain = self;
    [GameState sharedState].birdsShooted=self.birdsShootedNum;
    [[CCDirector sharedDirector] pushScene:actionScene];
    
}
-(void)resumeGameWithArrowPurchase
{
    NSLog(@"Birds shooted %d",self.birdsShootedNum);
    self.avalible_arrows = 38;
    self.birdsShootedNum=[GameState sharedState].birdsShooted;
     [self.avalibleArrowsLabel setString:[NSString stringWithFormat:@"%d",self.avalible_arrows]];    self.shootAble=YES;
    self.birdsAreCreated=YES;
    [self schedule:@selector(updateArrowDisplay) interval:1];
}
#pragma mark -
-(void)scheduleTime {
    
    int lifeUserDefault = (int)[userDefault integerForKey:@"life"];
    
    if (lifeUserDefault<5) {
        lifeUserDefault++;
        
        [userDefault setObject:@"0" forKey:@"currentDate"];
        
        [userDefault setInteger:lifeUserDefault forKey:@"life"];
        [userDefault synchronize];
        [self.lifeText setString:[NSString stringWithFormat:@"Life: %i",lifeUserDefault]];
    }
}
- (void) cleanupSprite:(CCSprite*)inSprite
{
    // call your destroy particles here
    // remove the sprite
    [self removeChild:inSprite cleanup:YES];
}
//reset birds

-(void)resetBirds{
    //    NSLog(@"Birds Array Count -==- %d",[self.birdsArr count]);
    for (int i=0; i<self.birdsArr.count; i++) {
        id b=[self.birdsArr objectAtIndex:i];
        [(Bird*)b setVisible:YES];
        [(Bird*)b reset];
    }
}

//hide all birds
-(void)hideBirds{
    for (int i=0; i<self.birdsArr.count; i++) {
        id b=[self.birdsArr objectAtIndex:i];
        [(Bird*)b setVisible:NO];
    }
}

//the main loop

-(void)loop{
    
    float px=cosf(-self.currentArrow.rotation/180*M_PI)*12;
    float py=sinf(-self.currentArrow.rotation/180*M_PI)*12;
    self.currentArrow.position=ccp(self.currentArrow.position.x+px,+self.currentArrow.position.y+py);
    //NSLog(@"Current arrow position %f",self.currentArrow.position.y);
    for (int i=0; i<[self.birdsArr count]; i++) {
        
        Bird *b=(Bird*)[self.birdsArr objectAtIndex:i];
        
        if(self.currentArrow&&self.currentArrow.visible&&!b.isDead){
            CGRect aRect=CGRectMake(self.currentArrow.position.x, self.currentArrow.position.y, 1, 1);
            CGRect birdRect=CGRectMake(b.position.x-7 , b.position.y-7, 14 , 14);
            //CGPoint pp=CGPointMake(self.currentArrow.position.x, self.currentArrow.position.y);
            if(CGRectIntersectsRect(aRect, birdRect)){
                self.currentArrow.visible=NO;
                if(b.scaleX>0){
                [b fallWithArrowRotation:atan2f(self.br.position.x-b.position.x,self.br.position.y-b.position.y)*180/M_PI+90];
                }
                else{
                    [b fallWithArrowRotation:-atan2f(self.br.position.x-b.position.x,self.br.position.y-b.position.y)*180/M_PI+90];
                }
                self.score+=100+((int)(b.position.y/20));
                [self.scoreText setString:[NSString stringWithFormat:@"%i",self.score]];
                
                [userDefault setDouble:self.score forKey:@"score"];
                [userDefault synchronize];
                
                self.birdsShootedNum++;
                 [self.birdsNo setString:[NSString stringWithFormat:@"Birds Shot: %i",self.birdsShootedNum]];
                return;
            }// End if block
        }// End if Block
    }// End for Block
    
}

#pragma mark
#pragma mark Game Over Methods
#pragma mark ================================

//show game over
-(void) showGameOver
{
   
    [self removeChild:self.spriteWinLoose cleanup:YES];
    
    self.pauseBtn.visible=NO;
//    self.powerBoosterBtn.visible=NO;
//    self.multipleArrowBtn.visible=NO;
    self.shootAble=NO;
    
    if(!self.gameOverLayer){
        self.gameOverLayer=[[GameOver alloc]init];
        ((GameOver*)self.gameOverLayer).gm=self;
        [self addChild:self.gameOverLayer];
    }
    else{
        ((GameOver*)self.gameOverLayer).visible=YES;
    }
    ((GameOver*)self.gameOverLayer).levelScore = self.score;
    ((GameOver*)self.gameOverLayer).currentLevel = currentLevel;
    
//    [((GameOver*)self.gameOverLayer).scoreText setString:[NSString stringWithFormat:@"Score: %i",self.score]];
    [((GameOver*)self.gameOverLayer).scoreText setString:[NSString stringWithFormat:@" %i",self.score]];
    
    if ([GameState sharedState].checkLife && [GameState sharedState].checkLevelClear) {
        [((GameOver*)self.gameOverLayer).levelText setString: [NSString stringWithFormat:@"Level  %i",currentLevel]];
        
        //save score to parse
        
        [((GameOver*)self.gameOverLayer) saveScoreToParse:self.score forLevel:currentLevel];
        
        ((GameOver*)self.gameOverLayer).levelCount = currentLevel;
        ((GameOver*)self.gameOverLayer).strPostMessage =
        [NSString stringWithFormat:@"Completed Level %i  with a score of %i!",currentLevel,self.score];//[NSString stringWithFormat:@"I cleared Level %i  and scored %i points.",currentLevel,self.score];

        //NSLog(@"POst Message =--= %@",((GameOver*)self.gameOverLayer).strPostMessage);

//        if (currentLevel>=50) {
//            
//            [((GameOver*)self.gameOverLayer).gameOverText setVisible:YES];
//            [((GameOver*)self.gameOverLayer).menuBack setVisible:YES];
//            [((GameOver*)self.gameOverLayer).playMI setVisible:NO];
//        }
//        else{
            [((GameOver *)self.gameOverLayer).playMI setNormalImage:[CCSprite spriteWithFile:@"next_cld.png"]];
            ((GameOver *)self.gameOverLayer).checkLevelClear = YES;
            [((GameOver*)self.gameOverLayer).gameOverText setVisible:NO];
            [((GameOver*)self.gameOverLayer).menuBack setVisible:NO];
            [((GameOver*)self.gameOverLayer).playMI setVisible:YES];
      //  }
       
        [((GameOver*)self.gameOverLayer).shareText setVisible:YES];
        [((GameOver*)self.gameOverLayer).shareButtons setVisible:NO];
        
    }
    else
    {
        [((GameOver*)self.gameOverLayer).levelText setString: [NSString stringWithFormat:@"Level %i not completed",currentLevel]];
        [((GameOver *)self.gameOverLayer).playMI setNormalImage:[CCSprite spriteWithFile:@"retry.png"]];
        ((GameOver *)self.gameOverLayer).checkLevelClear = NO;
        [((GameOver*)self.gameOverLayer).shareText setVisible:NO];
        [((GameOver*)self.gameOverLayer).shareButtons setVisible:NO];
        [((GameOver*)self.gameOverLayer).gameOverText setVisible:NO];
        [((GameOver*)self.gameOverLayer).menuBack setVisible:NO];
    }
   // NSLog(@"Current level -=-= %d",[GameState sharedState].levelNumber);
    //NSLog(@"Level  Message =--= %@",((GameOver*)self.gameOverLayer).levelText);
}

-(void) showLifeOver {
    
    if(!self.lifeOverLayer){
        self.lifeOverLayer=[[LifeOver alloc]init];
        [self addChild:self.lifeOverLayer];
    }
    else{
        ((LifeOver*)self.lifeOverLayer).visible=YES;
    }
}
#pragma mark
#pragma mark Shooting and Touch methods
#pragma mark ==============================================

//touch

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch=[touches anyObject];
    CGPoint loc=[touch locationInView:[touch view]];
    loc=[[CCDirector sharedDirector]convertToGL:loc];
    CGPoint point=CGPointMake(loc.x, loc.y);
    
    self.br.rotation=atan2f(self.br.position.x-point.x,self.br.position.y-point.y)*180/M_PI+90;

    if(self.currentArrow){
        self.currentArrow.visible=NO;
    }
    
    if(self.br.shootAble){
        [self shoot:point.x SY:point.y];
    }
    if (self.shootAble) {
        [self.br playShootMovie];
        [[SimpleAudioEngine sharedEngine]playEffect:@"snd_move.wav"];
    }
}

//shoot  a arrow

-(void)shoot:(float)sx SY:(float)sy{
    ///////////
     ///////////
    if(self.currentArrow){
    }
    if (self.shootAble) {
        
        if (self.avalible_arrows<=0) {
            NSLog(@"not avail");
        }
        else{
            self.currentArrow=[CCSprite spriteWithSpriteFrameName:@"arrow.png"];
            self.currentArrow.anchorPoint=ccp(1,0.5);
            self.currentArrow.position=ccp(self.br.position.x,self.br.position.y);
            self.currentArrow.rotation=self.br.rotation;
            [self addChild:self.currentArrow];
            
//            NSLog(@"av  = %d",self.avalible_arrows);
            self.avalible_arrows = self.avalible_arrows - 1;
            
            [self.avalibleArrowsLabel setString:[NSString stringWithFormat:@"%d",self.avalible_arrows]];
        }
        
    }
}
//RAJEEV
-(void)shootWithPowerBooster {
    self.currentArrow=[CCSprite spriteWithFile:@"booster arrow.png"];
    self.currentArrow.anchorPoint=ccp(1,0.5);
    
    //NSLog(@"br pOsition x-=-= %f\n\n br POsition Y -==- %f",self.br.position.x,self.br.position.y);
    self.currentArrow.position=ccp(self.br.position.x,self.br.position.y);
    self.currentArrow.rotation=self.br.rotation;
    [self addChild:self.currentArrow];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    //[self.labelTarget release];
    [arrTrees release];
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
    [[app navController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
    [[app navController] dismissViewControllerAnimated:YES completion:nil];
}
@end
