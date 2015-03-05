//
//  AdMobViewController.m
//  CaveRunMowgli
//
//  Created by Sumit on 18/11/14.
//
//

#import "AdMobViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "GameState.h"
@interface AdMobViewController ()

@end

@implementation AdMobViewController
@synthesize bannerView ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithBOOL:(BOOL)upOrDown
{
    //self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.width-40,self.view.frame.size.height, 40)];
   
    CGRect frame = [UIScreen mainScreen].bounds;
    float yCordinate;
    if(frame.size.width==320)
    {
        yCordinate=frame.size.width;
    }
    else
    {
        yCordinate=frame.size.height;
    }

    if(upOrDown)
    {
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,yCordinate-40,480, 40)];
       // self.bannerView=[[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerLandscape];
       // self.bannerView=[[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, self.view.frame.size.height-30)];
    }
   else
   {
   //self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,0,480, 40)];
        self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,yCordinate-40,480, 40)];
       //self.bannerView=[[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerLandscape];
     //  self.bannerView=[[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, self.view.frame.size.height-30)];
   }
    //Testing
    self.bannerView.adUnitID=@"ca-app-pub-7073257741073458/4307824695";
    //Live
  //  self.bannerView.adUnitID = @"ca-app-pub-7881880964352996/9450142066";
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self ;
    
    GADRequest *request = [GADRequest alloc] ;
    NSString * deviceId= [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSLog(@"UDID %@",deviceId);
    //request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,@"aa0b851647e65f82de1c9d0555ede1d9",nil];//
    [self.bannerView loadRequest:request];
  
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
}

                           
- (void) adView: (GADBannerView*) view didFailToReceiveAdWithError: (GADRequestError*) error
{
    [GameState sharedState].failToLoadBanner=TRUE;
    NSLog(@"did fail to receive");
}

- (void) adViewDidReceiveAd: (GADBannerView*) view
{
    // [[NSNotificationCenter defaultCenter]postNotificationName:@"loadAdd" object:nil];
    [self.view addSubview:self.bannerView];
 [GameState sharedState].failToLoadBanner=false;
    NSLog(@"add received");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
