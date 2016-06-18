//
//  VenueMySideViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "VenueMySideViewController.h"

@interface VenueMySideViewController ()

@end

@implementation VenueMySideViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.leftGapPercentage = 260.0f / 320.0f;
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
    int i = 0;
    i++;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    UIDevice *device = [UIDevice currentDevice];
    
    if(device.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        self.bounceOnCenterPanelChange = NO;
        if (UIInterfaceOrientationIsLandscape((UIInterfaceOrientation)device.orientation))
        {
            //NSLog(@"Change to custom UI for landscape");
            self.rightGapPercentage = 0.30f;
            
        }
        else if (UIInterfaceOrientationIsPortrait((UIInterfaceOrientation)device.orientation))
        {
            //NSLog(@"Change to custom UI for portrait");
            self.rightGapPercentage = 0.40f;
            
        }
        
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        self.rightGapPercentage = 0.85f;
        return UIInterfaceOrientationMaskPortrait;
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) awakeFromNib {
    
    if([[commonUtils getUserDefault:@"aps_type"] isEqualToString:@"6"]){
        [commonUtils setUserDefault:@"aps_type" withFormat:@"0"];
        AcceptedOfferViewController *rootViewController = [self.storyboard  instantiateViewControllerWithIdentifier:@"AcceptedOfferVC"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: rootViewController];
        
        [self setCenterPanel:navController];
        [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"venueleftPanelPage"]];
        
    }else
    {

        PeopleNearbyViewController *rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleNearbyVC"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: rootViewController];
        [self setCenterPanel:navController];
        [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"venueleftPanelPage"]];
    }
}


#pragma mark - JA side panels UI edit
- (void)styleContainer:(UIView *)container animate:(BOOL)animate duration:(NSTimeInterval)duration {
}

- (void)stylePanel:(UIView *)panel {
}



@end
