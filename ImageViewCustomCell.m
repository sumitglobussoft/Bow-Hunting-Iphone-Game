//
//  ImageViewCustomCell.m
//  Anypic
//
//  Created by Globussoft 1 on 9/2/14.
//
//

#import "ImageViewCustomCell.h"
@implementation ImageViewCustomCell
@synthesize imageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"nameTaggable.png"]];
        self.backGroundImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,self.contentView.frame.size.height)];
        self.backGroundImageView.userInteractionEnabled=YES;
        self.backGroundImageView.image=[UIImage imageNamed:@"nameTaggable.png"];
        [self.contentView addSubview:self.backGroundImageView];
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        [self.backGroundImageView addSubview:self.imageView];
        self.textLabel=[[UILabel alloc]initWithFrame:CGRectMake(40,0,100, 40)];
        self.textLabel.font=[UIFont fontWithName:@"Helvetica" size:10];
//           self.textLabel.textAlignment=NSTextAlignmentNatural;
         self.textLabel.lineBreakMode=NSLineBreakByCharWrapping;
           self.textLabel.numberOfLines=0;
         self.textLabel.backgroundColor=[UIColor clearColor];
//        self.textLabel.text=@"tiger";
        [self.textLabel setTextColor:[UIColor blackColor]];
                  
          [self.backGroundImageView addSubview:self.textLabel];
        
       /* self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkButton setImage:[UIImage imageNamed:@"uncheckTaggable.png"] forState:UIControlStateNormal];
        [self.checkButton setImage:[UIImage imageNamed:@"check_boxTaggable.png"] forState:UIControlStateSelected];
        [self.backgroundView addSubview:self.checkButton];
//        self.checkButton=[[UIImageView alloc] initWithFrame:CGRectMake(100.0, 10.0, 20.0, 20.0)];
//        [self.contentView addSubview:self.checkButton];*/
//----------------------------------------------------------------------------
                

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
