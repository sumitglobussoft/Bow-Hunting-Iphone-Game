//
//  BowHuntingTitle.h
//  BowHunting
//
//  Created by tang on 12-10-2.
//  Copyright (c) 2012年 tang. All rights reserved.
//

#import "CCSprite.h"

@interface BowHuntingTitle : CCSprite{
    NSMutableArray *titleArr;
}
-(void)stop;
@property(nonatomic,retain) NSMutableArray *titleArr;

@end
