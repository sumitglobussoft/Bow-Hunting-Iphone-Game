//
//  FriendsViewController.h
//  CaveRun
//
//  Created by GBS-ios on 8/18/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SBJson.h"
#import <FacebookSDK/FacebookSDK.h>


@protocol FriendsViewControllerDelegate <NSObject>

-(void) updatePurchaseScene:(BOOL)value;

@end

@interface FriendsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, AppDelegateDelegate>

@property (nonatomic, unsafe_unretained) id <FriendsViewControllerDelegate> delegate;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) NSArray *friendListArray;
@property (nonatomic, retain) NSMutableArray *selectedFriendsArray;
@property (nonatomic, retain) NSDictionary *paramDict;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, assign) BOOL isLifeRequest;
@property (nonatomic, strong) UITableView *listTableView;

-(void) updateFriendsView;
-(id)initWithHeaderTitle:(NSString *)headerTitle;

@end
