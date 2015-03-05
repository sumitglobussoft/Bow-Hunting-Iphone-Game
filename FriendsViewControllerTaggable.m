//
//  FriendsViewController.m
//  CaveRun
//
//  Created by GBS-ios on 8/18/14.
//
//

#import "FriendsViewControllerTaggable.h"
#import "UIImageView+WebCache.h"
#import "ImageViewCustomCell.h"
#import "GameState.h"
#import "GameIntro.h"
#import "MBProgressHUD.h"
@interface FriendsViewControllerTaggable ()

@end

@implementation FriendsViewControllerTaggable

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithHeaderTitle:(NSString *)headerTitle{
    
    self = [super init];
    if (self) {
        self.headerTitle = headerTitle;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)140/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:1.0];
    self.frame = [UIScreen mainScreen].bounds;
    [self createUI];
        NSArray *frndsListArray = [[NSUserDefaults standardUserDefaults] objectForKey:FacebookAllFriends];
    self.friendListArray = [NSArray arrayWithArray:frndsListArray];
    self.selectedFriendsArray = [[NSMutableArray alloc] init];
    self.selectedTagFriendsArray = [[NSMutableArray alloc] init];
    [self.selectedTagFriendsArray addObjectsFromArray:self.friendListArray];
     NSMutableArray *tagArray=[[NSMutableArray alloc] init];
    
//    if (self.friendListArray.count<50)
//    {
//        for (int i=0 ; i<self.friendListArray.count; i++)
//        {
//            
//            [self.selectedFriendsArray addObject:[NSNumber numberWithInteger:i]];
//            
//       }
//    }
//    else
//    {
//        for (int i=0; i<self.friendListArray.count; i++)
//        {
//         NSInteger randomNumber = arc4random() % self.friendListArray.count;
//            
//                 if (![tagArray containsObject:[NSNumber numberWithInteger:randomNumber]]) {
//                  [self.selectedTagFriendsArray exchangeObjectAtIndex:randomNumber withObjectAtIndex:i];
//                  [tagArray addObject:[NSNumber numberWithInteger:i]];
//                }
//            if (tagArray.count==50) {
//                break;
//            }
//        }
//          [self.selectedFriendsArray addObjectsFromArray:tagArray];
//        
//    }
       [self createTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) createUI
{
    NSLog(@"self.frame.size.height  = %f",self.frame.size.height);
    
    NSString *str = [[UIDevice currentDevice]model];
    NSLog(@"str is %@",str);
    self.headerView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 20,self.view.frame.size.width-20,self.view.frame.size.height-40)] autorelease];
    self.headerView.image=[UIImage imageNamed:@"ask_extra_livesTaggable.png"];
    self.headerView.userInteractionEnabled=YES;
   [self.view addSubview:self.headerView];
      //Add Cancel Button
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(185,20,self.frame.size.width-40, 20)] ;
    title.layer.cornerRadius=2;
    title.clipsToBounds=YES;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont boldSystemFontOfSize:12];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"Select Friends to tag!";
    [self.headerView addSubview:title];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
     cancelButton.frame = CGRectMake(12, 20, 60, 25);
    [cancelButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:cancelButton];
    
    //Add Send Button
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
 
    sendButton.frame = CGRectMake(self.headerView.frame.size.width-100, 20, 87, 40);    if([UIScreen mainScreen].bounds.size.height>500){
       //iphone 6
        //530
    }else{
         //sendButton.frame = CGRectMake(380, 20, 77, 30);
        //450,80
    }
    [sendButton setImage:[UIImage imageNamed:@"sendTaggable.png"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:sendButton];
    
    //===========
    
    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,self.headerView.frame.size.height-40,self.frame.size.width-40, 20)] ;
    self.noteLabel.layer.cornerRadius=2;
    self.noteLabel.clipsToBounds=YES;
    self.noteLabel.textColor = [UIColor blackColor];
    self.noteLabel.font = [UIFont boldSystemFontOfSize:12];
    self.noteLabel.backgroundColor = [UIColor clearColor];
    self.noteLabel.text = @"Note:You will get one life for every 5 Friends. So tag as many as you want!";
    [self.headerView addSubview:self.noteLabel];

}

