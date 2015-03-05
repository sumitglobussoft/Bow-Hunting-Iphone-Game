//
//  PurchaseArrowScene.h
//  BowHunting
//
//  Created by GBS-ios on 7/18/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"
#import "CCLayer.h"

#import "GameMain.h"
#import "AppDelegate.h"

#import "FriendsViewController.h"
//@class FriendsViewController;

@interface PurchaseArrowLayer : CCLayer<AppDelegateDelegate,FriendsViewControllerDelegate>{
    CCMenuItemLabel *resumeMenuItem;
    CCMenuItemLabel *labelMenuItem;
    NSUserDefaults *userDefault;
    UIView *bannerView;
}
@property (nonatomic, strong) GameMain *purchaseGameMain;
@property (nonatomic, strong) FriendsViewController *fbFrnds;
-(id)initWithGameMain:(GameMain *)gameMain;
@end

@interface PurchaseArrowScene : CCScene
{
    PurchaseArrowLayer *layer;
}
@property (nonatomic, retain) GameMain *purchaseGameMain;

-(id) initWithGameMain:(GameMain *)gameMain;
@end
