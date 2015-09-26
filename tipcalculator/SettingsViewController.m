//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Chad Jewsbury on 9/23/15.
//  Copyright (c) 2015 Chad Jewsbury. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;
- (IBAction)defaultChanged:(id)sender;
- (void)setDefaultTip;
- (void)updateDefaultTip;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultTip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)defaultChanged:(id)sender {
    [self updateDefaultTip];
}

- (void)setDefaultTip {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger tipDefaultSegmentIndex = [userDefaults integerForKey:@"tip_default"];

    [self.defaultTipControl setSelectedSegmentIndex:tipDefaultSegmentIndex];
}

- (void)updateDefaultTip {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setInteger:self.defaultTipControl.selectedSegmentIndex forKey:@"tip_default"];
}
@end
