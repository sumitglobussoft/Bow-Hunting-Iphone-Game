//
//  GameOver.m
//  BowHunting
//
//  Created by tang on 12-10-2.
//  Copyright (c) 2012年 tang. All rights reserved.
//
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"
#import "GameOver.h"
#import "cocos2d.h"
#import "GameMain.h"
#import "Clouds.h"
#import "GameState.h"
#import "LifeOver.h"
#import "GameIntro.h"
#import "SBJson.h"
#import <FacebookSDK/FacebookSDK.h>
#import <sqlite3.h>
#import "RootViewController.h"
#import "LevelSelectionScene.h"

#define ShareToFacebook @"FacebookShare"


CGSize ws;
@implementation GameOver
@synthesize gm,playButton,scoreText,strPostMessage,shareText,shareOnFb,shareButtons,levelCompletionText,levelText,gameOverText,menuBack,playMI;

-(id) init
{
	if( (self=[super init])) {
        
        //Rajeev
        
//        RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
//        [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
//            [fs showAd];
//            //NSLog(@"Ad loaded Revmob");
//            [[CCDirector sharedDirector] pause];
//        } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
//            //NSLog(@"Ad error Revmob: %@",error);
//        } onClickHandler:^{
//            //NSLog(@"Ad clicked Revmob");
//        } onCloseHandler:^{
//            //NSLog(@"Ad closed Revmob");
//            [[CCDirector sharedDirector] resume];
//        }];
        [Chartboost showInterstitial:CBLocationHomeScreen];
        //------------
        beatedFriendObjects=[[NSMutableArray alloc]init];
        //------------
        userDefault = [NSUserDefaults standardUserDefaults];
        
        strPostMessage=[[NSString alloc]init];
        levelCompletionText=[[NSString alloc]init];
        
        ws=[[CCDirector sharedDirector]winSize];
        
        //create sky etc..
        
        CCSprite *sky=[CCSprite spriteWithFile:@"score_bg5.png"];
        sky.position=ccp(ws.width/2,ws.height/2);
        [self addChild:sky];
        

        self.levelText=[CCLabelBMFont labelWithString:@"123456" fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
        self.levelText.position=ccp(ws.width/2+15, ws.height-15);
        self.levelText.color=ccRED;
        [self addChild:self.levelText];
        

        
        //add score text
        
        self.scoreImage=[CCSprite spriteWithFile:@"score_cld.png"];
        self.scoreImage.position=ccp(ws.width/2, ws.height/2);
        [self addChild:self.scoreImage];
        

        self.scoreText=[CCLabelBMFont labelWithString:@" 123456" fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
        self.scoreText.position=ccp(180,75);
        [self.scoreImage addChild:self.scoreText];
        
        self.playMI=[CCMenuItemImage itemWithNormalImage:@"" selectedImage:@"" target:self selector:@selector(playAgianButtonClicked:)];
        
        CCMenu *menu6 = [CCMenu menuWithItems:self.playMI, nil];
        menu6.position=ccp(ws.width/2+140, 80);
        [self addChild:menu6];
        
        self.gameOverText=[CCLabelBMFont labelWithString:@"Next Level coming soon" fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
        self.gameOverText.position=ccp(ws.width/2-20, 60);
        [self addChild:self.gameOverText];
        
        CCMenuItem *menuItemBack = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"back.png" target:self selector:@selector(back:)];
        
        menuBack = [CCMenu menuWithItems: menuItemBack, nil];
        menuBack.position = ccp(40, ws.height-35);
        [menuBack alignItemsHorizontally];
        [self addChild:menuBack z:100];
        BOOL networkStatus = [GameState sharedState].networkStatus;
         if(!(networkStatus==NO))
         {
//         if(!adm)
//         {
         adm= [[AdMobViewController alloc]initWithBOOL:YES];
         [GameState sharedState].bannerAddView =adm.view;
         [[[CCDirector sharedDirector] view] addSubview:adm.view];
        // }
         }

    }
    return self;
}

#pragma mark
#pragma mark Button Action methods
#pragma mark ==============================================

-(void)back:(id)sender {
    
    [self removeChild:c cleanup:YES];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameIntro scene]]];
}
//play again button clicked , start a new game

-(void)playAgianButtonClicked:(id)sender {
    [self removeChild:c cleanup:YES];
    [[GameState sharedState].bannerAddView removeFromSuperview];
    if (self.checkLevelClear) {
       
        [self nextAction:sender];
    }
    else{
        //remove
        
        [self playButtonClicked];
    }
}

-(void)storyPost
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL networkStatus = [GameState sharedState].networkStatus;//[[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        //return;
    }
    
    NSString *strLife = [NSString stringWithFormat:@"Level %d",self.levelCount];
   // NSString *title = [NSString stringWithFormat:@"Completed %@",strLife];
     NSString *title = [NSString stringWithFormat:@""];
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     strPostMessage, @"description", strLife, @"caption",
     @"https://itunes.apple.com/us/app/bow-hunting-chief/id853508979?ls=1&mt=8", @"link",@"Bow Hunting Chief",@"name",
     @"http://i.imgur.com/LaDdDX0.png?1",@"picture",
     nil];
    
    NSDictionary *storyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"level",FacebookType,title,FacebookTitle,strPostMessage,FacebookDescription,@"complete",FacebookActionType, nil];
    
    appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.openGraphDict = storyDict;
    
    if (FBSession.activeSession.isOpen) {
        
        [appDelegate shareOnFacebookWithParams:params];
    }
    else{
        [appDelegate openSessionWithLoginUI:1 withParams:params];
    }
    
    if (self.lblFbFirstName) {
        [self scheduleOnce:@selector(beatFriendStoryPost) delay:1.2];
        [self pushForBeatedFriend];
    }
    
    if(isNewHighScore == YES){
        [self scheduleOnce:@selector(newHighScoreStoryPost) delay:1.2];
    }
    
}



