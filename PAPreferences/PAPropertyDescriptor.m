//
//  PAPropertyDescriptor.m
//  PAPreferencesSample
//
//  Created by Denis Hennessy on 25/01/2014.
//  Copyright (c) 2014 Peer Assembly. All rights reserved.
//

#import "PAPropertyDescriptor.h"

@implementation PAPropertyDescriptor

- (id)initWithDefaultsKey:(NSString *)defaultsKey type:(NSString *)type isSetter:(BOOL)isSetter {
    if (self = [super init]) {
        _defaultsKey = defaultsKey;
        _type = type;
        _isSetter = isSetter;
    }
    return self;
}

@end
