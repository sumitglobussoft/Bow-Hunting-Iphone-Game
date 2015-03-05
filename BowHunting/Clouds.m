//
//  Clouds.m
//  BowHunting
//
//  Created by tang on 12-9-29.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "Clouds.h"
#import "cocos2d.h"
CGSize ws;
@implementation Clouds

@synthesize clip1,clip2,clip3,clip4;


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		ws=[[CCDirector sharedDirector]winSize];
        
         
        clip1=[CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
        clip2=[CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
        clip3=[CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
        clip4=[CCSprite spriteWithSpriteFrameName:@"cloud3.png"];
        
        clip1.position=ccp(clip1.contentSize.width/2,-clip1.contentSize.height/2);
        clip2.position=ccp(ws.width,-80);
        clip3.position=ccp(220,-200);
        clip4.position=ccp(300,-80);
        
        [self addChild:clip1];
        [self addChild:clip2];
        [self addChild:clip3];
        [self addChild:clip4];

        [self start];
	}
	return self;
}
//move clouds

-(void) loop{
    float sp=0.2;
    clip1.position=ccp(clip1.position.x-1*sp,clip1.position.y);
    clip2.position=ccp(clip2.position.x-0.5*sp,clip2.position.y);
    clip3.position=ccp(clip3.position.x-1.5*sp,clip3.position.y);
    clip4.position=ccp(clip4.position.x-0.3*sp,clip4.position.y);
    
    if(clip1.position.x<=-clip1.contentSize.width/2){
        clip1.position=ccp(ws.width+clip1.contentSize.width/2,clip1.position.y);
    }
    if(clip2.position.x<=-clip2.contentSize.width/2){
        clip2.position=ccp(ws.width+clip2.contentSize.width/2,clip2.position.y);
    }
    if(clip3.position.x<=-clip3.contentSize.width/2){
        clip3.position=ccp(ws.width+clip3.contentSize.width/2,clip3.position.y);
    }
    if(clip4.position.x<=-clip4.contentSize.width/2){
        clip4.position=ccp(ws.width+clip4.contentSize.width/2,clip4.position.y);
    }
}

//stop move clouds

-(void)stop{
    [self unschedule:@selector(loop)];
}

//start move clouds
-(void)start{
    [self schedule:@selector(loop)];
}
-(void)dealloc{
    
    [super dealloc];
}
@end
