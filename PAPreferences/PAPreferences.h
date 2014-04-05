//
//  PAPreferences.h
//  PAPreferencesSample
//
//  Created by Denis Hennessy on 16/09/2013.
//  Copyright (c) 2013 Peer Assembly. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PAPreferencesDidChangeNotification;

@interface PAPreferences : NSObject {
    NSDictionary *_properties;
}

+ (instancetype)sharedInstance;

- (BOOL)synchronize;

@end
