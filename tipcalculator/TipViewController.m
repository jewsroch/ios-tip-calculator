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
@property (nonatomic, strong) NSNumberFormatter *currencyFormatter;
@property (weak, nonatomic) IBOutlet UIView *line;

- (IBAction)onBillChanged:(id)sender;
- (IBAction)onTipChanged:(id)sender;
- (void)updateValues;
- (void)setTipWithDefault;
- (void)hideTipAndTotal;
- (void)showTipAndTotal;
- (void)hideTipAndTotalWithAnimation:(BOOL)animated;
- (void)showTipAndTotalWithAnimation:(BOOL)animated;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tip+";

    // Delegate Events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onApplicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onApplicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];

    // Set up the Settings button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Defaults" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];

    // Set up Currency Converter
    self.currencyFormatter = [[NSNumberFormatter alloc] init];
    [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Set localized placeholder
    self.billTextField.placeholder = [self.currencyFormatter currencySymbol];

    // Reset View
    [self setTipWithDefault];
    [self updateValues];
    [self updateViewWithAnimation:YES];

    // Force Number Pad to be visible on load
    [self.billTextField becomeFirstResponder];

    [super viewWillAppear:animated];
}

- (void)hideTipAndTotal {
    // Fade out the tip and total
    self.tipLabel.alpha = 0;
    self.totalLabel.alpha = 0;
    self.line.alpha = 0;

    // Slide Bill & Tip Control Down
    CGRect billControlFrame = self.billTextField.frame;
    billControlFrame.origin.y = 153;
    self.billTextField.frame = billControlFrame;

    CGRect tipControlFrame = self.tipControl.frame;
    tipControlFrame.origin.y = 344;
    self.tipControl.frame = tipControlFrame;
}

- (void)showTipAndTotal {
    // Fade out the tip and total
    self.tipLabel.alpha = 1;
    self.totalLabel.alpha = 1;
    self.line.alpha = 1;

    // Slide Tip Control Up
    CGRect billControlFrame = self.billTextField.frame;
    billControlFrame.origin.y = 85;
    self.billTextField.frame = billControlFrame;

    CGRect tipControlFrame = self.tipControl.frame;
    tipControlFrame.origin.y = 194;
    self.tipControl.frame = tipControlFrame;
}

- (void)updateViewWithAnimation:(BOOL)animated
{
    float bill = [self.billTextField.text floatValue];

    if (bill == 0 || bill == [@"" floatValue]) {
        [self hideTipAndTotalWithAnimation:animated];
    } else {
        [self showTipAndTotalWithAnimation:animated];
    }
}

- (void)showTipAndTotalWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            [self showTipAndTotal];
        } completion:^(BOOL finished) {
        }];
    }
    else {
        [self showTipAndTotal];
    }
}

- (void)hideTipAndTotalWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            [self hideTipAndTotal];
        } completion:^(BOOL finished) {
        }];
    }
    else {
        [self hideTipAndTotal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onSettingsButton {
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    svc.edgesForExtendedLayout = UIRectEdgeRight;

    [self.navigationController pushViewController:svc animated:YES];
}

- (void)setTipWithDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger tipDefaultSegmentIndex = [userDefaults integerForKey:@"tip_default"];

    [self.tipControl setSelectedSegmentIndex:tipDefaultSegmentIndex];
}

- (IBAction)onTipChanged:(id)sender {
    [self updateValues];
}

- (IBAction)onBillChanged:(id)sender {
    [self updateValues];

    [self updateViewWithAnimation:YES];
}

- (void)onApplicationWillResignActive {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.billTextField.text forKey:@"recent_bill_value"];
    [userDefaults setObject:[NSDate date] forKey:@"recent_bill_date_time"];
    [userDefaults setInteger:self.tipControl.selectedSegmentIndex forKey:@"recent_tip_index"];
}

- (void)onApplicationWillEnterForeground {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval timeSinceSet = [[NSDate date] timeIntervalSinceDate:[userDefaults valueForKey:@"recent_bill_date_time"]];

    if (timeSinceSet < 600) {
        self.billTextField.text = [userDefaults valueForKey:@"recent_bill_value"];
        self.tipControl.selectedSegmentIndex = [userDefaults integerForKey:@"recent_tip_index"];
    } else {
        self.billTextField.text = @"";
        [self setTipWithDefault];
    }

    [self updateValues];
}

- (void)updateValues {
    NSArray *tipValues = @[@(0.1), @(0.15), @(0.2), @(0.25)];
    float billAmount = [self.billTextField.text floatValue];
    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float totalAmount = billAmount + tipAmount;
    
    NSDecimalNumber *tip = [[NSDecimalNumber alloc] initWithFloat:tipAmount];
    NSDecimalNumber *total = [[NSDecimalNumber alloc] initWithFloat:totalAmount];

    self.tipLabel.text = [self.currencyFormatter stringFromNumber:tip];
    self.totalLabel.text = [self.currencyFormatter stringFromNumber:total];
}
@end
