//
//  TermsUSViewController.m
//  Mixl
//
//  Created by Branislav on 4/27/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "TermsUSViewController.h"

@interface TermsUSViewController ()

@end

@implementation TermsUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _btnDone.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnDone.layer.borderWidth = 2.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