-(void) createTableView
{
    
    if([UIScreen mainScreen].bounds.size.height>500)
    {
         titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,200,self.frame.size.height-150, 20)] ;//iphone 6
        //530
    }
    else
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75,200,self.frame.size.height-150, 20)] ;
    }
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%lu Friends selected",(unsigned long)self.selectedFriendsArray.count];
    [self.headerView addSubview:titleLabel];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setItemSize:CGSizeMake(190,40)];
    NSLog(@"self.frame.size.height is %f",self.frame.size.height);
    self.listTableView = [[UICollectionView alloc] initWithFrame:CGRectMake(25,75,self.headerView.frame.size.width-50,110) collectionViewLayout:layout];

    if([UIScreen mainScreen].bounds.size.height>500)
    {
       // self.listTableView = [[UICollectionView alloc] initWithFrame:CGRectMake(25,75,self.headerView.frame.size.width-50,110) collectionViewLayout:layout];
   
    }
    else
    {
        // self.listTableView = [[UICollectionView alloc] initWithFrame:CGRectMake(25,80,self.frame.size.width+100,110) collectionViewLayout:layout];
    }
    
    if (self.frame.size.width>self.frame.size.height)
    {
        // self.listTableView = [[UICollectionView alloc] initWithFrame:CGRectMake(25,80,self.frame.size.height+100,110) collectionViewLayout:layout];
    }
    [self.listTableView registerClass:[ImageViewCustomCell class] forCellWithReuseIdentifier:@"cell"];
   [self.listTableView setBackgroundColor:[UIColor clearColor]];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.headerView addSubview:self.listTableView];
}

