//
//  PDViewController.m
//  PDPopupAnimator
//
//  Created by liang on 02/24/2021.
//  Copyright (c) 2021 liang. All rights reserved.
//

#import "PDViewController.h"
#import "PDActionSheet.h"
#import "PDAlertView.h"

@interface PDViewController ()

@property (nonatomic, strong) PDActionSheet *actionSheet;
@property (nonatomic, strong) PDAlertView *alertView;

@end

@implementation PDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showActionSheet:(id)sender {
    [self.actionSheet showInView:nil animated:YES];
}

- (IBAction)showAlert:(id)sender {
    [self.alertView showInView:nil animated:YES];
}

#pragma mark - Getter Methods
- (PDActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[PDActionSheet alloc] init];
    }
    return _actionSheet;
}

- (PDAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[PDAlertView alloc] init];
    }
    return _alertView;
}

@end
