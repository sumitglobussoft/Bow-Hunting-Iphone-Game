//
//  HelloWorldLayer.h
//  BowHunting
//
//  Created by tang on 12-9-24.
//  Copyright tang 2012年. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "Clouds.h"
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "BowArrow.h"
#import "SwitchButton.h"
#import "KeychainItemWrapper.h"
#import "AdMobViewController.h"
// HelloWorldLayer
@interface GameMain : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCSprite *skyBG,*sun,*ground2,*ground1,*gameUICMC,*scoreMC,*timeMC,*birdCMC,*currentArrow;
    Clouds *clouds;
    BowArrow *br;
    int num_arrows,num_objects,birdsShootedNum,score,theTime,limitTime,currentLevel;
    float currentSpeed,speedPlus;
    NSMutableArray *birdsArr,*arrowsArr;
    CCLabelBMFont *timeText,*scoreText,*infoText;
    SwitchButton *musicBtn;
    BOOL shootAble,birdsAreCreated,musicIsOn;
    id gameOverLayer;
    
    //Rajeev
    id lifeOverLayer;
    
    NSUserDefaults *userDefault;
    BOOL checkMultipleArrowPower;
    NSMutableArray *arrTrees;
    NSMutableArray *arrTrees1;
    BOOL gameOverBannerCheck;
    KeychainItemWrapper *wrapperMultiArrows;
    AdMobViewController * adm;
//    KeychainItemWrapper *wrapperPowerBooster;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene:(BOOL)gbmIsOn;
-(void) loop;
-(void)hideBirds;
-(id) initWithBOOL:(BOOL)bgmIsOn;
-(void) resetBirds;
-(void) shoot:(float)sx SY:(float)sy;
-(void) startGame:(int)level;
-(void) startGameShowLevel:(int) level;
-(void) completed:(id)sender data:(int)data;
-(void) showCompleteInfoCompleted:(id)sender data:(int)data;
//-(void) showLevelInfoThenGoNextLevel:(NSString*) info theLevel:(int)level;
-(void)showLevelInfoThenGoNextLevel:(NSString*) info theLevel:(int)level theLife:(int)life;
-(void) showGameOver;

@property(nonatomic,retain) CCSprite *skyBG,*sun,*ground2,*ground1,*gameUICMC,*scoreMC,*timeMC,*birdCMC,*currentArrow,*availableArrowMC;

@property(nonatomic,retain) CCMenuItem *pauseBtn;
@property(nonatomic,retain) Clouds *clouds;

@property(nonatomic,retain) NSMutableArray *birdsArr,*arrowsArr;
@property(nonatomic,retain) BowArrow *br;
@property(nonatomic,assign) id gameOverLayer;
@property(nonatomic,assign) int num_arrows,num_objects,birdsShootedNum,score,theTime,limitTime,avalible_arrows,currentLevel;
@property(nonatomic,assign) float currentSpeed,speedPlus;
@property(nonatomic,assign) BOOL shootAble,birdsAreCreated,musicIsOn;
@property(nonatomic,assign) CCLabelBMFont *timeText,*scoreText,*infoText,*birdsNo;

@property (nonatomic, retain) CCLabelBMFont *avalibleArrowsLabel;

@property(nonatomic,assign) SwitchButton *musicBtn;

//Rajeev
@property(nonatomic,assign) CCLabelBMFont *lifeText;
@property(nonatomic,assign) CCLabelBMFont *levelText;
//@property(nonatomic,assign) CCLabelBMFont *noOfBirdsHunt;
@property(nonatomic,assign) CCLabelBMFont *multipleArrowCount;
@property(nonatomic,assign) CCLabelBMFont *powerBoosterArrowCount;

@property(nonatomic,strong) UIViewController *viewController;
@property(nonatomic,assign) id lifeOverLayer;
@property(nonatomic,retain) CCSprite *spriteWinLoose;
@property(nonatomic,retain) CCMenuItem *powerBoosterBtn;
@property(nonatomic,retain) CCMenuItem *multipleArrowBtn;
@property(nonatomic,retain) NSMutableArray *arrArrows;
@property(nonatomic,retain) CCLabelTTF *labelTarget;


//============
@property (nonatomic, retain) CCMenu *menuPowerBooster;
@property (nonatomic, strong) CCMenu *menuMultipleArrow;

//-----
-(void)resumeGameWithArrowPurchase;
-(void) levelFailedSceneDisplay;
-(void) levelCompletedSceneDisplay;
@end
