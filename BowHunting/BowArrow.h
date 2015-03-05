//
//  BowArrow.h
//  BowHunting
//
//  Created by tang on 12-9-30.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
@interface BowArrow : CCSprite{
    CCSprite *bow, *arrow;
    CCAnimate * bowMovie;
    CCAnimation * animObj;
    NSMutableArray *bowArr;
    BOOL shootAble;
}
-(void)playShootMovie;
@property(nonatomic,retain) CCSprite *bow,*arrow;
@property(nonatomic,retain) NSMutableArray *bowArr;
@property(nonatomic,assign) CCAnimate *bowMovie;
@property(nonatomic,retain) CCAnimation *animObj;
@property(nonatomic,assign) BOOL shootAble;

@end