#pragma mark-

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"self = %lu",(unsigned long)self.friendListArray.count);
    return self.friendListArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * identifier=@"cell";
    
    NSDictionary *dict = [self.selectedTagFriendsArray objectAtIndex:indexPath.row];
    NSString *imageUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pic_small"]];
    
    ImageViewCustomCell * cell=(ImageViewCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"58.png"]];
    for (UIButton * btn in cell.backGroundImageView.subviews)
    {
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn removeFromSuperview];
        }
    }

    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkButton.selected=YES;
   [cell.backGroundImageView addSubview:self.checkButton];

    NSLog(@"Check button check %d",self.checkButton.selected);
    
    NSNumber *indexPasth=[NSNumber numberWithInteger:indexPath.row];
    if (![self.selectedFriendsArray containsObject:indexPasth])
    {
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"uncheckTaggable.png"] forState:UIControlStateNormal];
       // [self.checkButton setImage:[UIImage imageNamed:@"uncheckTaggable.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"check_boxTaggable.png"] forState:UIControlStateNormal];
       //[self.checkButton setImage:[UIImage imageNamed:@"check_boxTaggable.png"] forState:UIControlStateNormal];
       
    }
    self.checkButton.tag=indexPath.row;
    self.checkButton.frame = CGRectMake(150.0, 10.0, 20.0, 20.0);
    self.checkButton.userInteractionEnabled = YES;
    [self.checkButton addTarget:self action:@selector(buttonTouch:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //[cell addSubview:cell.checkButton];
       NSString* nameStr = [dict objectForKey:@"name"];
    NSArray* firstLastStrings = [nameStr componentsSeparatedByString:@" "];
    NSString* firstName = [firstLastStrings objectAtIndex:0];
    NSString* lastName = [firstLastStrings objectAtIndex:1];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    return cell;
}

- (void)buttonTouch:(UIButton *)aButton withEvent:(UIEvent *)event
{
  //  aButton.selected = ! aButton.selected;
    
    NSInteger bu=aButton.tag;
    NSNumber *indexpath=[NSNumber numberWithInteger:bu];
    if (![self.selectedFriendsArray containsObject:indexpath])
    {
        [aButton setBackgroundImage:[UIImage imageNamed:@"check_boxTaggable.png"] forState:UIControlStateNormal];
         //[aButton setImage:[UIImage imageNamed:@"check_boxTaggable.png"] forState:UIControlStateNormal];
        [self.selectedFriendsArray addObject:indexpath];
        if (self.selectedFriendsArray.count==1) {
             titleLabel.text=[NSString stringWithFormat:@"%lu friends selected",(unsigned long)self.selectedFriendsArray.count];
        }else{
             titleLabel.text=[NSString stringWithFormat:@"%lu friends selected",(unsigned long)self.selectedFriendsArray.count];
        }
    }
    else
    {
        [aButton setBackgroundImage:[UIImage imageNamed:@"uncheckTaggable.png"] forState:UIControlStateNormal];
        //[aButton setImage:[UIImage imageNamed:@"uncheckTaggable.png"] forState:UIControlStateNormal];
       
        [self.selectedFriendsArray removeObject:indexpath];
        
        if (self.selectedFriendsArray.count==1) {
             titleLabel.text=[NSString stringWithFormat:@"%lu friend selected",(unsigned long)self.selectedFriendsArray.count];
        }else if(self.selectedFriendsArray.count>1){
            titleLabel.text=[NSString stringWithFormat:@"%lu friends selected",(unsigned long)self.selectedFriendsArray.count];
        }else{
             titleLabel.text=@"No friend selected";
        }
        
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.friendListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [self.friendListArray objectAtIndex:indexPath.row];
    NSString *imageUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pic_small"]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    cell.textLabel.textColor=[UIColor blackColor];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"58.png"]];
    // Configure the cell...
    
    
    @try {
        if ([self.selectedFriendsArray containsObject:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception = %@",[exception name]);
    }
    @finally {
        NSLog(@"Finally");
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        if (self.selectedFriendsArray.count>50) {
            return;
        }
    
    [UIView animateWithDuration:.5 animations:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell.accessoryType==UITableViewCellAccessoryCheckmark) {
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedFriendsArray removeObject:indexPath];
    }
    else{
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedFriendsArray addObject:indexPath];
    }
    NSString *asklife = [NSString stringWithFormat:@"Ask Life (%lu selected)",(unsigned long)self.selectedFriendsArray.count]
    ;
    titleLabel.text= asklife;
}


#pragma mark- 
#pragma mark Button Action

-(void) cancelButtonClicked:(id)sender{
    [UIView animateWithDuration:1 animations:^{
        [self.view removeFromSuperview];
       // [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

-(void) sendButtonClicked:(id)sender
{
    NSMutableString *selectedFrndsString = [[NSMutableString alloc] init];
    for (int i =0; i < self.selectedFriendsArray.count; i++) {
        NSNumber *indexPath = [self.selectedFriendsArray objectAtIndex:i];
        NSDictionary *dict = [self.selectedTagFriendsArray objectAtIndex:[indexPath integerValue]];
        NSString *toString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
        
        if (i== self.selectedFriendsArray.count-1) {
            [selectedFrndsString appendString:toString];
        }
        else{
            [selectedFrndsString appendString:[NSString stringWithFormat:@"%@,",toString]];
        }
    }
     appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
       appDelegate.openGraphDict = nil;
       if (FBSession.activeSession.isOpen)
    {
        appDelegate.friendsList=selectedFrndsString;
        appDelegate.friendsCount=self.selectedFriendsArray.count;
        [GameState sharedState].selectedFrndsStringTag=selectedFrndsString;
        [appDelegate sendRequestToFriendsTaggable:selectedFrndsString];
        
    }
    else{
        appDelegate.friendsList=selectedFrndsString;
        appDelegate.friendsCount=self.selectedFriendsArray.count;
        [GameState sharedState].selectedFrndsStringTag=selectedFrndsString;
        [appDelegate openSessionWithLoginUI:7 withParams:nil];
    }
    
    [UIView animateWithDuration:1 animations:^{
        [self.view removeFromSuperview];
    }];
    
}
-(void) updateAfterRequestSent:(BOOL)value
{
    [self lifeFilled];
}

#pragma mark Life Filled
-(void)lifeFilled
{
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefillLife" object:nil];
    rootViewController = (UINavigationController*)[(AppController*)[[UIApplication sharedApplication] delegate] getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    float xCordinate;
    UIImageView * upperView;
    if(!backgroundView)
    {
        
        
        if(frame.size.width==320)
        {
            xCordinate=frame.size.height;
            backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)] autorelease];
            upperView = [[[UIImageView alloc]initWithFrame:CGRectMake(40,40, frame.size.height-80, frame.size.width-80)] autorelease];
            
        }
        else
        {
            xCordinate=frame.size.width;
            backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
            upperView = [[[UIImageView alloc]initWithFrame:CGRectMake(40,40, frame.size.width-80, frame.size.height-80)] autorelease];
            
        }
        
        
        [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbg.png"]]];
        
        [rootViewController.view addSubview:backgroundView];
        //-----------------------------------------
        
        upperView.image=[UIImage imageNamed:@"popup.png"];
        [backgroundView addSubview:upperView];
        
        
        CGRect rect;
        if(frame.size.height>480)
        rect=CGRectMake(xCordinate/2-50, 200, 100, 50);
        else
        rect=CGRectMake(xCordinate/2-50, 200, 100, 50);
        UIButton * playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = rect;
        UIImage *btnImage = [UIImage imageNamed:@"btn_play.png"];
        
        [playButton setImage:btnImage forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:playButton];
        
        //-------
        //--------lower view
        
        //-------level and target
        //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [UIView animateWithDuration:0.6f animations:^(void)
         {
             UILabel * lifeFilled=[[UILabel alloc]initWithFrame:CGRectMake(20, 30,upperView.frame.size.width-40, 80)];
             lifeFilled.text=@"Hey you got 5 lives\n enjoy the game!";
             lifeFilled.lineBreakMode=YES;
             lifeFilled.numberOfLines=0;
             // lifeFilled.textColor=[UIColor colorWithRed:(CGFloat)157/255 green:(CGFloat)214/255 blue:(CGFloat)254/255 alpha:1.0];
             lifeFilled.textAlignment=NSTextAlignmentCenter;
             lifeFilled.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:30];
             [upperView addSubview:lifeFilled];
         }];
        //        if(frame.size.height>480)
        //            rect=CGRectMake(frame.size.height-250, 60, 210, 90);
        //        else
        //            rect=CGRectMake(frame.size.height-240, 60, 210, 50);
        //
        //        target=[[UILabel alloc]initWithFrame:rect];
        //        target.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
        //
        //        target.text=[NSString stringWithFormat:@"Targeted Birds-30"];
        //        [self.backgroundView addSubview:target];
        
        //    }
        //    else
        //    {
        //        backgroundView.hidden=NO;
        //
        //        [rootViewController.view addSubview:backgroundView];
        ////        level.text=[NSString stringWithFormat:@"Level-%d",(int)levelno];
        ////        target.text=[NSString stringWithFormat:@"Targeted Birds-30"];
        //        
        //        
        //    }
    }
    
}
-(void)playButtonAction
{
    
    [[GameState sharedState].bannerAddView removeFromSuperview];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameIntro scene]]];
    [backgroundView removeFromSuperview];
}


-(void)hideFacebookFriendsList
{
    [self cancelButtonClicked:nil];
}
-(void) showHUDLoadingView:(NSString *)strTitle
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //HUD.delegate = self;
    //HUD.labelText = [strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    HUD.detailsLabelText=[strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [HUD show:YES];
}

@end
