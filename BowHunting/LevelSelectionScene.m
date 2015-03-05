//
//  LevelSelectionScene.m
//  BowHunting
//
//  Created by Sumit Ghosh on 03/05/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "LevelSelectionScene.h"
#import "AppDelegate.h"
#import "GameMain.h"
#import "GameIntro.h"
#import "UIImageView+WebCache.h"
#import "LifeOver.h"
#import "FriendsInLevel.h"
@implementation LevelSelectionScene

-(id)init:(BOOL)musicOn {
    
    if (self=[super init]) {
        
 
           //[self compareDate];
        //[self createUitoShowFriendsOnLevel];
        //[self fetchUserInLevelFromParse];
        self.checkMusic=musicOn;
        [self fullscreenAddAdded];
//         [[[CCDirector sharedDirector] view] addSubview:[GameState sharedState].bannerAddView];
        
        CGSize ws=[[CCDirector sharedDirector]winSize];
        
        CCSprite *background;
		
		background = [CCSprite spriteWithFile:@"level_Sel_bg5.png"];
			//background.rotation = 90;
		
		background.position = ccp(ws.width/2, ws.height/2);
        
		// add the label as a child to this Layer
		[self addChild: background];
        
        
        spriteBackground=[CCSprite spriteWithFile:@"game-bg.png"];
        spriteBackground.position=ccp(ws.width/2,ws.height/2);
        [self addChild:spriteBackground];
      
        rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
        
        CCMenuItemImage *menuItemImageBack = [CCMenuItemImage itemWithNormalImage:@"backLevel.png" selectedImage:@"backLevel.png" target:self selector:@selector(backBtnAction:)];
        
        menuBack=[CCMenu menuWithItems:menuItemImageBack, nil];
        
         if([UIScreen mainScreen].bounds.size.height>500)
         {
              scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(45, 60, 800, 200)];
              menuBack.position=ccp(105, ws.height-40);
         }
         else{
              scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, 800, 200)];
              menuBack.position=ccp(70, ws.height-40);
         }
       
        scrollV.contentSize=CGSizeMake(800, 520);
        scrollV.scrollEnabled=YES;
        scrollV.showsHorizontalScrollIndicator=YES;
        [rootViewController.view addSubview:scrollV];
       
        [self addChild:menuBack];
        
        for (int i=0; i<5; i++) {
            
            for (int j=0; j<10; j++) {
                btnLevels = [UIButton buttonWithType:UIButtonTypeSystem];
                
                btnLevels.frame=CGRectMake(62+78*i, 50*j, 48, 48);
                unsigned buttonNumber = j*5+i+1;
                btnLevels.tag=buttonNumber;
               
                btnLevels.titleLabel.font=[UIFont
                                     fontWithName:@"NKOTB Fever" size:20];
                [btnLevels setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                [btnLevels addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

                [scrollV addSubview:btnLevels];
                
                 int levelNumbers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
                
                if (levelNumbers==0) {
                    
                    if (buttonNumber==1) {
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"level.png"] forState:UIControlStateNormal];
                        NSString *str =[NSString stringWithFormat:@"%ld",(long)btnLevels.tag];
                        [btnLevels setTitle:str forState:UIControlStateNormal];
                    }
                    else{
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
                    }
                }
                
                else {
               
                    if (buttonNumber==levelNumbers) {
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"glowing.png"] forState:UIControlStateNormal];
                        NSString *str =[NSString stringWithFormat:@"%ld",(long)btnLevels.tag];
                        [btnLevels setTitle:str forState:UIControlStateNormal];
                    }
                  else if (buttonNumber>levelNumbers) {
                    [btnLevels setBackgroundImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
                }
                else {
                     [btnLevels setBackgroundImage:[UIImage imageNamed:@"level.png"] forState:UIControlStateNormal];
                    NSString *str =[NSString stringWithFormat:@"%ld",(long)btnLevels.tag];
                    [btnLevels setTitle:str forState:UIControlStateNormal];
                }
                 }
            }
        }
    }
    
    friendsId=[[NSMutableArray alloc]init];
    levelNo=[[NSMutableArray alloc]init];
    return self;
}
#pragma mark-
-(void)onEnterTransitionDidFinish{
    NSLog(@"On Enter Transition");
    
    [self schedule:@selector(levelselectionAnimation) interval:.3] ;
    
}
-(void) levelselectionAnimation{
    [self unschedule:@selector(levelselectionAnimation)];
    int levelNumbers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
    CGFloat h = 0;
    if (levelNumbers>=15 && levelNumbers <= 24) {
        //[scrollV setContentOffset:CGPointMake(0, 150)];
        h = 100;
    }
    else if (levelNumbers >= 25 && levelNumbers < 34){
        // [scrollV setContentOffset:CGPointMake(0, 200)];
        h = 200;
    }
    else if (levelNumbers >= 35 && levelNumbers < 44){
        // [scrollV setContentOffset:CGPointMake(0, 200)];
        h = 300;
    }
    else if (levelNumbers >= 45){
        // [scrollV setContentOffset:CGPointMake(0, 250)];
        h = 350;
    }
    else{
        //[scrollV setContentOffset:CGPointZero];
        h = 0;
    }
    float time = levelNumbers/20;
    if (time<1) {
        time = 1;
    }
    [UIView animateWithDuration:time animations:^{
        [scrollV setContentOffset:CGPointMake(0, h)];
    }];
    
    
    
}

