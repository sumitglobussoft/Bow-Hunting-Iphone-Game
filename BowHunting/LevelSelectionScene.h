//
//  LevelSelectionScene.h
//  BowHunting
//
//  Created by Sumit Ghosh on 03/05/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "RootViewController.h"
#import "GameState.h"
#import "AdMobFullScreenViewController.h"


@interface LevelSelectionScene : CCSprite {
    UIButton *btnLevels;
    UIButton *btnBack;
    UINavigationController *rootViewController;
   UIViewController *viewController;
    UIScrollView *scrollV;
    CCMenu *menuBack;
    CCSprite *spriteBackground;
    UIImageView * img;
    UILabel *firstname1,*rankNo,*score;
    UILabel * level,*target;
   AdMobFullScreenViewController *adf;
    NSMutableArray *friendsId;
    NSMutableArray *levelNo;
}
-(id)init:(BOOL)musicOn;
-(void)cancelButtonAction;
-(void)playButtonAction;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property(assign) BOOL checkMusic;
@property (nonatomic,retain) UIView *backgroundView;
@property(nonatomic,assign) id lifeOverLayer;
@property (nonatomic,retain) UIImageView *upperView;
@property (nonatomic,retain) UIView *lowerView;
@property(nonatomic,retain) UIButton * cancelButton,*playButton;
//@property (nonatomic) RootViewController *viewcontroller;
@end
