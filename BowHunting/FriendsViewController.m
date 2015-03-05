//
//  FriendsViewController.m
//  CaveRun
//
//  Created by GBS-ios on 8/18/14.
//
//

#import "FriendsViewController.h"
#import "UIImageView+WebCache.h"


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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) updateFriendsView{
    self.view.backgroundColor = [UIColor redColor];
    self.frame = [UIScreen mainScreen].bounds;
    [self createUI];
    
    [self createTableView];
}
-(void) createUI{
    
    if (!self.headerView) {
        self.headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, 50)] autorelease];
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = self.headerView.bounds;
        
        UIColor *firstColor = [UIColor colorWithRed:(CGFloat)78/255 green:(CGFloat)105/255 blue:(CGFloat)162/255 alpha:1];
        UIColor *secColor = [UIColor colorWithRed:(CGFloat)59/255 green:(CGFloat)89/255 blue:(CGFloat)152/255 alpha:1];
        layer.colors = @[(id)firstColor.CGColor, (id)secColor.CGColor];
        [self.headerView.layer insertSublayer:layer atIndex:0];
        
        [self.view addSubview:self.headerView];
        UILabel * lblSelectFrnd=[[UILabel alloc]initWithFrame:CGRectMake(12, 40, 100, 40)];
        lblSelectFrnd.text=@"Select Friend to tag";
        [self.headerView addSubview:lblSelectFrnd];
        //Add Cancel Button
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(12, 20, 60, 25);
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        cancelButton.layer.borderWidth = 0.7;
        cancelButton.layer.borderColor = [UIColor colorWithRed:(CGFloat)29/255 green:(CGFloat)70/255 blue:(CGFloat)140/255 alpha:1].CGColor;
        cancelButton.layer.cornerRadius = 5;
        cancelButton.clipsToBounds = YES;
        [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:cancelButton];
        
        //Add Send Button
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake(self.frame.size.height-64, 20, 50, 25);
        [sendButton setTitle:@"Send" forState:UIControlStateNormal];
        sendButton.layer.borderWidth = 0.7;
        sendButton.layer.borderColor = [UIColor colorWithRed:(CGFloat)29/255 green:(CGFloat)70/255 blue:(CGFloat)140/255 alpha:1].CGColor;
        sendButton.layer.cornerRadius = 5;
        sendButton.clipsToBounds = YES;
        [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:sendButton];
        
        //===========
        //Add Title Label
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(75, 23, self.frame.size.height-150, 20)] autorelease] ;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.headerTitle;
        [self.headerView addSubview:titleLabel];
    }
    
}

-(void) createTableView{
    
    if (!self.listTableView) {
        self.listTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height, self.frame.size.height, self.frame.size.width - self.headerView.frame.size.height) style:UITableViewStylePlain] autorelease];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        [self.view addSubview:self.listTableView];
    }
    
}

#pragma mark-


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
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Bow hunting mobile icon_ver2.png"]];
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
    if (!self.selectedFriendsArray) {
        self.selectedFriendsArray
        = [[[NSMutableArray alloc] init] autorelease];
    }
    [UIView animateWithDuration:.5 animations:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell.accessoryType==UITableViewCellAccessoryCheckmark) {
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([self.selectedFriendsArray containsObject:indexPath]) {
            [self.selectedFriendsArray removeObject:indexPath];
        }
        
    }
    else{
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedFriendsArray addObject:indexPath];
    }
}
#pragma mark -
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- 
#pragma mark Button Action

-(void) cancelButtonClicked:(id)sender{
    [UIView animateWithDuration:1 animations:^{
        [self dismissViewControllerAnimated:YES completion:^{
            [self.selectedFriendsArray removeAllObjects];
            self.selectedFriendsArray = nil;
            [self.view removeFromSuperview];
            
        }];
    }];
    
}

-(void) sendButtonClicked:(id)sender{
    //NSLog(@"Self. selected friends = %@", self.selectedFriendsArray);
    
    if (self.selectedFriendsArray.count<1) {
        [[[UIAlertView alloc] initWithTitle:@"Select atleast one friend" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    NSMutableString *selectedFrndsString = [[[NSMutableString alloc] init] autorelease];
    for (int i =0; i < [self.selectedFriendsArray count]; i++) {
        NSIndexPath *indexPath = [self.selectedFriendsArray objectAtIndex:i];
        NSDictionary *dict = [self.friendListArray objectAtIndex:indexPath.row];
        NSString *toString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
        
        if (i== self.selectedFriendsArray.count-1) {
             [selectedFrndsString appendString:toString];
        }
        else{
            [selectedFrndsString appendString:[NSString stringWithFormat:@"%@,",toString]];
        }
    }
    NSLog(@"Selected Friends String = %@",selectedFrndsString);
    
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    
    NSString *lifeReq = nil;
    
    NSMutableDictionary* params = nil;
    
    if (self.isLifeRequest == YES) {
        NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"Life Request"], @"message", nil];
       lifeReq = [jsonWriter stringWithObject:challenge];

        params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:selectedFrndsString, @"to", lifeReq, @"data",@"sending life request",@"message",@"Send Live Request",@"Title",nil];
    }
    else{
        NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"Invitation"], @"message", nil];
        lifeReq = [jsonWriter stringWithObject:challenge];
        
        params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:selectedFrndsString, @"to",lifeReq, @"data",@"invite friends",@"Title",@"Invite Friends",@"message",nil];
    }
    [jsonWriter release];
    appDelegate.openGraphDict = nil;
    // Create a dictionary of key/value pairs which are the parameters of the dialog
    
    // 1. No additional parameters provided - enables generic Multi-friend selector
   
    
    if (FBSession.activeSession.isOpen)
    {
        [appDelegate sendRequestToFriends:params];
        
    }
    else{
        [appDelegate openSessionWithLoginUI:2 withParams:params];
    }
}
-(void)hideFacebookFriendsList{
    [self cancelButtonClicked:nil];
}
-(void) updateAfterRequestSent:(BOOL)value{
    if (self.isLifeRequest==NO) {
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updatePurchaseScene:)]) {
            [self.delegate updatePurchaseScene:value];
        }
    }
}
@end
