//
//  SwitchButton.m
//  BowHunting
//
//  Created by tang on 12-10-1.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "SwitchButton.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
@implementation SwitchButton
@synthesize isOpen,playMI,playButton,playButton2,playMI2;


-(id) init{
        // always call "super" init
        // Apple recommends to re-assign "self" with the "super's" return value
        if( (self=[super init]) ) {
        }
        return self;
}
-(void) initWithImageStr:(NSString *) o1 O2:(NSString*)o2 O3:(NSString*)o3 O4:(NSString*)o4 Open:(BOOL) open
{
    self.playMI=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:o1] selectedSprite:[CCSprite spriteWithSpriteFrameName:o2] target:self selector:@selector(btnClick)];
    self.playButton=[CCMenu menuWithItems:self.playMI, nil];
    
    self.playMI2=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:o3] selectedSprite:[CCSprite spriteWithSpriteFrameName:o4] target:self selector:@selector(btnClick)];
    self.playButton2=[CCMenu menuWithItems:self.playMI2, nil];
    
    self.playButton.position=ccp(0,0);
    [self addChild:self.playButton];
    
    self.playButton2.position=ccp(0,0);
    [self addChild:self.playButton2];
    
    self.isOpen=open;
    
            if(open==YES){
                self.playButton.visible=YES;
                self.playButton2.visible=NO;
           }
            else{
                self.playButton.visible=NO;
                self.playButton2.visible=YES;
           }
}

//button clicked handler

-(void) btnClick{
    if(self.isOpen){
        self.playButton2.visible=YES;
        self.playButton.visible=NO;
        [[SimpleAudioEngine sharedEngine]stopBackgroundMusic ];
    }
    else{
        self.playButton2.visible=NO;
        self.playButton.visible=YES;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"snd_bg.wav" loop:YES];
    }
    self.isOpen=!self.isOpen;
}
-(void)dealloc {
    
    [super dealloc];
}
@end
