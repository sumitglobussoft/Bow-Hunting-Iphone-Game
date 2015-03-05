//
//  BowHuntingTitle.m
//  BowHunting
//
//  Created by tang on 12-10-2.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "BowHuntingTitle.h"
#import "cocos2d.h"
@implementation BowHuntingTitle
@synthesize titleArr;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        self.titleArr=[[NSMutableArray alloc]init];
         
        for (int i=1; i<=10; i++) {
            NSString *str;
            if(i<10){
                str=[NSString stringWithFormat:@"char000%i.png",i];
            }
            else{
                str=[NSString stringWithFormat:@"char00%i.png",i];
            }
            CCSprite *tc=[CCSprite spriteWithSpriteFrameName:str];
            tc.position=ccp((i-1+(i>3?1:0))*36,tc.position.y-320);
            [self addChild:tc];
            
            id delay=[CCDelayTime actionWithDuration:i*0.2];
            id scaleTo=[CCMoveTo actionWithDuration:1.20f position:CGPointMake(tc.position.x, 0)];
            id ease=[CCEaseBackOut actionWithAction:scaleTo];
            id seq=[CCSequence actions:delay, ease,nil];
            [tc runAction:seq];
           
            [self.titleArr addObject:tc];
        }
    }
    return self;
}


-(void)stop{
    for (int i=0; i<[self.titleArr count]; i++) {
        
        [(CCSprite *)[self.titleArr objectAtIndex:i]stopAllActions];
    }
}
-(void)dealloc{

    [super dealloc];
}
@end