-(void)facebookBtn_Click
{
    
    CGRect frame = [UIScreen mainScreen].bounds;
    NSLog(@"Frame in Gamover facebook_btn %f",frame.size.width);
    if(!fbFrnds)
    {
    fbFrnds = [[FriendsViewControllerTaggable alloc] initWithHeaderTitle:@"Ask Life"];//
    fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    
    [UIView animateWithDuration:1 animations:^{
        
        fbFrnds.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [rootViewController.view addSubview:fbFrnds.view];
    }];
    }
}

//for fb
/*
-(void)facebookBtn_Click
{
    BOOL networkStatus =[GameState sharedState].networkStatus; //[[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
   // [Chartboost showInterstitial:CBLocationHomeScreen];

    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    NSString *strLife = [NSString stringWithFormat:@"Completed Level %d in Bow Hunting Chief. Hi Friends, Please join me in Bow Hunting Chief. Select your arrows and hunt as many birds as you can and get more points. Lets see who is the best hunter amongst us!",self.levelCount];
    
    
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     strLife, @"description",
     @"https://www.facebook.com/games/bowhuntingchief", @"link",@"Bow Hunting Chief",@"name",
     @"http://i.imgur.com/LaDdDX0.png?1",@"picture",
     nil];
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:ShareToFacebook object:nil];
            
            //NSLog(@"result==%u",result);
            //NSLog(@"Url==%@",resultUrl);
            if (result == FBWebDialogResultDialogNotCompleted) {
                NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
                NSLog(@"User cancel Request");
            }//End Result Check
            else{
                NSString *sss= [NSString stringWithFormat:@"%@",resultUrl];
                if ([sss rangeOfString:@"post_id"].location == NSNotFound) {
                    NSLog(@"User Cancel Share");
                }
                else{
                    NSLog(@"posted on wall");
                }
            }//End Else Block Result Check
        }
    }];

}
 */
#pragma mark story post----
-(void) newHighScoreStoryPost{
    NSString *title = [NSString stringWithFormat:@"New highscore %ld",(long)self.levelScore];
    NSString *description = [NSString stringWithFormat:@"Hey i got new highscore %ld in level %ld!. Bow Hunting Chief is a unique game, it gives a sense of freshness every time you play it. Hunt more birds and Beat my score!!!! ""Try it up""!",(long)self.levelScore,(long)self.currentLevel];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"highscore",FacebookType,title,FacebookTitle,description,FacebookDescription,@"get",FacebookActionType, nil];
    
    appDelegate.openGraphDict = dict;
    [appDelegate storyPostwithDictionary:dict];
}
-(void) beatFriendStoryPost{
    
    //NSString *title = [NSString stringWithFormat:@"Beat %@",self.beatedFrndName];
      NSString *title = [NSString stringWithFormat:@""];
    NSString *description = [NSString stringWithFormat:@"Beat %@ at level %ld and got score %ld!. Bow Hunting Chief is a unique game, it gives a sense of freshness every time you play it. Hunt more birds and Beat my score!!!! ""Try it up""!",self.beatedFrndName,(long)self.currentLevel,(long)self.levelScore];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"friend",FacebookType,title,FacebookTitle,description,FacebookDescription,@"beat",FacebookActionType,@"name",@"Beat You", nil];
    
    appDelegate.openGraphDict = dict;
    [appDelegate storyPostwithDictionary:dict];
}
#pragma mark--
-(void)shareBeatedWithFacebookFriend
{
    NSString * str=[NSString stringWithFormat:@"%@ Beat You in Bow Hunting Chief!. Bow Hunting Chief is a unique game, it gives a sense of freshness every time you play it. Hunt more birds and Beat my score!!!! ""Try it up""!",[[NSUserDefaults standardUserDefaults]objectForKey:UserFbName]];
    
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    NSLog(@"Beated Friend %@ %@",fbID,beatedFriendObject);
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     str, @"description", @"Beat",@"caption",
     @"https://www.facebook.com/games/bowhuntingchief",@"link",@"Bow Hunting Chief",@"name",
     @"http://i.imgur.com/LaDdDX0.png?1",@"picture",beatedFriendObject,@"to",fbID,@"from",
     nil];
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          // User canceled.
                                                          NSLog(@"User cancelled.");
                                                      } else {
                                                          // Handle the publish feed callback
                                                      }
                                                  }
                                              }];
}

