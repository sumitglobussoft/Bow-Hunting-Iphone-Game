//
//  FriendsInLevel.h
//  BowHunting
//
//  Created by GLB-254 on 12/8/14.
//  Copyright 2014 tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FriendsInLevel : CCLayer
{
    UIViewController *viewController;
    CCSprite *levelBackground;
    CCSprite *spriteBackground ;
    UIButton *playButton;
    UIScrollView *scrollV ;
    UIView *secondView ;
    UILabel *friendsLevel;
   UILabel * position;
    UIImageView *profileImageView;
    
}
@property (nonatomic,assign)BOOL musicIsOn;
+(CCScene *) scene;
@end
