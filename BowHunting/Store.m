//
//  Store.m
//  BowHunting
//
//  Created by Sumit Ghosh on 09/04/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "Store.h"
#import "GameIntro.h"
#import "RageIAPHelper.h"

CGSize ws;
@implementation Store

-(id) init
{
	if( (self=[super init])) {
        
        [self storeUI];
        
//        RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
//        [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
//            [fs showAd];
//            NSLog(@"Ad loaded Revmob");
//            [[CCDirector sharedDirector] pause];
//        } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
//            NSLog(@"Ad error Revmob: %@",error);
//        } onClickHandler:^{
//            NSLog(@"Ad clicked Revmob");
//        } onCloseHandler:^{
//            NSLog(@"Ad closed Revmob");
//            [[CCDirector sharedDirector] resume];
//        }];

        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    }
    
    return self;
}
- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            NSLog(@"Products List -==- %@",_products);
        }
    }];
}

-(void)storeUI {
    
    NSLog(@"Click Store Button");
    
    // Background Images
    
    ws = [CCDirector sharedDirector].winSize;
    CCSprite *spriteStore = [CCSprite spriteWithFile:@"sky.png"];
    
    spriteStore.position = ccp(ws.width/2, ws.height/2);
    [self addChild:spriteStore z:-1];
    
    CCSprite *spriteStoreTitle = [CCSprite spriteWithFile:@"store tilte.png"];
    spriteStoreTitle.position=ccp(ws.width/2, ws.height-45);
    [self addChild:spriteStoreTitle];
    
    CCMenuItem *menuItemBack = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"back.png" target:self selector:@selector(back:)];
    
    CCMenu *menuBack = [CCMenu menuWithItems: menuItemBack, nil];
    menuBack.position = ccp(40, ws.height-35);
    [menuBack alignItemsHorizontally];
    [self addChild:menuBack z:100];
    
    /*
    CCMenuItem *menuItemRestore = [CCMenuItemImage itemWithNormalImage:@"restore_p.png" selectedImage:@"restore_p.png" target:self selector:@selector(restoreBtnPressed:)];
    
    CCMenu *menuRestore=[CCMenu menuWithItems:menuItemRestore, nil];
    menuRestore.position=ccp(ws.width/2-10, 30);
    [self addChild:menuRestore z:100];
    */
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //==============================================================================
    
    
    keyChainMultiArrow = [[KeychainItemWrapper alloc] initWithIdentifier:@"powerboosters" accessGroup:nil];
    
    
    // Multi Arrow UI
    
    
    CCSprite *spriteMultiArrow = [CCSprite spriteWithFile:@"multi arrow.png"];
    spriteMultiArrow.position=ccp(155, ws.height-170);
    [self addChild:spriteMultiArrow];
    
    
    NSString *numMultipleArrows = [keyChainMultiArrow objectForKey:(__bridge id)kSecValueData];
    int retrievedMultipleArrows = [numMultipleArrows intValue];
    CCMenuItem *menuItemMultiArrow;
    
    if (retrievedMultipleArrows>0) {
        menuItemMultiArrow  = [CCMenuItemImage itemWithNormalImage:@"cross buy.png" selectedImage:@"cross buy.png" target:self selector:@selector(crossBuyClicked)];
    }
    
    else {
        menuItemMultiArrow  = [CCMenuItemImage itemWithNormalImage:@"buy.png" selectedImage:@"buy.png" target:self selector:@selector(multiArrowAction:)];
    }
    
    CCMenu *menuMultiArrow = [CCMenu menuWithItems: menuItemMultiArrow, nil];
    menuMultiArrow.position = ccp(390, ws.height-170);
    [menuMultiArrow alignItemsHorizontally];
    [self addChild:menuMultiArrow z:100];
    
    // =========================================================================
    // Power Booster UI
    
    CCSprite *spriteBoosterArrow = [CCSprite spriteWithFile:@"3 booster arrow.png"];
    spriteBoosterArrow.position=ccp(170, ws.height-110);
    [self addChild:spriteBoosterArrow];

    
    NSString *numpowerBooster = [keyChainMultiArrow objectForKey:(__bridge id)kSecAttrAccount];
    
    int retrievednumpowerBoosterArrows = [numpowerBooster intValue];
    NSLog(@" Booster arrow  -==- %d",retrievednumpowerBoosterArrows);
    
    CCMenuItem *menuItemBoosterArw;
    
    if (retrievednumpowerBoosterArrows>0) {
        menuItemBoosterArw = [CCMenuItemImage itemWithNormalImage:@"cross buy.png" selectedImage:@"cross buy.png" target:self selector:@selector(crossBuyClicked)];
    }
    else{
        menuItemBoosterArw = [CCMenuItemImage itemWithNormalImage:@"buy.png" selectedImage:@"buy.png" target:self selector:@selector(boosterArwAction:)];
    }
    
    
    CCMenu *menuBoosterArrow = [CCMenu menuWithItems: menuItemBoosterArw, nil];
    menuBoosterArrow.position = ccp(390, ws.height-110);
    [menuBoosterArrow alignItemsHorizontally];
    [self addChild:menuBoosterArrow z:100];
    
    
    // =============================================================================
    // Extra Life UI
    
    CCSprite *spriteExtraLife = [CCSprite spriteWithFile:@"5life.png"];
    spriteExtraLife.position=ccp(100, ws.height-230);
    [self addChild:spriteExtraLife];

    
    NSString *numLife = [keyChainMultiArrow objectForKey:(__bridge id)kSecAttrLabel];
    int retrievedLife = [numLife intValue];
    CCMenuItem *menuItemExtraLife;
    
    if (retrievedLife>0) {
        menuItemExtraLife  = [CCMenuItemImage itemWithNormalImage:@"cross buy.png" selectedImage:@"cross buy.png" target:self selector:@selector(crossBuyClicked)];
    }
    
    else {
        menuItemExtraLife  = [CCMenuItemImage itemWithNormalImage:@"buy.png" selectedImage:@"buy.png" target:self selector:@selector(extraLifeAction:)];
    }

    
    CCMenu *menuExtraLife = [CCMenu menuWithItems: menuItemExtraLife, nil];
    menuExtraLife.position = ccp(390, ws.height-230);
    [menuExtraLife alignItemsHorizontally];
    [self addChild:menuExtraLife z:100];
}

