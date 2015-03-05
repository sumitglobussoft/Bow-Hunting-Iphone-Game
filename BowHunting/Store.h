//
//  Store.h
//  BowHunting
//
//  Created by Sumit Ghosh on 09/04/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "CCSprite.h"
#import "CCLayer.h"
#import "cocos2d.h"
#import "KeychainItemWrapper.h"
#import "AppDelegate.h"

@interface Store : CCSprite {
    
    //    KeychainItemWrapper *keyChainPowerBooster;
    KeychainItemWrapper *keyChainMultiArrow;
    UIActivityIndicatorView *activityInd;
    
     NSArray *_products;
}

@end