//-(void)adMob
//{
//
//    [viewController presentViewController:adf animated:NO completion:nil];
//    
//  
//}
-(void)backBtnAction:(id)sender {
    scrollV.hidden=YES;
  [[GameState sharedState].bannerAddView removeFromSuperview];
    [self removeChild:spriteBackground cleanup:YES];
    [self removeChild:menuBack cleanup:YES];
    [[CCDirector sharedDirector] replaceScene:[GameIntro node]];
//    menuBack.visible=NO;
}
-(void)btnAction:(id)sender
{
    
   // [[GameState sharedState].bannerAddView removeFromSuperview];
    NSInteger levelNumbers = [[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
    
    if (levelNumbers < [sender tag] && levelNumbers != 0) {
        return;
    }
    
    if ([sender isKindOfClass:[UIButton class]]) {
        //NSLog(@"Sender Button Tag =-=-=- %ld",(long)[sender tag]);
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setInteger:[sender tag] forKey:@"level"];
        NSString *life = [userDefault objectForKey:@"life"];
        NSLog(@"Life==%@",[userDefault objectForKey:@"life"]);
        
       if (life.intValue>0) {
        
           [self createUI:[sender tag]];
            
            NSString *connectedFBID = [userDefault objectForKey:ConnectedFacebookUserID];
           BOOL fbConnnected=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
            if (connectedFBID&&fbConnnected)
            {
                [self retriveFriendsScore:[sender tag]];
               // [self retrieveFriendsLevel];
                NSLog(@"Fetched score from parse and display play option");
                
            }// if fb check
            else
            {
                NSLog(@"display Play option with selected level");
            }// else fb check
            
        }// if life check
        else{
            [self compareDate];
            scrollV.hidden=YES;
            [self removeChild:spriteBackground cleanup:YES];
            [self removeChild:menuBack cleanup:YES];
            self.lifeOverLayer=[[[LifeOver alloc]init] autorelease];
            [self addChild:self.lifeOverLayer];
            NSLog(@"Display game over Scene");
        }

    }
    else{
        NSLog(@"Not Connected");
    }
}

#pragma mark-
-(void) createUI:(NSInteger)levelno
{
    
    scrollV.hidden=YES;
    rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    if (self.backgroundView==nil) {
        NSLog(@"%f",frame.size.width);
        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)] autorelease];
        if(frame.size.width==320)
        {
            self.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)] autorelease];

        }
        else
        {
            self.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];

        }

        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        if(orientation == 0)
        {
            
        }
        else if(orientation == UIInterfaceOrientationPortrait)
        {
                
        }
        else if(orientation == UIInterfaceOrientationLandscapeLeft)
        {
            
        }// Do something if Left
        else if(orientation == UIInterfaceOrientationLandscapeRight)
        {
            
        }//Do something if right
        [self.backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbg.png"]]];
        
        [rootViewController.view addSubview:self.backgroundView];
       
//-----------------------------------------
        if(frame.size.width==320)
        {
           self.upperView = [[[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.height, frame.size.width)] autorelease];
        }
        else
        {
          self.upperView = [[[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)] autorelease];
        }
       
        
        self.upperView.image=[UIImage imageNamed:@"Highscore_popup_4.png"];
      [self.backgroundView addSubview:self.upperView];
//---cancel button
        float xCordinate;
        if(frame.size.width==320)
        {
            xCordinate=frame.size.height;
        }
        else
        {
           xCordinate=frame.size.width;
        }

        self.cancelButton = [[[UIButton alloc]initWithFrame:CGRectMake(xCordinate-90, 5, 100, 50)] autorelease];
        UIImage *cancel_img = [UIImage imageNamed:@"close.png"];
       [self.cancelButton setImage:cancel_img forState:UIControlStateNormal];
        [self.backgroundView addSubview:self.cancelButton];
       
        [self.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        CGRect rect;
        if(frame.size.height>480)
        rect=CGRectMake(xCordinate-220, 200, 100, 50);
        else
           rect=CGRectMake(xCordinate-200, 200, 100, 50);
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = rect;
        UIImage *btnImage = [UIImage imageNamed:@"btn_play.png"];
       
        [self.playButton setImage:btnImage forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.playButton];
        
        //-------
//--------lower view
        
//-------level and target
        //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [UIView animateWithDuration:0.6f animations:^(void) {
            CGRect rect;
        if(frame.size.height>480)
            rect=CGRectMake(xCordinate-210, 20, 150, 90);
        else
            rect=CGRectMake(xCordinate-180, 30, 150, 50);
        level=[[UILabel alloc] initWithFrame:rect];
        level.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
        level.textColor=[UIColor blackColor];
        level.text=[NSString stringWithFormat:@"Level-%d",(int)levelno];
        
            level.alpha = .5;
            level.transform = CGAffineTransformMakeScale(2.5, 2.5);
            level.layer.shadowOpacity = .6f;
            level.layer.shadowOffset = CGSizeMake(0.0, 0.0);
            level.layer.shadowRadius = 1;
            level.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            level.layer.shouldRasterize = YES;
            level.transform = CGAffineTransformMakeScale(1.0, 1.0);
            level.alpha = 1;
            [self.backgroundView addSubview:level];
         }];
        if(frame.size.height>480)
            rect=CGRectMake(xCordinate-250, 60, 210, 90);
        else
            rect=CGRectMake(xCordinate-240, 60, 210, 50);
         
        target=[[UILabel alloc]initWithFrame:rect];
        target.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
        
     target.text=[NSString stringWithFormat:@"Targeted Birds-30"];
        [self.backgroundView addSubview:target];
        
    }
    else
    {
        self.backgroundView.hidden=NO;
        
       [rootViewController.view addSubview:self.backgroundView];
        level.text=[NSString stringWithFormat:@"Level-%d",(int)levelno];
        target.text=[NSString stringWithFormat:@"Targeted Birds-30"];
      
        
    }
}

