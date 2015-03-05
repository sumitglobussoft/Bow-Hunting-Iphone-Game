//
//  AppDelegate.h
//  BowHunting
//
//  Created by tang on 12-9-24.
//  Copyright tang 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
//#import "RevMob.h"
#import <sqlite3.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "RootViewController.h"
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>
#import "FHSTwitterEngine.h"
#import "IAPHelper.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import <CommonCrypto/CommonDigest.h>
@class RootViewController;

@protocol AppDelegateDelegate <NSObject>
@optional
-(void)updateAfterRequestSent:(BOOL)value;
-(void)displayFacebookFriendsList;
-(void) hideFacebookFriendsList;
@end

#define TwitterConsumerKey @"8tPJwSbSjvGbZ8f58c3lbIGOG"
#define TwitterConsumerSecret @"eEByIYiqHcuQZ8zecZVIwNaHFmxagpEObqZTAcZYOQ2cFivL4g"


@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate, FHSTwitterEngineAccessTokenDelegate,IAPHelperDelegate,ChartboostDelegate, CBNewsfeedDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
    sqlite3 *_databaseHandle;

	CCDirectorIOS	*director_;// weak ref
    FBFrictionlessRecipientCache* ms_friendCache;
    NSMutableArray * localData;
    
    //    revmob::RevMob *revMob;
    BOOL videoWatched,master;
    UIActivityIndicatorView *activityInd;
}
@property (nonatomic, strong) id <AppDelegateDelegate> delegate;

@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, assign) NSInteger CurrentValue;
@property(nonatomic,strong) NSMutableString *friendsList;
@property(nonatomic,assign)int friendsCount;
@property (nonatomic, strong) NSDictionary *openGraphDict;

-(UINavigationController *) getRootViewController;
- (BOOL)openSessionWithAllowLoginUI:(NSInteger)isLoginReq;

-(BOOL) openSessionWithLoginUI:(NSInteger)value withParams: (NSDictionary *)dict;
-(void) shareOnFacebookWithParams:(NSDictionary *)params;
-(void)shareOnFacebook;
-(void) sendRequestToFriends:(NSDictionary *)params;
-(void) storyPostwithDictionary:(NSDictionary *)dict;
-(void) sendRequestToFriendsTaggable:(NSMutableString *)params;
#pragma mark -
-(void)fullPackArwAction:(id)sender;
#pragma mark - 
-(void) twitterAuthorization;
-(void) postTweet;
@end