-(void)pushForBeatedFriend
{
    NSDictionary * data;
    PFQuery *pushQuery = [PFInstallation query];
    NSString * userName=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:UserFbName]];
    if([beatedFriendObjects count]>0)
    {
  [pushQuery whereKey:@"PLayerFacebookId" containedIn:beatedFriendObjects];
       // [pushQuery whereKey:@"PlayerFacebookId" equalTo:[beatedFriendObjects objectAtIndex:0]];
    // [pushQuery whereKey:@"deviceToken" equalTo:@"80785e001093e9705c392fe250428f658b2c4d45384f2c25ef205a78ebfbb8c7"];
        NSString * alertMessage=[NSString stringWithFormat:@"%@ Beat you in Bow Hunting Chief!",userName];
    data = @{
             @"Type": @"500",@"FriendName":userName,@"action": @"com.globussoft.bowhuntingchief",
             @"alert":alertMessage

             };

    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (succeeded) {
                NSLog(@"Successful Push send");
            }
        } else {
            NSLog(@"Push sending error: %@", [error userInfo]);
        }
    }];
    }
}
//Rajeev
// Show Life Over
#pragma mark-
-(void) playRestart{
    backView.hidden = YES;
    self.backgroundView.hidden=YES;
    [self.backgroundView release];
    [backView release];
    [self.backgroundView removeFromSuperview];
    LevelSelectionScene *obj = [[[LevelSelectionScene alloc]init:YES] autorelease];
    
    [self addChild:obj];;
}
-(void) displayGameCompletionView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbg2.png"]];
    backView.backgroundColor = [UIColor whiteColor];
    [rootViewController.view addSubview:backView];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.width+10, frame.size.height, frame.size.width)];
    containerView.backgroundColor = [UIColor clearColor];
    [backView addSubview:containerView];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, frame.size.height-20, 60)];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:20];
    headerLabel.textColor = [UIColor redColor];
    headerLabel.text = @"Congratulations!";
    [containerView addSubview:headerLabel];
    //--------
    NSString *updatedText = @"You finished all 40 levels in the game. Please rate us and give detailed feedback here .GlobusGames invites you to play our other exciting games in various genres.Visit www.globusgames.com for more.";
    
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:updatedText attributes:dict];
    
    [attributedString addAttribute:NSLinkAttributeName value:@"http://www.globusgames.com" range:[[attributedString string] rangeOfString:@"www.globusgames.com"]];
    [attributedString addAttribute:NSLinkAttributeName value:@"https://itunes.apple.com/in/app/bow-hunting-chief/id853508979?mt=8" range:[[attributedString string] rangeOfString:@"here"]];
    
    UIColor *linkColor = [UIColor colorWithRed:(CGFloat)77/255 green:(CGFloat)161/255 blue:(CGFloat)253/255 alpha:1];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:linkColor,NSUnderlineColorAttributeName: linkColor,NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(20, 110, frame.size.height-40, 100)];
    txtView.linkTextAttributes = linkAttributes;
    //txtView.selectable = NO;
    txtView.editable = NO;
    txtView.backgroundColor = [UIColor clearColor];
    txtView.delegate = self;
    [txtView setAttributedText:attributedString];
    [containerView addSubview:txtView];
    
    UIButton *playBtn =[UIButton buttonWithType: UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playRestart) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:playBtn];
    playBtn.frame = CGRectMake(frame.size.height/2-35, 230, 70, 35);
    [UIView animateWithDuration:3 animations:^{
        containerView.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    }completion:^(BOOL completed){
        
    }];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSLog(@"Url = %@",URL);
    //    if ([[URL scheme] isEqualToString:@"username"]) {
    //        NSString *username = [URL host];
    //        NSLog(@"Username == %@",username);
    //        // do something with this username
    //        // ...
    //        return NO;
    //    }
    //[[UIApplication sharedApplication] openURL:URL];
    return YES; // let the system open this URL
}

#pragma mark
#pragma mark Extras methods
#pragma mark ==============================================

-(void) showLifeOver {
    [self removeChild:c cleanup:YES];
    if(!self.lifeOverLayer){
        self.lifeOverLayer=[[[LifeOver alloc]init] autorelease];
        [self addChild:self.lifeOverLayer];
    }
    else{
        ((LifeOver*)self.lifeOverLayer).visible=YES;
    }
}

#pragma mark -
#pragma mark Display New UI
-(void)nextAction:(id)sender
{//creating ui
    
   
     [Chartboost showInterstitial:CBLocationHomeScreen];    //[self shareBeatedWithFacebookFriend];
    [[GameState sharedState].bannerAddView removeFromSuperview];
    
    
    rootViewController = (UIViewController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
    
    if (!self.backgroundView) {
        CGRect frame = [UIScreen mainScreen].bounds;
         float xCordinate;
        if(frame.size.width==320)
        {
            xCordinate=frame.size.height;
             self.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)] autorelease];
             self.popup= [[[UIImageView alloc]initWithFrame:CGRectMake(0,0, frame.size.height, frame.size.width)] autorelease];
        }
        else
        {
            xCordinate=frame.size.width;
 self.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
             self.popup= [[[UIImageView alloc]initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)] autorelease];
        }

       
        self.backgroundView.backgroundColor = [UIColor colorWithRed:(CGFloat)155/255 green:(CGFloat)155/255 blue:(CGFloat)155/255 alpha:1];
        
       
        self.popup.image=[UIImage imageNamed:@"Highscore_popup_4.png"];
        [self.backgroundView addSubview:self.popup];
       //level label
        [UIView animateWithDuration:0.8f animations:^(void)
        {

        CGRect rect;
        if(frame.size.height>480)
            rect=CGRectMake(xCordinate-200, 40, 180, 50);
        else
            rect=CGRectMake(xCordinate-180, 40, 180, 50);
        UILabel * level=[[[UILabel alloc]initWithFrame:rect] autorelease];
        level.text=[NSString stringWithFormat:@"Level-%d",_levelCount];
        [level setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:15]];
            level.alpha = .5;
            level.transform = CGAffineTransformMakeScale(2.5, 2.5);
            level.layer.shadowOpacity = .6f;
            level.layer.shadowOffset = CGSizeMake(0.0, 0.0);
            level.layer.shadowRadius = 1;
            level.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            level.layer.shouldRasterize = YES;
            level.transform = CGAffineTransformMakeScale(1.0, 1.0);
            level.alpha = 1;
        [self.popup addSubview:level];
         }];
        //Score
        CGRect rect;
        if(frame.size.height>480)
            rect=CGRectMake(xCordinate-220, 70, 180, 50);
        else
            rect=CGRectMake(xCordinate-200, 70, 180, 50);

        UILabel *score=[[[UILabel alloc]initWithFrame:rect] autorelease];
        score.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
        score.text=[NSString stringWithFormat:@"Score:%ld",(long)_levelScore];
        [self.popup addSubview:score];
        
         //your score
        
        if(frame.size.height>480)
            rect=CGRectMake(xCordinate-240, 100, 180, 50);
        else
            rect=CGRectMake(xCordinate-220, 100, 180, 50);
        self.youScore=[[[UILabel alloc] initWithFrame:rect] autorelease];
        self.youScore.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
        if(isNewHighScore)
        {
            self.youScore.text=[NSString stringWithFormat:@"New High Score!"];
            

        }
         [self.popup addSubview:self.youScore];
        
        [self.popup addSubview:self.beated];
         
        //-----play button
        
        if(frame.size.height>480)
            rect=CGRectMake(xCordinate-160, 220, 100, 50);
        else
            rect=CGRectMake(xCordinate-200, 170, 100, 50);
        self.playButton_new = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton_new.frame = rect;
        UIImage *btnImage = [UIImage imageNamed:@"btn_play.png"];
        [self.playButton_new setImage:btnImage forState:UIControlStateNormal];
        [self.playButton_new addTarget:self action:@selector(playButtonActionInGameOver) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.playButton_new];