-(void) retriveFriendsScore:(NSInteger)levelSelected
{
    
    BOOL networkStatus =[GameState sharedState].networkStatus; //[[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    
    if (networkStatus==NO) {
        return;
    }
    
    //NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    NSMutableArray *mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    NSLog(@"Friends=-=-=-%@",mutArr);
   // self.arrMutableCopy = [mutArr mutableCopy];
    if (mutArr.count<1) {
        return;
    }
   // NSLog(@"level%d",levelSelected);
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    NSArray *allAry = [mutArr arrayByAddingObject:[NSString stringWithFormat:@"%@",fbID]];
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"Level" equalTo:[NSString stringWithFormat:@"%d",(int)levelSelected]];
    [query whereKey:@"PlayerFacebookID" containedIn:allAry];
    
    [query orderByDescending:@"Score"];
    
    for (UIView *subView in [self.upperView subviews]){
        subView.hidden = YES;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *ary = [query findObjects];
        [GameState sharedState].friendsScoreArray = [NSArray arrayWithArray:ary];
        
        NSLog(@"Ary == %@",ary);
       
        CGFloat y = 60;
        for (int i =0; i<ary.count; i++) {
            // NSLog(@"count %d",ary[i]);
            
            if (i == 3) {
                break;
            }
            PFObject *obj = [ary objectAtIndex:i];
            NSLog(@"PFOBJEct -==- %@",obj);
            
            NSNumber *score_saved = obj[@"Score"];
            
            NSString *player1 = obj[@"PlayerFacebookID"];
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",player1]];
            
            NSString *urlString = [NSString   stringWithFormat:@"https://graph.facebook.com/%@",player1];
            //for name
            NSString *name = [self forName:urlString];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *aimgeView = (UIImageView*)[self.upperView viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.upperView viewWithTag:300+i];
                UILabel *positionLabel=(UILabel*)[self.upperView viewWithTag:3000+i];
                if (aimgeView == nil) {
                    UIImageView *profileImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(42, y+(i*40), 35, 35)] autorelease];
                    profileImageView.tag = 100+i;
                    [self.upperView addSubview:profileImageView];
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58.png"]];
                }
                else{
                    aimgeView.hidden = NO;
                    [aimgeView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58.png"]];
                }
                
                if (label==nil) {
                    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(82, y+(i*40), 125, 35)] autorelease];
                    infoLabel.tag = 300+i;
                    infoLabel.backgroundColor = [UIColor clearColor];
                    infoLabel.font = [UIFont systemFontOfSize:10];
                    infoLabel.numberOfLines = 0;
