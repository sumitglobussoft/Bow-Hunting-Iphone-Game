//
//  GameState.h
//  BowHunting
//
//  Created by Sumit Ghosh on 25/03/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, assign) int levelNumber;
@property (nonatomic, assign) int latestScore;
@property (nonatomic, assign) int remLife,birdsShooted;
@property (nonatomic, assign) BOOL checkLevelClear,networkStatus,screenForPlay;
@property (nonatomic, assign) NSMutableString * shareDecide,*selectedFrndsStringTag;
@property (nonatomic, assign) BOOL checkLife,shareOnfb;
@property (nonatomic, assign) BOOL checkBooster,failToLoadBanner;
@property (nonatomic, strong) NSArray *friendsScoreArray;
@property (nonatomic,strong) UIView * bannerAddView;
+(GameState *)sharedState;

@end