//-----------share on fb-----
        if(frame.size.height>480)
            rect=CGRectMake(xCordinate-270, 220, 100, 50);
        else
            rect=CGRectMake(xCordinate-200, 230, 100, 50);
        self.shareonfb = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareonfb.frame = rect;
        UIImage *btnImagefb = [UIImage imageNamed:@"share_cld.png"];
        [self.shareonfb setImage:btnImagefb forState:UIControlStateNormal];
        [self.shareonfb addTarget:self action:@selector(facebookBtn_Click) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.shareonfb];
        //-----------cancel button
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];//alloc]initWithFrame:CGRectMake(frame.size.height-90, 5, 100, 50)];
        self.cancelButton.frame = CGRectMake(xCordinate-90, 5, 100, 50);
        UIImage *cancel_img = [UIImage imageNamed:@"close.png"];
        [self.cancelButton setImage:cancel_img forState:UIControlStateNormal];
        [self.backgroundView addSubview:self.cancelButton];
        
        [self.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [rootViewController.view addSubview:self.backgroundView];
        
        self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(50, 50, 170, 250)] autorelease];
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self.backgroundView addSubview:self.scrollView];
    }
    
    BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    if(fbCheck)
    {
        [self storyPost];
    }
    BOOL networkStatus =[GameState sharedState].networkStatus; //[[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
    if (fbCheck==YES && networkStatus == YES) {
        [self displayScore];
    }
   
}

-(void) displayScore{
   
    for (UIView *subView in [self.scrollView subviews]){
        subView.hidden = YES;
    }
    
    NSArray *scoreDataAry = [GameState sharedState].friendsScoreArray;
    
  
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGFloat y = 5;
        for (int i =0; i<scoreDataAry.count; i++) {
            // NSLog(@"count %d",ary[i]);
            
            PFObject *obj = [scoreDataAry objectAtIndex:i];
            NSLog(@"PFOBJEct -==- %@",obj);
            
            NSNumber *score_saved = obj[@"Score"];
            NSString *player1 = nil;
            NSURL *url = nil;
            NSString * name=nil;
            NSString *urlString = nil;
          
            player1 = obj[@"PlayerFacebookID"];
            
            
            url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",player1]];
            
            urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@",player1];
            name = [self forName:urlString];
            //-------------------------------------------------------------
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *aimgeView = (UIImageView*)[self.scrollView viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.scrollView viewWithTag:300+i];
                UILabel *positionLabel=(UILabel*)[self.scrollView viewWithTag:3000+i];
                if (aimgeView == nil) {
                    UIImageView *profileImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, y+(i*40), 35, 35)] autorelease];
                    profileImageView.tag = 100+i;
                    [self.scrollView addSubview:profileImageView];
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58.png"]];
                                    }
                else{
                    aimgeView.hidden = NO;
                    [aimgeView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58.png"]];
                }
                
                if (label==nil) {
                    
                        UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, y+(i*40), 100, 45)] autorelease];
                      infoLabel.tag = 300+i;
                        
                        [infoLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:10]];
                        infoLabel.numberOfLines = 0;
                        infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    
                        infoLabel.text = [NSString stringWithFormat:@"%@\n%@\n",name,score_saved];
                    [self.scrollView addSubview:infoLabel];
                    
                    }
                
                else{
                    
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@\n%@\n",name,score_saved];
                    }
                if(positionLabel==nil)
                {
                    UILabel * position=[[[UILabel alloc] initWithFrame:CGRectMake(120, y+(i*40), 30, 45)] autorelease];
                    position.tag = 3000+i;
                    position.textColor = [UIColor blueColor];
                    [position setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20]];
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%d",i+1];
                    [self.scrollView addSubview:position];
                    
                }
                else
                {
                    positionLabel=NO;
                     positionLabel.text = [NSString stringWithFormat:@"%d",i+1];
                    
                }
                    
            });
            
        }
        NSInteger ct = scoreDataAry.count;
        CGFloat h = ct*36+80;
        self.scrollView.contentSize = CGSizeMake(170, h);
    });
    
    
}
-(NSString*)forName:(NSString*)forurl
{
    // NSLog(@"url String=-=- %@",urlString);
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:forurl]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse* response;
    NSError* error = nil;
    
    //Capturing server response
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    // NSLog(@"Data =-= %@",str);
    if (str) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:NULL];
        NSString *firstname=[dict objectForKey:@"first_name"];
        //        NSString *lastname=[dict objectForKey:@"last_name"];
        NSString *finalName=[NSString stringWithFormat:@"%@",firstname];
        dict = nil;
        [str release];
        return finalName;
        
    }
    [str release];
    return nil;
}
-(void)playButtonActionInGameOver
{
    if (_levelCount >=50) {
     
        [self displayGameCompletionView];
        return;
    }
    [self.backgroundView removeFromSuperview];
    
    LevelSelectionScene *obj = [[[LevelSelectionScene alloc]init:YES] autorelease];
    
    [self addChild:obj];
    
}
-(void)cancelButtonAction
{
    [self.backgroundView removeFromSuperview];
    LevelSelectionScene *obj = [[[LevelSelectionScene alloc]init:YES] autorelease];
    
    [self addChild:obj];
}