//                    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    infoLabel.text = [NSString stringWithFormat:@"%@\n%@",name,score_saved];
                    [self.upperView addSubview:infoLabel];
                    
                                     // [infoLabel sizeToFit];
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@\n%@",name,score_saved];
                   // [label sizeToFit];
                }
                if(positionLabel==nil)
                {
                    UILabel * position=[[[UILabel alloc] initWithFrame:CGRectMake(170, y+(i*40), 30, 45)] autorelease];
                    position.tag = 3000+i;
                    position.textColor = [UIColor blueColor];
                    [position setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20]];
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%d",i+1];
                    [self.upperView addSubview:position];
                    
                }
                else
                {
                    positionLabel.hidden=NO;
                    positionLabel.text = [NSString stringWithFormat:@"%d",i+1];
                    
                    
                }

            });
            
        }
        
    });
 
    //        NSString *strLevel = [NSString stringWithFormat:@"%d",level];
}

-(void)retrieveFriendsLevel
{
    NSArray *friendArr=[[NSUserDefaults standardUserDefaults]objectForKey:FacebookGameFrindes];
    PFQuery *query=[PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"PlayerFacebookID" containedIn:friendArr];
    [query orderByDescending:@"level"];
    dispatch_async(dispatch_get_global_queue(0,0),^{
        NSArray *arr=[query findObjects];
        for (int i=0; i<[arr count]; i++) {
            PFObject *obj=[arr objectAtIndex:i];
            if (![friendsId containsObject:obj[@"PlayerFacebookID"]])
            {
                [levelNo addObject:obj[@"level"]];
                NSLog(@"Level is==%@",obj[@"level"]);
                [friendsId addObject:obj[@"PlayerFacebookID"]];
            }
            
        }
        for (int i=0; i<[friendsId count]; i++) {
            NSLog(@"My Friend Id==%@",[friendsId objectAtIndex:i]);
            NSLog(@"Highest Level==%@",[levelNo objectAtIndex:i]);
        }
        
        
    });
}


