//
//  LifeOver.h
//  BowHunting
//
//  Created by Sumit Ghosh on 26/03/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "CCSprite.h"
#import "CCLayer.h"
#import "cocos2d.h"
#import "Store.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "FriendsViewController.h"
#import "FriendsViewControllerTaggable.h"
#import "AdMobViewController.h"
#import <AdMobFullScreenViewController.h>

@interface LifeOver : CCSprite <AppDelegateDelegate>{
    
    int min;
    int sec;
    int remTime;
    UIView * backgroundView;
    NSUserDefaults *userDefault;
    UIViewController *viewController;
        AppController * appDelegate;
    AdMobFullScreenViewController *adf;
    AdMobViewController *adm;
    UINavigationController *rootViewController;
    FriendsViewControllerTaggable *fbFrnds;
}

@property(nonatomic,retain) CCLabelBMFont *lblNextLifeTime;
@property(nonatomic,retain) CCLabelBMFont *timeText;
@property(nonatomic,retain) CCLabelBMFont *lblMoreLifeNow;
@property(nonatomic,retain) CCMenu *menuAskFrnd;
@property(nonatomic,retain) CCMenu *menuMoreLife;
@property(nonatomic,retain) CCMenu *menuBack;
@property(nonatomic,assign) id storeLayer;
@property (nonatomic, strong) FriendsViewController *fbFrnds;
-(void)Timer;
@end