#pragma mark -
#pragma mark Save To Parse
-(void)saveScoreToParse:(NSInteger)score forLevel:(NSInteger)level
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL networkStatus = [GameState sharedState].networkStatus;//[[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    
    if(networkStatus==NO)
    {
        [self retriveScoreSqlite:score withLevel:level];
    }
    else
    {
        self.currentLevel=level;
        self.levelScore = score;
        NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
        
        // NSString *strCheckFirstRun = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
        //  strCheckFirstRun=nil;
        //NSLog(@"%@",strCheckFirstRun);
        
        if (fbID&&![fbID isEqualToString:@"Master"])
        {
            
            BOOL isUpdateScore = NO;
            
            NSArray *ary = [GameState sharedState].friendsScoreArray;
            NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
            
            for (int i = 0; i<mutableArray.count; i++) {
                
                PFObject *obj = [mutableArray objectAtIndex:i];
                NSString *store_fbID = obj[@"PlayerFacebookID"];
                if ([fbID isEqualToString:store_fbID]) {
                    isUpdateScore = YES;
                    break;
                }
            }// End For Loop
            
            if (isUpdateScore==NO)
            {//if3
                [[NSUserDefaults standardUserDefaults] setObject:@"hello" forKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSLog(@"Current Level == %d",(int)level);
                //  NSLog(@"Level Score == %d",score);
                
                PFObject *object = [PFObject objectWithClassName:ParseScoreTableName];
                object[@"PlayerFacebookID"] = fbID;
                object[@"Level"] = [NSString stringWithFormat:@"%d",(int)level];
                object[@"Score"] = [NSNumber numberWithInteger:score];
                object[@"level"] = [NSNumber numberWithInteger:level];
                
                
                [mutableArray addObject:object];
                
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Score" ascending:NO];
                NSArray* sortedArray = [mutableArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                [GameState sharedState].friendsScoreArray = sortedArray;
                
                [self findBeatedFriend:object];
                
                NSLog(@"ConnectedFacebookUserName%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [object saveEventually:^(BOOL succeed, NSError *error){
                        
                        if (succeed)
                        {
                            NSLog(@"Save to Parse");
                            
                            //[self retriveFriendsScore:level andScore:score];
                        }
                        if (error) {
                            NSLog(@"Error to Save == %@",error.localizedDescription);
                        }
                        [mutableArray release];
                    }];
                });
            }//if3
            else{
                [mutableArray release];
                NSLog(@"Update row................yes ");
                [self updateScoreOn:score level:level];
            }
        }//End FB check
        else
        {
            [self retriveScoreSqlite:score withLevel:level];
            NSLog(@"Not connected with Facebook");
        }

    }//else of network
}
-(void)updateScoreOn:(NSInteger)score level:(NSInteger) level{
    
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    if(fbID)
    {
        [query whereKey:@"PlayerFacebookID" equalTo:fbID];
        [query whereKey:@"Level" equalTo:[NSString stringWithFormat:@"%d",(int)level]];
        [query orderByDescending:@"Score"];
        
        //        NSArray *aryCount=[query findObjects];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"ffff = %@",objects);
            for (int a =0; a<objects.count;a++) {
                
                PFObject *object = [objects objectAtIndex:a];
                
                if (a==0) {
                    NSLog(@"PFOBJEct -==- %@",object);
                    NSNumber *scoreOld = object[@"Score"];
                    
                    if (score > [scoreOld integerValue]) {
                        
                        NSLog(@"Current Level == %d",(int)level);
                        NSLog(@"Level Score == %d",(int)score);
                        
                        object[@"Score"] = [NSNumber numberWithInteger:score];
                        
                        NSLog(@"%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            
                            [object saveEventually:^(BOOL succeed, NSError *error){
                                
                                if (succeed) {
                                    NSLog(@"Save to Parse");
                                    // [self retriveFriendsScore:level andScore:score];
                                }
                                else{
                                    NSLog(@"Error to Save == %@",error.localizedDescription);
                                }
                            }];
                        });// End dispatch Queue Save Data
                        NSArray *ary = [GameState sharedState].friendsScoreArray;
                        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
                    
                        
                        for(int i=0;i<mutableArray.count;i++)
                        {
                            PFObject *obj=[mutableArray objectAtIndex:i];
                            
                            NSString *ufbid=obj[@"PlayerFacebookID"];
                         if([ufbid isEqualToString:fbID])
                         {
                            [mutableArray removeObject:obj];
                         }
                        }//End for Loop
                        
                        
                       [mutableArray addObject:object];
                        
                        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Score" ascending:NO];
                        NSArray* sortedArray = [mutableArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                        [GameState sharedState].friendsScoreArray = sortedArray;
                       
                        [mutableArray release];
                        
                        if (score > [scoreOld integerValue])
                        {
                            [self findBeatedFriend:object];
                           
                        }
                    }//End if block Score check
                    
                }//End if Block a-0
                else{
                    [object deleteInBackground];
                }
                
            }//End of For loop
            
        }];
    }//// End if block fbID check
    
}

