//
//  Preferences.h
//  PAPreferencesSample
//
//  Created by Denis Hennessy on 29/04/2014.
//  Copyright (c) 2014 Peer Assembly. All rights reserved.
//

#import "PAPreferences.h"

// Ensure we get an error if we forget to add @dynamic for each property
#pragma clang diagnostic push
#pragma clang diagnostic error "-Wobjc-missing-property-synthesis"

@interface Preferences : PAPreferences

@property (nonatomic, assign) BOOL hasSeenIntro;
@property (nonatomic, assign) NSInteger pressCount;

@end

#pragma clang diagnostic pop
