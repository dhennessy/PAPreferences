//
//  ViewController.m
//  SingleView
//
//  Created by Denis Hennessy on 29/04/2014.
//  Copyright (c) 2014 Denis Hennessy. All rights reserved.
//

#import "ViewController.h"
#import "Preferences.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation ViewController

- (IBAction)buttonTapped:(id)sender {
    [Preferences sharedInstance].pressCount = [Preferences sharedInstance].pressCount + 1;
    [self configureMessage];
}

- (void)configureMessage {
    _progressLabel.hidden = NO;
    _progressLabel.text = [NSString stringWithFormat:@"Button has been pressed %ld times", (long)[Preferences sharedInstance].pressCount];
}

@end