-(void)saveScoreLocally:(NSInteger)ascore withScore:(NSInteger)alevel
{
    NSMutableDictionary * tempDict=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"LocalScoredDictionary"]];
    //----------------------
    NSString * keyLevel=[NSString stringWithFormat:@"Level%d",(int)alevel];
    NSString * keyScore=[NSString stringWithFormat:@"Score%d",(int)alevel];
    [tempDict setObject:[NSString stringWithFormat:@"%d",(int)alevel] forKey:keyLevel];
    [tempDict setObject:[NSString stringWithFormat:@"%d",(int)ascore] forKey:keyScore];
    //--------------------------
    [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:@"LocalScoredDictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)retriveScoreSqlite:(NSInteger)ascore withLevel:(NSInteger)alevel
{
    
    BOOL check_Update;
    check_Update=FALSE;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
     NSString * keyLevel=[NSString stringWithFormat:@"%d",(int)alevel];
    // Check to see if the database file already exists
     NSString * connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
        NSString *query = [NSString stringWithFormat:@"select * from GameScoreFinal where PlayerFbId = \"%@\"",connectedFBid];
    sqlite3_stmt *stmt=nil;
    if(sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK)
        NSLog(@"error to open");
    
    if (sqlite3_prepare_v2(_databaseHandle, [query UTF8String], -1, &stmt, NULL)== SQLITE_OK)
    {
        NSLog(@"prepared");
    }
    else
        NSLog(@"error");
    // sqlite3_step(stmt);
    @try
    {
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            
            char *level = (char *) sqlite3_column_text(stmt,1);
            char *score = (char *) sqlite3_column_text(stmt,2);
            NSString *strLevel= [NSString  stringWithUTF8String:level];
            
            NSString *strScore  = [NSString stringWithUTF8String:score];
            NSLog(@"Level %@ and Score %@ ",strLevel,strScore);
            if([strLevel isEqualToString:keyLevel])
            {
                check_Update=TRUE;
            }
                        
        }
    }
    @catch(NSException *e)
    {
        NSLog(@"%@",e);
    }
    if(check_Update)
    {
         [self updateScoreSqlite:ascore withScore:alevel];
    }
    else
    {
         [self saveScoreSqlite:ascore withScore:alevel];
    }
    
}

-(void)saveScoreSqlite:(NSInteger)ascore withScore:(NSInteger)alevel
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    sqlite3_stmt *inset_statement = NULL;
    NSString * keyLevel=[NSString stringWithFormat:@"%d",(int)alevel];
    NSString * keyScore=[NSString stringWithFormat:@"%d",(int)ascore];
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    if(!connectedFBid)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Master" forKey:
         ConnectedFacebookUserID];
    }
    connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSString *insertSQL = [NSString stringWithFormat:
                           @"INSERT INTO GameScoreFinal (Level, Score,PlayerFbId) VALUES (\"%@\", \"%@\",\"%@\")",
                           keyLevel,
                           keyScore,connectedFBid
                           ];
    
    const char *insert_stmt = [insertSQL UTF8String];
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK) {
        NSLog(@"Error to Open");
        return;
    }

    if (sqlite3_prepare_v2(_databaseHandle, insert_stmt , -1,&inset_statement, NULL) != SQLITE_OK ) {
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
        NSLog(@"Error to Prepare");
        
    }

    if(sqlite3_step(inset_statement) == SQLITE_DONE) {
       // UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
//                                                          message:@"Data Saved"
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
       // [message show];
        NSLog(@"Success");
    }
}
-(void)updateScoreSqlite:(NSInteger)ascore withScore:(NSInteger)alevel
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    sqlite3_stmt *inset_statement = NULL;
    NSString * keyLevel=[NSString stringWithFormat:@"%d",(int)alevel];
    NSString * keyScore=[NSString stringWithFormat:@"%d",(int)ascore];
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];

    NSLog(@"Exitsing data, Update Please");
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE GameScoreFinal set  Score = '%@', PlayerFbId = '%@' WHERE Level =%@",keyScore,connectedFBid,keyLevel];
    
    const char *update_stmt = [updateSQL UTF8String];
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK) {
        NSLog(@"Error to Open");
        return;
    }
    
    if (sqlite3_prepare_v2(_databaseHandle, update_stmt , -1,&inset_statement, NULL) != SQLITE_OK )
    {
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
        NSLog(@"Error to Prepare");
        
    }
    if(sqlite3_step(inset_statement) == SQLITE_DONE) {
      //  UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
//                                                          message:@"Data update"
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
      //  [message show];
        NSLog(@"Success");
    }
    //NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
    sqlite3_finalize(inset_statement);
    sqlite3_close(_databaseHandle);
}

