//
//  Bird.m
//  BowHunting
//
//  Created by tang on 12-9-30.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "Bird.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
//#import "GameMain.h"
#import "GameState.h"
CGSize ws;
@implementation Bird
@synthesize ani,arrow,dir,speed,delay,baseSpeed,overDis,isDead,upSpeed,fallVy,memorySpeed,flyArr,gm;

// on "init" you need to initialize your instance
-(id) initWithSpeed:(float) sp
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        self.fallVy=-0.08;
        self.arrow=[CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        self.arrow.anchorPoint=ccp(0.8,0.5);
        [self addChild:self.arrow];
        self.arrow.visible=NO;
    
        ws=[[CCDirector sharedDirector]winSize];
       
        self.speed=sp*(0.60f+((float)((arc4random()%40)/100.0f)));
        
//        NSLog(@"Speed of Bird for Level -=-=%f -- %f",self.speed,sp);
        self.memorySpeed=self.speed;
        
        self.ani=[CCSprite node];
        
        [self addChild:self.ani];
        
        self.flyArr=[NSMutableArray array];
        
        for (int i=1; i<=30; i++) {
            
            NSString *flySpriteStr;
            if(i<10){
                flySpriteStr=[NSString stringWithFormat:@"birdFly000%i.png",i];
                
            }else{
                flySpriteStr=[NSString stringWithFormat:@"birdFly00%i.png",i];
            }
            id flySprite=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:flySpriteStr];
            
            [self.flyArr addObject:flySprite];
        }
        
        [self.ani runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:self.flyArr delay:0.02]]]];
        [self schedule:@selector(loop)];
        
        [self reset];
	}
	return self;
}
//reset 
-(void) reset{
    self.speed=self.memorySpeed;
    self.overDis=arc4random()%80+20;
    self.upSpeed=1.8;
    
    if(arc4random()%10>=5){
        
        speed=fabsf(speed);
        //go left
        speed=-speed;
        self.position=ccp(ws.width+self.ani.contentSize.width/2+self.overDis,arc4random()%150+100);
        self.scaleX=1;
    }
    else{
        speed=fabsf(speed);
        //go right
        
        self.position=ccp(-self.ani.contentSize.width/2-self.overDis,arc4random()%150+100);
        self.scaleX=-1;
    }
    self.rotation=0;
    self.isDead=NO;
    self.arrow.visible=NO;
    [self.ani stopAllActions];
    [self.ani runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:self.flyArr delay:0.02]]]];
}

//fall

-(void) fallWithArrowRotation:(float) rt{
    
    self.arrow.visible=YES;
    
    self.isDead=YES;
    
    self.arrow.rotation=rt;
    
    [self.ani stopAllActions];
    
    if(arc4random()%100>50){
        [[SimpleAudioEngine sharedEngine]playEffect:@"geese_die1.wav"];
    }
    else{
        [[SimpleAudioEngine sharedEngine]playEffect:@"geese_die2.wav"];
    }
}

// Rajeev
-(void) fallAllBirds {
    
    self.arrow.visible=YES;
    
    self.isDead=YES;
    
//    self.arrow.rotation=rt;
    
    [self.ani stopAllActions];
    
    if(arc4random()%100>50){
        [[SimpleAudioEngine sharedEngine]playEffect:@"geese_die1.wav"];
    }
    else{
        
        [[SimpleAudioEngine sharedEngine]playEffect:@"geese_die2.wav"];
    }

}
-(void)stop{
    
}
//the main loop
-(void)loop{
    
    if(!self.isDead){

        self.position=ccp(self.position.x+self.speed+(([GameState sharedState].levelNumber*0.1)*(self.speed>0?1:-1)),self.position.y);
        if(self.speed>0&&self.position.x>=ws.width+self.ani.contentSize.width/2+self.overDis){
            self.speed*=-1.0f;
            self.scaleX*=-1.0f;
            self.position=ccp(self.position.x,arc4random()%150+100);
        }
    
        if(self.speed<0&&self.position.x<=-self.ani.contentSize.width/2-self.overDis)
        {
            self.speed*=-1.0f;
            self.scaleX*=-1.0f;
            self.position=ccp(self.position.x,arc4random()%150+100);
        }
    }
    else{
        
        self.speed+=(0-self.speed)/30;
        self.upSpeed+=self.fallVy;
        self.position=ccp(self.position.x+self.speed,self.position.y+self.upSpeed);
        
        self.rotation+=0.5;
        
        if(self.position.y<-50){
            [[SimpleAudioEngine sharedEngine]playEffect:@"snd_gress.wav"];
            [self reset];
        }
    }
}
-(void)dealloc{
    
    [super dealloc];
}
@end
