//
//  AdMobViewController.h
//  CaveRunMowgli
//
//  Created by Sumit on 18/11/14.
//
//

#import <UIKit/UIKit.h>
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@class GADBannerView;

@interface AdMobViewController : UIViewController<GADBannerViewDelegate>{
    
}
@property(nonatomic,strong) GADBannerView  *bannerView ;
-(id) initWithBOOL:(BOOL)upOrDown;
@end
