//
//  GameIntro.h
//  BowHunting
//
//  Created by tang on 12-9-29.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "cocos2d.h"
#import "Clouds.h"
#import "BowHuntingTitle.h"
#import "Store.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "FriendsViewController.h"
#import "FriendsInLevel.h"
#import "LevelSelectionScene.h"
#import "AdMobViewController.h"


@interface GameIntro : CCLayer<AppDelegateDelegate>{
    CCSprite *skyBG,*bird;
    Clouds *clouds;
    CCMenuItem *playMI;
    CCMenu *playButton;
    BOOL musicIsOn;
    NSMutableArray *flyArr;
    BowHuntingTitle *bht;
    UIView *viewHost1;
    GADBannerView  *bannerView ;
    AdMobViewController *adm;
    AppController * appDelegate;
    int a;
    //sukhmeet
    FriendsInLevel * friendLevel;
    LevelSelectionScene * levelObj;
    BOOL screenForPlay;
}
+(CCScene *) scene;

-(void)stop;
-(void)playBGM;
-(void) playButtonClicked;

@property(nonatomic,retain) CCSprite*skyBG,*bird;
@property(nonatomic,retain) Clouds *clouds;
@property(nonatomic,retain) CCMenuItem *playMI;
@property(nonatomic,retain) CCMenu *playButton;
@property(nonatomic,assign) BOOL musicIsOn;
@property(nonatomic,assign) BowHuntingTitle *bht;
@property(nonatomic,assign) NSMutableArray *flyArr;
@property(nonatomic,retain)CCMenuItemToggle *fbToggle;
//Rajeev

@property(nonatomic, strong) CCMenuItem *storeMI;
@property(nonatomic,assign) id storeLayer;

@property (nonatomic, strong) CCMenuItem *connectWithFB;
@end