-(void)findBeatedFriend:(PFObject *)object
{
    
    NSArray *ary = [GameState sharedState].friendsScoreArray;
    NSString *urlString=nil;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
    if ([mutableArray containsObject:object]) {
        
        NSInteger position = [mutableArray indexOfObject:object];
        //NSLog(@"Position = %d",position);
        if (position<=mutableArray.count-2 && mutableArray.count>1)
        {
            
            NSString *curFBID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
            
            PFObject *beatedObject = [mutableArray objectAtIndex:position+1];
            NSString *beated_fbID = beatedObject[@"PlayerFacebookID"];
            NSLog(@"Beated Friends ID = %@",beatedObject[@"PlayerFacebookID"]);
            NSLog(@"Beated Friends ID = %@",beatedObject[@"Score"]);
            
            if ([beated_fbID isEqualToString:curFBID]) {
                NSLog(@"Set new Score in this level");
                if_beated = NO;
                [mutableArray removeObject:beatedObject];
            }
            else{
                if_beated = YES;
                urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@",beatedObject[@"PlayerFacebookID"]];
                if(beatedObject[@"PlayerFacebookID"])
                {
                    beatedFriendObject=beatedObject[@"PlayerFacebookID"];
                    [beatedFriendObjects addObject:beatedObject[@"PlayerFacebookID"]];
                }
                NSString *name=[self forName:urlString];
                NSLog(@"name%@",name);
                CGRect frame = [UIScreen mainScreen].bounds;
                CGRect rect;
                if(frame.size.height>480)
                    rect=CGRectMake(frame.size.height-220, 80, 170, 150);
                else
                    rect=CGRectMake(frame.size.height-220, 120, 220, 80);
                self.beated=[[[UILabel alloc]initWithFrame:rect] autorelease];
                self.beated.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:15];
                self.beatedFrndName = name;
                self.lblFbFirstName=name;
                self.beated.backgroundColor=[UIColor clearColor];
                self.beated.text = [NSString stringWithFormat:@"You Beat %@",name];
                
                BOOL FBConnected = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
                if (FBConnected==YES)
                {

                 [self performSelector:@selector(shareBeatedWithFacebookFriend) withObject:nil afterDelay:2];
                }
                if([GameState sharedState].networkStatus)
                {
                    [self pushForAll:object];
                }
                
            }
            
            
        }
        
        if (position==0) {
            NSLog(@"new high score");
            isNewHighScore = YES;
        }
    }
    [mutableArray release];
}
-(void)pushForAll:(PFObject *)object
{
    NSArray *ary = [GameState sharedState].friendsScoreArray;
    NSString * userFbid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSLog(@"object%@ %@",ary,object);
    NSDictionary * data;
    PFQuery *pushQuery = [PFInstallation query];
    NSString * userName=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:UserFbName]];

    for(int i=0;i<[ary count];i++)
    {
        PFObject * objGameState=[ary objectAtIndex:i];
        if([ary count]>0)
        {
            if(![userFbid isEqualToString: objGameState[@"PlayerFacebookID"]])
            {
                if(object[@"Score"]<objGameState[@"Score"])
                   {
                       [beatedFriendObjects addObject:objGameState[@"PlayerFacebookID"]];
                       NSString * alertMessage=[NSString stringWithFormat:@"%@ Beat you in Bow Hunting Chief!",userName];
                       data = @{
                                @"Type": @"500",@"FriendName":userName,@"action": @"com.globussoft.bowhuntingchief",
                                @"alert":alertMessage,@"sound":  @"cheering.caf", @"badge":@"Increment"
                                
                                };
                       [pushQuery whereKey:@"PlayerFacebookId" equalTo:objGameState[@"PlayerFacebookID"]];
                       PFPush *push = [[PFPush alloc] init];
                       [push setQuery:pushQuery];
                       [push setData:data];
                       [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                           if (!error) {
                               if (succeeded) {
                                   NSLog(@"Successful Push send");
                               }
                           } else {
                               NSLog(@"Push sending error: %@", [error userInfo]);
                           }
                       }];

                   }
            }//userId
        }//ary count
 
    }
    NSLog(@"Object Beated Friend %@",beatedFriendObjects);
    }
-(void) retriveFriendsScore:(NSInteger)level andScore:(NSInteger)score{
   // NSArray *con = [NSArray arrayWithObjects:@"100001098786520",@"100001641271282",@"1220529617",@"1532712804", nil];
    //NSArray *con = [NSArray arrayWithObjects:@"100001641271282", nil];
    
   // NSMutableArray *mutArr = [[NSMutableArray alloc]init];
//    NSArray *arr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
     NSMutableArray *mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
//    for (int i=0; i<[arr count]; i++) {
//        
//        NSString *str = [NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
//        
//        NSNumber *numFbIdFrnd =  [NSNumber numberWithLongLong:[str longLongValue]];
//        [mutArr addObject:numFbIdFrnd];
//    }
    
    NSMutableArray *arrMutableCopy = [mutArr mutableCopy];
    
    NSString *strUserFbId = [[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSNumber *numFbIdUser =  [NSNumber numberWithLongLong:[strUserFbId longLongValue]];
    
    if (![arrMutableCopy containsObject:strUserFbId]) {
        [arrMutableCopy addObject:strUserFbId];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.currentLevel = level;
        
        NSString *strLevel = [NSString stringWithFormat:@"%i",(int)level];
        
        PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];

        [query whereKey:@"Level" equalTo:strLevel];
        
        [query whereKey:@"PlayerFacebookID" containedIn:arrMutableCopy];
        //[query whereKey:@"Score" lessThan:[NSNumber numberWithInteger:score]];
        //[query orderByAscending:@"Score"];
        
        [query orderByDescending:@"Score"];
        NSArray *ary = [query findObjects];
        
        if (ary.count<1) {
            isNewHighScore = YES;
            //NSLog(@"New High Score");
           // NSLog(@"Not contain any Object");
            return;
        }
        
        else{
        self.mutArrScores = [[[NSMutableArray alloc] init] autorelease];
        
        isNewHighScore = NO;
        for (int i =0; i<ary.count; i++) {
            
            PFObject *obj = [ary objectAtIndex:i];
            //NSLog(@"PFOBJEct -==- %@",obj);
            NSNumber *scoreOld = obj[@"Score"];
            NSNumber *fbId = obj[@"PlayerFacebookID"];
//            NSLog(@"Score Old -==- %@",scoreOld);
            
            int storeScore = [scoreOld intValue];
            
            if (score<storeScore) {
                [self.mutArrScores addObject:scoreOld];
            }
            else{
                
                if (self.mutArrScores.count==0) {
                    isNewHighScore = YES;
                     //NSLog(@"You create new high Score.");
                }
                else{
                    
                    if ([fbId longLongValue]== [numFbIdUser longLongValue]) {
                        
                    }
                    else{
                        NSString *urlString = [NSString   stringWithFormat:@"https://graph.facebook.com/%@",fbId];
                       // NSLog(@"url String=-=- %@",urlString);
                        
                        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
                        [request setURL:[NSURL URLWithString:urlString]];
                        [request setHTTPMethod:@"GET"];
                        [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
                        NSURLResponse* response;
                        NSError* error = nil;
                        
                        //Capturing server response
                        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
                        
                        NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                       // NSLog(@"Data =-= %@",str);
                        if (str) {
                            
                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:NULL];
                            self.lblFbFirstName = [dict objectForKey:@"first_name"];
                            
                            self.lblFbLastName = [dict objectForKey:@"last_name"];
                            
                           // NSLog(@"First Name =-=- %@",self.lblFbFirstName);
                           // NSLog(@"last name =-=- %@",self.lblFbLastName);
                            [activityInd stopAnimating];
                            [str release];
                        }
                        return;
                    }
                }
            }
        }
        secondHighScore = [ary objectAtIndex:0];
        }
    });
}


