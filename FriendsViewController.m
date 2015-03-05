//
//  FriendsViewController.m
//  CaveRun
//
//  Created by GBS-ios on 8/18/14.
//
//

#import "FriendsViewController.h"
#import "UIImageView+WebCache.h"
#import "ImageViewCustomCell.h"
#import "AppDelegate.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

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

    // Do any additional setup after loading the view.
    
//    NSString *asklife = [NSString stringWithFormat:@"Ask Life (%lu selected)",(unsigned long)self.selectedFriendsArray.count]
//    ;
//    titleLabel.text= asklife;

  self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)252/255 green:(CGFloat)196/255 blue:(CGFloat)132/255 alpha:1.0];
    // self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"Ask_extra_lives.png"]];
    self.frame = [UIScreen mainScreen].bounds;
    [self createUI];
    
    NSArray *frndsListArray = [[NSUserDefaults standardUserDefaults] objectForKey:FacebookAllFriends];
//    NSLog(@"frnds = %@",frndsListArray);
    self.friendListArray = [NSArray arrayWithArray:frndsListArray];
    self.selectedFriendsArray = [[NSMutableArray alloc] init];
    self.selectedTagFriendsArray = [[NSMutableArray alloc] init];
    [self.selectedTagFriendsArray addObjectsFromArray:self.friendListArray];
     NSMutableArray *tagArray=[[NSMutableArray alloc] init];
    
    if (self.friendListArray.count<50) {
        for (int i=0 ; i<self.friendListArray.count; i++) {
            
            [self.selectedFriendsArray addObject:[NSNumber numberWithInteger:i]];
            
        }
    }else{
        for (int i=0; i<self.friendListArray.count; i++) {
         NSInteger randomNumber = arc4random() % self.friendListArray.count;
            
                 if (![tagArray containsObject:[NSNumber numberWithInteger:randomNumber]]) {
                  [self.selectedTagFriendsArray exchangeObjectAtIndex:randomNumber withObjectAtIndex:i];
                  [tagArray addObject:[NSNumber numberWithInteger:i]];
                }
            if (tagArray.count==50) {
                break;
            }
        }
          [self.selectedFriendsArray addObjectsFromArray:tagArray];
        
    }
    
 
    
    [self createTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) createUI{
    NSLog(@"self.frame.size.height  = %f",self.frame.size.height);
    
    NSString *str = [[UIDevice currentDevice]model];
    NSLog(@"str is %@",str);
//    CGRect frame = [UIScreen mainScreen].bounds;
//    float yCordinate;
//    if(frame.size.width==320)
//    {
//        yCordinate=frame.size.width;
//    }
//    else
//    {
//        yCordinate=frame.size.height;
//    }

//    if(frame.size.width==320)
//    {
//     
//        //530
//    }else{
//        
//        //450,80
//    }
    if([UIScreen mainScreen].bounds.size.height>500){
        self.headerView = [[[UIView alloc] initWithFrame:CGRectMake(50, 30, 473,265)] autorelease];
//iphone 6
        //530
    }else{
       self.headerView = [[[UIView alloc] initWithFrame:CGRectMake(10, 30, 473,265)] autorelease];
        //450,80
    }
    
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//         NSLog(@"headerview iphone 6  = %f",self.frame.size.height);
////         if([UIScreen mainScreen].bounds.size.width>660) {
//        self.headerView = [[[UIView alloc] initWithFrame:CGRectMake(50, 30, 473,265)] autorelease];//iphone 6
////         }
//    }
   
    self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Ask_extra_lives.png"]];
   [self.view addSubview:self.headerView];
    
    

    
    //Add Cancel Button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelButton.frame = CGRectMake(12, 20, 60, 25);self.frame.size.height-64, 20, 50, 25
     cancelButton.frame = CGRectMake(12, 20, 60, 25);
    
//    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"close2.png"] forState:UIControlStateNormal];
//    cancelButton.layer.borderWidth = 0.7;
//    cancelButton.layer.borderColor = [UIColor colorWithRed:(CGFloat)29/255 green:(CGFloat)70/255 blue:(CGFloat)140/255 alpha:1].CGColor;
//    cancelButton.layer.cornerRadius = 5;
//    cancelButton.clipsToBounds = YES;
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:cancelButton];
    
    //Add Send Button
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
 
   
    if([UIScreen mainScreen].bounds.size.height>500){
        sendButton.frame = CGRectMake(380, 20, 87, 40);//iphone 6
        //530
    }else{
         sendButton.frame = CGRectMake(380, 20, 77, 30);
        //450,80
    }
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//        NSLog(@"send iphone 6 %f",self.frame.size.height);
////         if([UIScreen mainScreen].bounds.size.width>660) {
//       //         }
//    }

    
//    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
//    sendButton.layer.borderWidth = 0.7;
//    sendButton.layer.borderColor = [UIColor colorWithRed:(CGFloat)29/255 green:(CGFloat)70/255 blue:(CGFloat)140/255 alpha:1].CGColor;
//    sendButton.layer.cornerRadius = 5;
//    sendButton.clipsToBounds = YES;
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:sendButton];
    
    //===========
    
  
    
    if([UIScreen mainScreen].bounds.size.height>500){
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,220,self.frame.size.height, 20)] ;//iphone 6
        //530
    }else{
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,220,self.frame.size.height-20, 20)] ;
    }
    
    if (self.frame.size.width>self.frame.size.height) {
       self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,220,self.frame.size.width, 20)] ;
    }
    
    

    self.noteLabel.textColor = [UIColor blackColor];
