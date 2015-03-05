//
//  BowArrow.m
//  BowHunting
//
//  Created by tang on 12-9-30.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "BowArrow.h"
#import "cocos2d.h"
@implementation BowArrow
@synthesize bow,bowMovie,animObj,bowArr,arrow,shootAble;
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        self.shootAble=YES;
        self.bow=[ CCSprite spriteWithSpriteFrameName:@"bowAni0001.png" ];
        [self addChild:self.bow];
        
        self.bowArr=[NSMutableArray array];
        
        for (int i=1; i<=10; i++) {
            
            NSString *bowSpriteStr;
            if(i<10){
                bowSpriteStr=[NSString stringWithFormat:@"bowAni000%i.png",i];
                
            }else{
                bowSpriteStr=[NSString stringWithFormat:@"bowAni00%i.png",i];
            }
            [self.bowArr addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:bowSpriteStr]];
        }
        self.animObj=[CCAnimation animationWithSpriteFrames:self.bowArr delay:0.01];
        //self.bowMovie=[CCAnimate actionWithAnimation:self.animObj];
        
        self.arrow=[CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        self.arrow.anchorPoint=ccp(1,0.5);
        self.arrow.position=ccp(30,0);
        [self addChild:self.arrow];
	}
	return self;
}

//play shoot movie
-(void)playShootMovie{
    
    if(self.shootAble){
      [self.bow runAction:[CCAnimate actionWithAnimation:self.animObj]];
      [self.arrow setVisible:NO];
      self.shootAble=NO;
      [self unschedule:@selector(delayRun)];
      [self schedule:@selector(delayRun) interval:0.6];
    }
}
//delay
-(void)delayRun{
    [self unschedule:@selector(delayRun)];
    self.shootAble=YES;
    [self.arrow setVisible:YES];
}
-(void)dealloc{
    [super dealloc];
}
@end
