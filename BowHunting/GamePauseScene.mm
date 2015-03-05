//
//  GamePauseScene.m
//  JungleFruitRun
//
//  Created by Sumit Ghosh on 09/09/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GamePauseScene.h"
#import "GameIntro.h"
#import "Clouds.h"
#import "GameState.h"
@implementation GamePauseScene
- (id)init {
    if ((self = [super init])) {
        
        layer = [[[GamePauseLayer alloc] init] autorelease];
        [self addChild:layer];
    }
    return self;
}
@end

@implementation GamePauseLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GamePauseLayer *layer = [GamePauseLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    
    if ((self = [super init])) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *spriteSubMenu = [CCSprite spriteWithFile:@"gameOverSky.png"];
        spriteSubMenu.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:spriteSubMenu z:0];
        
        Clouds *c=[[[Clouds alloc]init] autorelease];
        c.position=ccp(0,winSize.height);
        [self addChild:c];
        
        CCMenuItem *menuResume = [CCMenuItemImage itemWithNormalImage:@"resume.png" selectedImage:@"resume.png" target:self selector:@selector(actionResume:)];
        
        CCMenuItem *menuMainMenu = [CCMenuItemImage itemWithNormalImage:@"menu.png" selectedImage:@"menu.png" target:self selector:@selector(loadingMenu)];
        
        CCMenu  *menu1 = [CCMenu menuWithItems: menuResume, nil];
        menu1.position = ccp(winSize.width/2, winSize.height/2+40);
        [menu1 alignItemsHorizontally];
        [self addChild:menu1 z:100];
        
        CCMenu *menu2 = [CCMenu menuWithItems: menuMainMenu, nil];
        menu2.position = ccp(winSize.width/2, winSize.height/2-40);
        [menu2 alignItemsHorizontally];
        [self addChild:menu2 z:100];
    }
    return self;
}
-(void)actionResume:(id)sender
{
    
    [[CCDirector sharedDirector] popScene];
}

-(void)loadingMenu {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int life = (int)[userDefault integerForKey:@"life"];
    life--;
    if (life<0) {
        life = 0;
    }
    [userDefault setInteger:life forKey:@"life"];
    NSString *str =[userDefault objectForKey:@"currentDate"];

    if (life<5 && [str isEqualToString:@"0"]) {
        
        NSDate* now = [NSDate date];
        //NSLog(@"%@ seconds since recevedData was called last", now);
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        NSString *dateStr = [df stringFromDate:now];
        
        [userDefault setObject:dateStr forKey:@"currentDate"];
        [df autorelease];
    }
    
    [userDefault synchronize];
    [userDefault synchronize];
    [[GameState sharedState].bannerAddView removeFromSuperview];
    [[CCDirector sharedDirector] replaceScene:[GameIntro node]];
}
-(void) dealloc{
       
	[super dealloc];
}

#pragma mark -

@end