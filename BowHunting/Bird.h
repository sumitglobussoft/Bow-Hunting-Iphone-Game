//
//  Bird.h
//  BowHunting
//
//  Created by tang on 12-9-30.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "CCSprite.h"

@interface Bird : CCSprite{
    CCSprite *ani,*arrow;
    NSString *dir;
    float speed,baseSpeed,overDis,upSpeed,fallVy,memorySpeed;
    int delay;
    BOOL isDead;
    
    id gm;
     
    NSMutableArray *flyArr;
}
-(void) fallWithArrowRotation:(float) rt;
//RAJEEV
-(void) fallAllBirds;
-(void) stop;
-(void) loop;
 
-(id) initWithSpeed:(float) sp;
-(void) reset;

@property(nonatomic,retain) CCSprite *ani,*arrow;
@property(nonatomic,retain) NSString *dir;
@property(nonatomic,assign) float speed,baseSpeed,overDis,upSpeed,fallVy,memorySpeed;
@property(nonatomic,assign) int delay;
@property(nonatomic,assign) BOOL isDead;
@property(nonatomic,retain) NSMutableArray *flyArr;
@property(nonatomic,assign) id gm;

@end