-(NSString*)forName:(NSString*)forurl
{
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
        //NSString *lastname=[dict objectForKey:@"last_name"];
        NSString *finalName=[NSString stringWithFormat:@"%@ ",firstname];
        [str release];
        return finalName;
        
        
        
        
    }
    return nil;
}
/*-(void) printHighScore{
 
 
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
        mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
        NSString *strUserFbId = [[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSNumber *numFbIdUser =  [NSNumber numberWithLongLong:[strUserFbId longLongValue]];
        for(int i=0;i<[mutArr count];i++)
    {
        NSLog(@"%@",[mutArr objectAtIndex:i]);
    }
    int level=[[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
    NSString *strLevel = [NSString stringWithFormat:@"%i",level];
    NSLog(@"%d",level);
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"Level" equalTo:strLevel];
    
   // [query whereKey:@"PlayerFacebookID" containedIn:mutArr];
     [query orderByDescending:@"Score"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects)
            {
                NSLog(@"%@", object.objectId);
                NSArray *ary = [query findObjects];
                        for (int i =0; i<ary.count; i++)
                        {
                            
                            
                            PFObject *obj = [ary objectAtIndex:i];
                
                            NSLog(@"PFOBJEct -==- %@",obj);
                            NSLog(@"Name -==- %@",obj[@"Name"]);
                            NSLog(@"Score%@",obj[@"Score"]);
                    img=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10+(i*100), 30, 30)];
                            NSString *imageUrl =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small",[mutArr objectAtIndex:i]];
                   [img setImageWithURL:[NSURL URLWithString:imageUrl]];
                            [self.lowerView addSubview:img];
//---------------code to display score-------------------------------------
       if(i<3)
       {
 score=[[UILabel alloc] initWithFrame:CGRectMake(20,50+(i*100), 40, 40)];
                score.text=[NSString stringWithFormat:@"%@",obj[@"Score"]];
           [self.lowerView addSubview:score];
       }
                        
//---------------code to display rank---------------------------------------
    rankNo=[[UILabel alloc] initWithFrame:CGRectMake(5, 30+(100*i), 100, 40)];
    rankNo.text=[NSString stringWithFormat:@"%d",(i+1)];
    [self.lowerView addSubview:rankNo];
//-------------------code for name-----------------------------------------------
                            NSString *urlString = [NSString   stringWithFormat:@"https://graph.facebook.com/%@",[mutArr objectAtIndex:i]];
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
                                
                                firstname1=[[UILabel alloc] initWithFrame:CGRectMake(20, 30+(100*i), 100, 40)];
                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:NULL];
                                 firstname1.text= [dict objectForKey:@"first_name"];
                                
                                [self.lowerView addSubview:firstname1];
                               
                                
                            }

                
                        }//for
                
                
            }//for
        }//if
        
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    
    }];
    

}*/
-(void)playButtonAction
{
    [self.backgroundView removeFromSuperview];
    scrollV.hidden=YES;
    [self removeChild:spriteBackground cleanup:YES];
    [self removeChild:menuBack cleanup:YES];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene:self.checkMusic]]];
}
-(void)cancelButtonAction
{
    scrollV.hidden=NO;
    [self.backgroundView removeFromSuperview];
}
#pragma mark -
-(void)compareDate {
    
    NSString *strDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDate"];
    
    if (![strDate isEqualToString:@"0"]) {
        
        NSDate *currentDate = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSString *strCurrentDate = [formatter stringFromDate:currentDate];
        
        currentDate=[formatter dateFromString:strCurrentDate];
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSDate *oldDate = [formatter1 dateFromString:strDate];
        
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
        NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDate  toDate:currentDate  options:0];
        
        //int months = (int)[conversionInfo month];
        int days = (int)[conversionInfo day];
        int hours = (int)[conversionInfo hour];
        int minutes = (int)[conversionInfo minute];
        int seconds = (int)[conversionInfo second];
        
        //NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
        
        [self getExtraLife:days andHour:hours andMin:minutes andSec:seconds];
        [formatter release];
        [formatter1 release];
        [gregorianCal release];
    }
    
}
-(void)getExtraLife :(int)day andHour:(int)hour andMin:(int)min andSec:(int)sec {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int hoursInMin = hour*60;
    hoursInMin=hoursInMin+min;
    
    int extralife =hoursInMin/5;
    
    int gotLife = (int)[userDefault integerForKey:@"GainLife"];
    
    int totalTime = hoursInMin*60+sec;
    if (gotLife!=0) {
        hoursInMin = hoursInMin - gotLife*30;
        totalTime = totalTime - gotLife*30*60;
    }
    int rem =hoursInMin%5;
    
    int remTimeforLife = rem*60+sec;
    
    remTimeforLife=300-remTimeforLife;
    
    [userDefault setInteger:remTimeforLife forKey:@"timeRem"];
    
    if (day>0 || hoursInMin>=25) {
        [userDefault setInteger:5 forKey:@"life"];
        [userDefault setObject:@"0" forKey:@"currentDate"];
        [userDefault setInteger:0 forKey:@"GainLife"];
    }
    else if(totalTime>=300){
        
       
        if(extralife>=5){
            [userDefault setInteger:5 forKey:@"life"];
            [userDefault setObject:@"0" forKey:@"currentDate"];
            [userDefault setInteger:0 forKey:@"GainLife"];
        }
        else{
            if (gotLife==0) {
                [userDefault setInteger:extralife forKey:@"GainLife"];
                
            }
            else{
                [userDefault setInteger:extralife forKey:@"GainLife"];
                extralife = extralife - gotLife;
            }
            [userDefault setInteger:extralife forKey:@"life"];
        }
        
    }
    else{
        if (gotLife==0) {
            [userDefault setInteger:extralife forKey:@"GainLife"];
            
        }
        else{
            [userDefault setInteger:extralife forKey:@"GainLife"];
            extralife = extralife - gotLife;
        }
        [userDefault setInteger:extralife forKey:@"life"];
    }
   
    [userDefault synchronize];
}
#pragma mark----
-(void)fullscreenAddAdded
{
    BOOL checkInternet=[GameState sharedState].networkStatus;//[[NSUserDefaults standardUserDefaults]objectForKey:CurrentNetworkStatus];
    if (checkInternet) {
        
        adf = [[AdMobFullScreenViewController alloc]init];
        sleep(2);
        //[self adMob];
        
    }
 
}
#pragma mark Parse Methods
-(void)fetchUserInLevelFromParse
{
    PFQuery * query=[PFQuery queryWithClassName:@"GameScore"];
     NSArray *friendArr=[[NSUserDefaults standardUserDefaults]objectForKey:FacebookGameFrindes];
    [query whereKey:@"PlayerFacebookID" containedIn:friendArr];
    [query orderByDescending:@"level"];
    dispatch_async(dispatch_get_global_queue(0,0),^{

    NSArray * temp=[query findObjects];
        NSLog(@"Facebook Friends on that level %@",temp);
    });
    
}
-(void)createUitoShowFriendsOnLevel
{
    scrollV.hidden=YES;
    rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    if (self.backgroundView==nil) {
        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)] autorelease];
        
        [self.backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]]];
        
        [rootViewController.view addSubview:self.backgroundView];
    }

}

@end
