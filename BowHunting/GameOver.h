//
//  GameOver.h
//  BowHunting
//
//  Created by tang on 12-10-2.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "CCLayer.h"
#import "GameMain.h"
#import "cocos2d.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

#import "AppDelegate.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <sqlite3.h>
#import <Parse/Parse.h>
#import "UIImageView+WebCache.h"
#import "FriendsViewControllerTaggable.h"

@interface GameOver : CCSprite<NSURLConnectionDelegate, UITextViewDelegate>
{
    GameMain* gm;
    CCMenu *playButton;
    CCLabelBMFont *scoreText;
    RootViewController *controller;
    NSMutableArray * beatedFriendObjects;
    //Rajeev
         UIActivityIndicatorView *activityInd;
    NSUserDefaults *userDefault;
    //sukhmeet for fbposting
    sqlite3 *_databaseHandle;
    FriendsViewControllerTaggable * fbFrnds;
    NSString * beatedFriendObject;
    PFObject *secondHighScore;
    BOOL isNewHighScore;
    BOOL  if_beated;
    Clouds *c;
    AppController * appDelegate;
    AdMobViewController * adm;
    UIViewController *rootViewController;
    UIView *backView;
}

@property(nonatomic,retain) GameMain* gm;
@property(nonatomic,retain) CCMenu *playButton;
@property(nonatomic,retain) CCLabelBMFont *scoreText;

//Rajeev
@property(nonatomic,retain) NSString *strPostMessage;
@property(nonatomic,retain) CCLabelBMFont *shareText;
@property(nonatomic,retain) CCMenuItemImage *shareOnFb;
//@property(nonatomic,retain) CCMenuItemImage *shareOnTwitter;
@property(nonatomic,retain) CCMenu *shareButtons;
@property(nonatomic,retain) NSString *levelCompletionText;
@property(nonatomic,retain) CCLabelBMFont *levelText;
@property(nonatomic,retain) CCMenuItemImage *playMI;
@property(nonatomic,assign) id lifeOverLayer;
@property(nonatomic,retain) CCLabelBMFont *gameOverText;
@property(nonatomic,retain) CCMenu *menuBack;
@property(assign) int levelCount;
@property(nonatomic,retain) NSMutableArray *mutArrScores;
@property(assign) BOOL checkLevelClear;
@property(nonatomic,retain) CCSprite *spriteBackground;
@property(nonatomic, retain) CCMenuItemImage *playNextLevel;
@property(nonatomic, retain) CCLabelTTF *lblPOsition;
@property(nonatomic, retain) CCLabelTTF *lblHeader;
@property(nonatomic, retain) NSString *lblFbFirstName;
@property(nonatomic, retain) NSString *lblFbLastName;
@property(nonatomic, retain) CCLabelBMFont *lblFbBeatFrnd;
@property(nonatomic,retain)UIImageView * popup;
@property(nonatomic, retain) CCMenu *menuNextLevel;
//------
@property (nonatomic, assign) NSInteger levelScore;
@property (nonatomic, assign) NSInteger currentLevel;
@property (nonatomic, retain) CCSprite *scoreImage;
@property (nonatomic,retain) UILabel *beated,*youScore;
@property (nonatomic,retain) UIButton * playButton_new,*shareonfb,*cancelButton;
//=======
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, strong)UIScrollView *scrollView;


@property (nonatomic, strong) NSString *beatedFrndName;
-(void) saveScoreToParse:(NSInteger)score forLevel:(NSInteger)level;
@end