#pragma mark
#pragma mark Button methods
#pragma mark ==============================================

-(void)back:(id)sender {
    [activityInd stopAnimating];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameIntro scene]]];
}
-(void)crossBuyClicked{
    
    NSLog(@"Product is already purchased....");
    
}
-(void)extraLifeAction:(id)sender {
    
    UINavigationController *rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
    
    activityInd=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(ws.width/2, ws.height/2, 50, 50)];
    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityInd.color=[UIColor redColor];
    [rootViewController.view addSubview:activityInd];
    [activityInd startAnimating];
    
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        NSLog(@"Products -==--= %@",products);
        if (success) {
           
            if (products.count <=0) {
                
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            else{
                SKProduct *product = products[2];
                
                NSLog(@"Buying %@...", product.productIdentifier);
                
                [[RageIAPHelper sharedInstance] buyProduct:product];
            }
        }
        [activityInd stopAnimating];
    }];
}

-(void)multiArrowAction:(id)sender {
    
    UINavigationController *rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
    
    activityInd=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(ws.width/2, ws.height/2, 50, 50)];
    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityInd.color=[UIColor redColor];
    [rootViewController.view addSubview:activityInd];
    [activityInd startAnimating];
    
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
    if (success) {
        //            [GameState sharedState].productsForSell = products;
        //            NSLog(@"Products -=-= %@",[GameState sharedState].productsForSell);
        //            _products = products;
        if (products.count <=0) {
            
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            SKProduct * product =  products[1];
            
            NSLog(@"Buying %@...", product.productIdentifier);
            [[RageIAPHelper sharedInstance] buyProduct:product];
        }
    }
    [activityInd stopAnimating];
    }];
}

-(void)boosterArwAction:(id)sender {
    //    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"booster"];
    
    UINavigationController *rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
    
    activityInd=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(ws.width/2, ws.height/2, 50, 50)];
    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityInd.color=[UIColor redColor];
    
    [rootViewController.view addSubview:activityInd];
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"powerBooster"];
    
    [activityInd startAnimating];
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            
            if (products.count <=0) {
                
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            else{
                SKProduct * product =  products[3];
                
                NSLog(@"Buying %@...", product.productIdentifier);
                [[RageIAPHelper sharedInstance] buyProduct:product];
                
                //                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"powerBooster"];
            }
        }
        [activityInd stopAnimating];
    }];
}
-(void)restoreBtnPressed:(id)sender {
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}

-(void)dealloc {
    
    [super dealloc];
}
@end
