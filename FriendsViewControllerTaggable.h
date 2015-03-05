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
#import "MBProgressHUD.h"

@interface FriendsViewControllerTaggable : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, AppDelegateDelegate>
{
    MBProgressHUD *HUD;
    BOOL *check;
    UILabel *titleLabel;
    BOOL buttonCheck;
    AppController * appDelegate;
    UIView * backgroundView;
 UINavigationController *rootViewController;
}

@property (nonatomic, retain) UIImageView *headerView;
@property (nonatomic, retain) NSArray *friendListArray;
@property (nonatomic, retain) NSMutableArray *selectedFriendsArray;
@property (nonatomic, retain) NSMutableArray *selectedTagFriendsArray;
@property (nonatomic, retain) NSDictionary *paramDict;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSString *headerTitle;
@property(nonatomic,assign) int friendsCount;
@property(nonatomic,strong)UIButton *checkButton;
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)UILabel *noteLabel;

@property (nonatomic, strong) UICollectionView *listTableView;

-(id)initWithHeaderTitle:(NSString *)headerTitle;

@end
