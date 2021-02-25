//
//  PDViewController.m
//  PDPopupAnimator
//
//  Created by liang on 02/24/2021.
//  Copyright (c) 2021 liang. All rights reserved.
//

#import "PDViewController.h"
#import "PDDemoAlertView.h"
#import "PDDemoAlertController.h"

@interface PDViewController ()

@property (nonatomic, strong) PDDemoAlertView *alertView;

@end

@implementation PDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showAlert:(id)sender {
    PDDemoAlertView *alertView = [[PDDemoAlertView alloc] initWithStyle:PDAlertViewStyleAlert];
    [alertView showInView:self.view animated:YES];
}

- (IBAction)showActionSheet:(id)sender {
    PDDemoAlertView *alertView = [[PDDemoAlertView alloc] initWithStyle:PDAlertViewStyleActionSheet];
    [alertView showInView:self.view animated:YES];
}

- (IBAction)showAlertControllerByAlertStyle:(id)sender {
    PDDemoAlertController *alertController = [[PDDemoAlertController alloc] initWithStyle:PDAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)showAlertControllerByActionSheet:(id)sender {
    PDDemoAlertController *alertController = [[PDDemoAlertController alloc] initWithStyle:PDAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
