//
//  RootViewController.h
//  BowHunting
//
//  Created by Sumit Ghosh on 01/04/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface RootViewController : UIViewController {
    
    UIView *customView;
    UINavigationController *rootViewController;
    
    NSUserDefaults *userDefault;
    BOOL addNewLifeCheck;
}

@property(nonatomic, retain) NSString *strSenderFbId;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSString *currentUserName;
@property(nonatomic,retain)NSArray *requestIDsAry;
@property(nonatomic)NSInteger *count;
@end
