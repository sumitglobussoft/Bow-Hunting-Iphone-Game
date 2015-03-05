//
//  GameState.m
//  BowHunting
//
//  Created by Sumit Ghosh on 25/03/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "GameState.h"

@implementation GameState

static GameState *_sharedState = nil;

+ (GameState *)sharedState {
    if (!_sharedState) {
        _sharedState = [[GameState alloc] init];
    }
    return _sharedState;
}

- (id)init {
    
    if ((self = [super init])) {
        
    }
    return self;
}

@end
