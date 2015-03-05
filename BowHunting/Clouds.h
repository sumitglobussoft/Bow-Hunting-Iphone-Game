//
//  Clouds.h
//  BowHunting
//
//  Created by tang on 12-9-29.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "CCSprite.h"

@interface Clouds : CCSprite
{
    CCSprite *clip1,*clip2,*clip3,*clip4;
}
-(void)stop;
-(void)start;

@property(nonatomic ,retain) CCSprite *clip1,*clip2,*clip3,*clip4;

@end