#pragma mark -

-(void) setNewSprite{
    
    int position = (int)[self.mutArrScores count];
    
//    self.spriteBackground = [CCSprite spriteWithFile:@"gameOverSky.png"];
    
    self.spriteBackground = [CCSprite spriteWithFile:@"scorebg.png"];
    self.spriteBackground.position=ccp(ws.width/2,ws.height/2);
    [self addChild:self.spriteBackground];
    
    self.shareOnFb=[CCMenuItemImage itemWithNormalImage:@"share_cld.png" selectedImage:@"share_cld.png" target:self selector:@selector(facebookBtnClick)];
    
    self.shareButtons=[CCMenu menuWithItems:self.shareOnFb, nil];
    self.shareButtons.position=ccp(ws.width/2-130, 60);
    [self.shareButtons alignItemsHorizontally];
    [self addChild:self.shareButtons];
    [self.shareButtons setVisible:YES];
    
    self.playNextLevel =[CCMenuItemImage itemWithNormalImage:@"next_cld.png" selectedImage:@"next_cld.png" target:self selector:@selector(playButtonClicked)];
    
    self.menuNextLevel = [CCMenu menuWithItems:self.playNextLevel, nil];
    self.menuNextLevel.position=ccp(ws.width/2+100, 60);
    [self addChild:self.menuNextLevel];
    
    if(isNewHighScore == YES){
        //NSLog(@"You set a new high score");
        
        self.lblHeader=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"New highest score"] fontName:@"MetalMacabre" fontSize:20];
        self.lblHeader.color=ccRED;
        self.lblHeader.position=ccp(ws.width/2, ws.height-150);
       
        self.lblPOsition=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"in Level %i",self.levelCount] fontName:@"MetalMacabre" fontSize:20];
        self.lblPOsition.position=ccp(ws.width/2, ws.height-200);
    }
    else{
//        NSLog(@"You beat your friend, facebook id is== %@",fbID);
        position++;
        
//        self.lblHeader=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"You got %i position",position] fntFile:@"a_Assuan.fnt"];
//        self.lblHeader.position=ccp(ws.width/2, ws.height-40);
//       
//        self.lblPOsition=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"in Level %i",self.levelCount] fntFile:@"a_Assuan.fnt"];
//        self.lblPOsition.position=ccp(ws.width/2, ws.height-90);
        
        self.lblHeader=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"You got %i position",position] fontName:@"MetalMacabre" fontSize:20];
        self.lblHeader.color=ccRED;
        self.lblHeader.position=ccp(ws.width/2, ws.height-100);
        
//        self.lblPOsition=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"in Level %i",self.levelCount] fntFile:@"a_Assuan.fnt"];
//        self.lblPOsition.position=ccp(ws.width/2, ws.height-90);
        
        self.lblPOsition=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"in Level %i",self.levelCount] fontName:@"MetalMacabre" fontSize:20];
        self.lblPOsition.position=ccp(ws.width/2, ws.height-150);
        self.lblPOsition.color=ccRED;
        
        
    }
    
    if (self.lblFbFirstName) {
        self.lblFbBeatFrnd=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"You beat %@ %@",self.lblFbFirstName,self.lblFbLastName] fntFile:@"a_Assuan.fnt"];
        self.lblFbBeatFrnd.position=ccp(ws.width/2, ws.height-140);
        [self addChild:self.lblFbBeatFrnd];
    }
    
    [self addChild:self.lblHeader];
    [self addChild:self.lblPOsition];
}

-(void)playButtonClicked {
    
    
    if (self.checkLevelClear) {
        
        [self removeChild:self.spriteBackground cleanup:YES];
        [self removeChild:self.lblPOsition cleanup:YES];
        [self removeChild:self.menuNextLevel cleanup:YES];
        [self removeChild:self.lblHeader cleanup:YES];
        [self removeChild:self.lblFbBeatFrnd cleanup:YES];
    }
    if ([GameState sharedState].checkLife) {
        self.visible=NO;
        int life = (int)[userDefault integerForKey:@"life"];
        NSLog(@"%d",life);
        
        [self.gm.timeText setString:[NSString stringWithFormat:@"%i" ,self.gm.limitTime]];
        
        [self.gm showLevelInfoThenGoNextLevel:@"Ready" theLevel:[GameState sharedState].levelNumber theLife:life];
    }
    else{
        //NSLog(@"No life Get extra Lifes");
        [self showLifeOver];
    }
    [self.shareButtons setVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Error-==-%@",error);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Data =-= %@",str);
    [str release];
}

- (void) dealloc
{
	[super dealloc];
}

@end
