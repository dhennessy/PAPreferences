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

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![Preferences sharedInstance].hasSeenIntro) {
        [Preferences sharedInstance].hasSeenIntro = YES;
    } else {
        _welcomeLabel.hidden = YES;
    }
    [self configureMessage];
}

- (IBAction)buttonTapped:(id)sender {
    [Preferences sharedInstance].pressCount = [Preferences sharedInstance].pressCount + 1;
    [self configureMessage];
}

- (void)configureMessage {
    _progressLabel.text = [NSString stringWithFormat:@"Button has been pressed %ld times", (long)[Preferences sharedInstance].pressCount];
}

@end
