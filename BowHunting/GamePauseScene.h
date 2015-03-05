//
//  GamePauseScene.h
//  JungleFruitRun
//
//  Created by Sumit Ghosh on 09/09/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLayer.h"
#import "AppDelegate.h"

@class ActionScene;
@class ActionLayer;

@interface GamePauseLayer : CCLayer<AppDelegateDelegate>{
    CCMenuItemLabel *resumeMenuItem;
    CCMenuItemLabel *labelMenuItem;
}

@end
@interface GamePauseScene : CCScene {
    GamePauseLayer *layer;
}

@end


