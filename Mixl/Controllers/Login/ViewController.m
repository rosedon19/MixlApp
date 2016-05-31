//
//  ViewController.m
//  Mixl
//
//  Created by admin on 4/6/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated {
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initView {
    
    _activeIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activeIndicator.color = [UIColor whiteColor];
    [_activeIndicator startAnimating];
    [self performSelector:@selector(didFinishSplashScreen) withObject:self afterDelay:1.0];
}

- (void) didFinishSplashScreen {
    [_activeIndicator stopAnimating];
    [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
}


@end
