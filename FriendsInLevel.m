//
//  FriendsInLevel.m
//  BowHunting
//
//  Created by GLB-254 on 12/8/14.
//  Copyright 2014 tang. All rights reserved.
//

#import "FriendsInLevel.h"
#import "LevelSelectionScene.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
@implementation FriendsInLevel
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    FriendsInLevel *layer = [FriendsInLevel node];
    
    // add layer as a child to scene
    [scene addChild:layer];
    
    // return the scene
    return scene;
}
-(id) init
{
    if( (self=[super init]))
    {
        CGSize ws=[[CCDirector sharedDirector]winSize];
       
       viewController = (UIViewController*)[(AppController *)[[UIApplication sharedApplication] delegate] getRootViewController];
            if ([UIScreen mainScreen].scale == 2.f) {
            // NSLog(@"iPad....");
            spriteBackground=[CCSprite spriteWithFile:@"sky-568h@2x.jpg"];
        }
        else{
            spriteBackground=[CCSprite spriteWithFile:@"sky.png"];
        }
       
        spriteBackground.position=ccp(ws.width*0.5,ws.height*0.5);
        [self addChild:spriteBackground];
        levelBackground=[CCSprite spriteWithFile:@"game-bg.png"];
        levelBackground.position=ccp(ws.width/2,ws.height/2);
        [self addChild:levelBackground];
        
       
        secondView = [[UIView alloc]initWithFrame:CGRectMake(110, 20, 242, 291)];
        [secondView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]]];
        [viewController.view addSubview:secondView];
        
        scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
        
        scrollV.contentSize=CGSizeMake(100,250);
        scrollV.scrollEnabled=YES;
        friendsLevel = [[UILabel alloc]initWithFrame:CGRectMake(170, -20, 200, 100)];
        friendsLevel.text=@"Friends Level";
        friendsLevel.font=[UIFont boldSystemFontOfSize:15];
        [viewController.view addSubview:friendsLevel];
        [secondView addSubview:scrollV];
        playButton = [[UIButton alloc]init];
        playButton.frame = CGRectMake(70,220, 100, 50);
        [playButton setBackgroundImage:[UIImage imageNamed:@"btn_play.png"]forState:UIControlStateNormal];
        [secondView addSubview:playButton];
        [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            secondView.frame=CGRectMake(170, 20, 242, 291);
            friendsLevel.frame=CGRectMake(220, -20, 200, 100);
        }
        else
        {
            secondView.frame=CGRectMake(110, 20, 242, 291);
        }

        [self fetchUserInLevelFromParse];
    }
    return self;
}
-(void)playAction:(id)sender
{
    friendsLevel.hidden=YES;
    secondView.hidden = YES;
    [self removeChild:spriteBackground cleanup:YES];
    [self removeChild:levelBackground cleanup:YES];
    self.musicIsOn=YES;
        LevelSelectionScene *obj = [[[LevelSelectionScene alloc]init:self.musicIsOn] autorelease];
    [self addChild:obj];
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
        NSMutableArray * fbFriendSingle=[[NSMutableArray alloc]init];
        NSMutableArray * friendDetial=[[NSMutableArray alloc]init];
        for(int i=0;i<[temp count];i++)
        {
            PFObject * obj=[temp objectAtIndex:i];
            if([fbFriendSingle containsObject:obj[@"PlayerFacebookID"]])
            {
                NSLog(@"Repeated One");
            }
            else
            {
                [friendDetial addObject:obj];
                [fbFriendSingle addObject:obj[@"PlayerFacebookID"]];
            }
            
        }
        for (int i=0; i<[friendDetial count]; i++)
        {
            PFObject * obj=[friendDetial objectAtIndex:i];

            NSString *player1 = obj[@"PlayerFacebookID"];
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",player1]];
            NSString *urlString = [NSString   stringWithFormat:@"https://graph.facebook.com/%@",player1];
            //for name
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *aimgeView = (UIImageView*)[secondView viewWithTag:100+i];
                UILabel *label = (UILabel*)[secondView viewWithTag:300+i];
                UILabel *positionLabel=(UILabel*)[secondView viewWithTag:3000+i];
                if (aimgeView == nil) {
                    //                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i*90), 60, 35, 35)];
                    
                    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10+(i*40), 30, 30)];
                    profileImageView.tag = 100+i;
                    profileImageView.layer.borderWidth=2;
                    profileImageView.layer.borderColor=[[UIColor colorWithRed:(CGFloat)81/255 green:(CGFloat)144/255 blue:(CGFloat)142/255 alpha:1]CGColor];
                    
                    [scrollV addSubview:profileImageView];
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58.png"]];
                }
                else{
                    aimgeView.hidden = NO;
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58.png"]];
                }
                if (label==nil) {
                    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10+(i*40), 150, 20)];
                    infoLabel.tag = 300+i;
                    infoLabel.backgroundColor = [UIColor clearColor];
                    infoLabel.font = [UIFont boldSystemFontOfSize:10];
                    infoLabel.textAlignment=NSTextAlignmentCenter;
                    infoLabel.numberOfLines = 0;
                    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    infoLabel.text =[self forName:urlString];
                    [scrollV addSubview:infoLabel];
                    
                    [infoLabel sizeToFit];
                }
                else{
                    label.hidden = NO;
                    //  label.text = [NSString stringWithFormat:@"%@",name[i]];
                    [label sizeToFit];
                }
                
                
                if(positionLabel==nil)
                {
                    
                    
                    position=[[UILabel alloc] initWithFrame:CGRectMake(50, 10+(i*40), 150, 45)];
                    position.tag = 3000+i;
                    position.textColor =[UIColor colorWithRed:(CGFloat)81/255 green:(CGFloat)144/255 blue:(CGFloat)142/255 alpha:1];
                    position.backgroundColor=[UIColor clearColor];
                    [position setFont:[UIFont fontWithName:@"ShallowGraveBB" size:20]];
                    position.textAlignment=NSTextAlignmentLeft;
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%d",[obj[@"level"] intValue]];
                    [scrollV addSubview:position];
                    
                }
                else
                {
                    positionLabel.hidden=NO;
                    position.text = [NSString stringWithFormat:@"%d",[obj[@"level"] intValue]];
                    
                    
                }
               
            });
            
  
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

 -(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}
@end
