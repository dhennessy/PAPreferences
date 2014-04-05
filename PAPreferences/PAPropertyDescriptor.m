//
//  PAPropertyDescriptor.m
//  PAPreferencesSample
//
//  Created by Denis Hennessy on 25/01/2014.
//  Copyright (c) 2014 Peer Assembly. All rights reserved.
//

#import "PAPropertyDescriptor.h"

@implementation PAPropertyDescriptor

- (id)initWithName:(NSString *)name type:(NSString *)type isSetter:(BOOL)isSetter {
    if (self = [super init]) {
        _name = name;
        _type = type;
        _isSetter = isSetter;
    }
    return self;
}

@end
