//
//  TipViewController.m
//  tipcalculator
//
//  Created by Chad Jewsbury on 9/23/15.
//  Copyright (c) 2015 Chad Jewsbury. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
- (IBAction)onBillChanged:(id)sender;
- (IBAction)onTipChanged:(id)sender;
- (void)updateValues;
- (void)setDefaultTip;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tip Calculator";
    
    // Set up the Settings button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Defaults" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setDefaultTip];
    [self updateValues];
    [self.billTextField becomeFirstResponder];
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

- (void)onSettingsButton {
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    svc.edgesForExtendedLayout = UIRectEdgeRight;
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)setDefaultTip {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger tipDefaultSegmentIndex = [userDefaults integerForKey:@"tip_default"];

    [self.tipControl setSelectedSegmentIndex:tipDefaultSegmentIndex];
}

- (IBAction)onTipChanged:(id)sender {
    [self updateValues];
}

- (IBAction)onBillChanged:(id)sender {
    [self updateValues];
}

- (void)updateValues {
    float billAmount = [self.billTextField.text floatValue];
    NSArray *tipValues = @[@(0.1), @(0.15), @(0.2), @(0.25)];
    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float totalAmount = billAmount + tipAmount;
    
    self.tipLabel.text = [NSString stringWithFormat:@"+ $%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}
@end
