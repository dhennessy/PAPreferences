//
//  PAPreferences.h
//  PAPreferencesSample
//
//  Created by Denis Hennessy on 16/09/2013.
//  Copyright (c) 2013 Peer Assembly. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PAPreferencesDidChangeNotification;
extern NSString * const PAPreferencesChangedPropertyKey;

@interface PAPreferences : NSObject {
    NSDictionary *_properties;
}

@property (nonatomic, assign) BOOL shouldAutomaticallySynchronize;

+ (NSString *)defaultsKeyForPropertyName:(NSString *)key;
+ (instancetype)sharedInstance;

- (BOOL)synchronize;
- (NSUserDefaults *)userDefaults;

@end
