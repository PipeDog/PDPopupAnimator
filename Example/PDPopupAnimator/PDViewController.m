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
#import "PDActionSheetController.h"

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
    PDActionSheetController *alertController = [[PDActionSheetController alloc] initWithStyle:PDAlertControllerStyleActionSheet];
    
    [alertController addAction:[PDAlertAction actionWithTitle:@"第 1 条" style:PDAlertActionStyleDefault handler:^(PDAlertAction * _Nonnull action) {
        NSLog(@"点击了第 1 条");
    }]];
    
    [alertController addAction:[PDAlertAction actionWithTitle:@"第 2 条" style:PDAlertActionStyleDefault handler:^(PDAlertAction * _Nonnull action) {
        NSLog(@"点击了第 2 条");
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)didClickQueueButton:(id)sender {    
    for (NSInteger i = 0; i < 5; i++) {
        PDAlertViewStyle style = i % 2 == 0 ? PDAlertViewStyleAlert : PDAlertViewStyleActionSheet;
        PDDemoAlertView *alertView = [[PDDemoAlertView alloc] initWithStyle:style];
        [alertView showInView:nil animated:YES completion:^{
            NSLog(@">>>>> [view] show %zd", i);
        }];
        
        PDAlertControllerStyle controllerStyle = i % 2 != 0 ? PDAlertControllerStyleAlert : PDAlertControllerStyleActionSheet;
        PDActionSheetController *alertController = [[PDActionSheetController alloc] initWithStyle:controllerStyle];
        
        [alertController addAction:[PDAlertAction actionWithTitle:@"打印 1" style:PDAlertActionStyleDefault handler:^(PDAlertAction * _Nonnull action) {
            NSLog(@">>>>> log `1`.");
        }]];
        
        [alertController addAction:[PDAlertAction actionWithTitle:@"打印 2" style:PDAlertActionStyleDefault handler:^(PDAlertAction * _Nonnull action) {
            NSLog(@">>>>> log `2`.");
        }]];
        
        [alertController addAction:[PDAlertAction actionWithTitle:@"取消" style:PDAlertActionStyleCancel handler:^(PDAlertAction * _Nonnull action) {
            // Do nothing...
        }]];
        
        [alertController showInController:self animated:YES completion:^{
            NSLog(@">>>>> [controller] show %zd", i);
        }];
    }
}

@end