//     self.noteLabel.numberOfLines = 2;
    self.noteLabel.font = [UIFont boldSystemFontOfSize:12];
    self.noteLabel.backgroundColor = [UIColor clearColor];
//    self.noteLabel.textAlignment = NSTextAlignmentCenter;
    self.noteLabel.text = @"Note:You will get one life for every 5 Friends. So tag as many as you want!";
    [self.headerView addSubview:self.noteLabel];

}

-(void) createTableView
{
    

    
   
    
    if([UIScreen mainScreen].bounds.size.height>500){
         titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,200,self.frame.size.height-150, 20)] ;//iphone 6
        //530
    }else{
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
   
    
    if([UIScreen mainScreen].bounds.size.height>500){
        self.listTableView = [[UICollectionView alloc] initWithFrame:CGRectMake(25,75,self.frame.size.width+100,110) collectionViewLayout:layout];//
    }else{
         self.listTableView = [[UICollectionView alloc] initWithFrame:CGRectMake(25,80,self.frame.size.width+100,110) collectionViewLayout:layout];
    }
    
    if (self.frame.size.width>self.frame.size.height) {
         self.listTableView = [[UICollectionView alloc] initWithFrame:CGRectMake(25,80,self.frame.size.height+100,110) collectionViewLayout:layout];
    }

    
    [self.listTableView registerClass:[ImageViewCustomCell class] forCellWithReuseIdentifier:@"cell"];
   [self.listTableView setBackgroundColor:[UIColor clearColor]];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.headerView addSubview:self.listTableView];

}

#pragma mark-

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSLog(@"self = %lu",(unsigned long)self.friendListArray.count);
    return self.friendListArray.count;
}
// 2


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier=@"cell";
    
    NSDictionary *dict = [self.selectedTagFriendsArray objectAtIndex:indexPath.row];
    NSString *imageUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pic_small"]];
    
    
    ImageViewCustomCell * cell=(ImageViewCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"58.png"]];

    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal ];
    [self.checkButton setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateSelected ];

    
    NSNumber *indexPasth=[NSNumber numberWithInteger:indexPath.row];
    if (![self.selectedFriendsArray containsObject:indexPasth]) {
        [self.checkButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal ];
        
    }else{
        [self.checkButton setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal ];
        [self.checkButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateSelected ];
        //      self.checkButton.selected = YES;
        
        
    }
    self.checkButton.frame = CGRectMake(150.0, 10.0, 20.0, 20.0);
    self.checkButton.tag=indexPath.row;
    self.checkButton.userInteractionEnabled = YES;
    [self.checkButton addTarget:self action:@selector(buttonTouch:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:self.checkButton];
    
    NSString* nameStr = [dict objectForKey:@"name"];
    NSArray* firstLastStrings = [nameStr componentsSeparatedByString:@" "];
    NSString* firstName = [firstLastStrings objectAtIndex:0];
    NSString* lastName = [firstLastStrings objectAtIndex:1];
   cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    return cell;
}

- (void)buttonTouch:(UIButton *)aButton withEvent:(UIEvent *)event
{
    aButton.selected = ! aButton.selected;
    
    NSInteger bu=aButton.tag;
    NSNumber *indexpath=[NSNumber numberWithInteger:bu];
    if (![self.selectedFriendsArray containsObject:indexpath]) {
        [self.selectedFriendsArray addObject:indexpath];
        if (self.selectedFriendsArray.count==1) {
             titleLabel.text=[NSString stringWithFormat:@"%lu friends selected",(unsigned long)self.selectedFriendsArray.count];
        }else{
             titleLabel.text=[NSString stringWithFormat:@"%lu friends selected",(unsigned long)self.selectedFriendsArray.count];
        }
    }else{
        
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

-(void) sendButtonClicked:(id)sender{
    //NSLog(@"Self. selected friends = %@", self.selectedFriendsArray);
    
    
    if (self.selectedFriendsArray.count<5) {
        [[[UIAlertView alloc] initWithTitle:@"Select atleast 5 Friends to get a life" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
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
   // NSLog(@"Selected Friends String = %@",selectedFrndsString);
    
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"Life Request"], @"message", nil];
    appDelegate.openGraphDict = nil;
    
    if (FBSession.activeSession.isOpen)
    {
        appDelegate.friendsList=selectedFrndsString;
        appDelegate.friendsCount=self.selectedFriendsArray.count;
        [appDelegate sendRequestToFriendsTaggable:selectedFrndsString];
        
    }
    else{
        appDelegate.friendsList=selectedFrndsString;
        appDelegate.friendsCount=self.selectedFriendsArray.count;
         [appDelegate openSessionWithLoginUI:7 withParams:nil withString:selectedFrndsString];
    }
    
    [UIView animateWithDuration:1 animations:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}
-(void)hideFacebookFriendsList{
    [self cancelButtonClicked:nil];
}

@end
