//
//  PAPreferences.m
//  PAPreferencesSample
//
//  Created by Denis Hennessy on 16/09/2013.
//  Copyright (c) 2013 Peer Assembly. All rights reserved.
//

#import "PAPreferences.h"
#import "PAPropertyDescriptor.h"
#include <objc/runtime.h>

NSString * const PAPreferencesDidChangeNotification = @"PAPreferencesDidChangeNotification";

static NSMutableDictionary *_dynamicProperties;

BOOL paprefBoolGetter(id self, SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    return [[NSUserDefaults standardUserDefaults] boolForKey:propertyDescriptor.name];
}

void paprefBoolSetter(id self, SEL _cmd, BOOL value) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:propertyDescriptor.name];
    [self synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self];
}

double paprefDoubleGetter(id self, SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    return [[NSUserDefaults standardUserDefaults] doubleForKey:propertyDescriptor.name];
}

void paprefDoubleSetter(id self, SEL _cmd, double value) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:propertyDescriptor.name];
    [self synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self];
}

float paprefFloatGetter(id self, SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    return [[NSUserDefaults standardUserDefaults] floatForKey:propertyDescriptor.name];
}

void paprefFloatSetter(id self, SEL _cmd, float value) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:propertyDescriptor.name];
    [self synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self];
}

NSInteger paprefIntegerGetter(id self, SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    return [[NSUserDefaults standardUserDefaults] integerForKey:propertyDescriptor.name];
}

void paprefIntegerSetter(id self, SEL _cmd, NSInteger value) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:propertyDescriptor.name];
    [self synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self];
}

id paprefObjectGetter(id self, SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    return [[NSUserDefaults standardUserDefaults] objectForKey:propertyDescriptor.name];
}

void paprefObjectSetter(id self, SEL _cmd, id value) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:propertyDescriptor.name];
    [self synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self];
}

NSURL *paprefURLGetter(id self, SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    return [[NSUserDefaults standardUserDefaults] URLForKey:propertyDescriptor.name];
}

void paprefURLSetter(id self, SEL _cmd, NSURL *value) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    [[NSUserDefaults standardUserDefaults] setURL:value forKey:propertyDescriptor.name];
    [self synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self];
}

NSArray *paprefArrayGetter(id self, SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    return [[NSUserDefaults standardUserDefaults] arrayForKey:propertyDescriptor.name];
}

NSDictionary *paprefDictionaryGetter(id self, SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:propertyDescriptor.name];
}

NSData *paprefDataGetter(id self, SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    return [[NSUserDefaults standardUserDefaults] dataForKey:propertyDescriptor.name];
}

NSString *paprefStringGetter(id self, SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    return [[NSUserDefaults standardUserDefaults] stringForKey:propertyDescriptor.name];
}

@implementation PAPreferences

+ (instancetype)sharedInstance {
    static PAPreferences *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _dynamicProperties = [[NSMutableDictionary alloc] init];
        unsigned int cProps;
        objc_property_t *properties = class_copyPropertyList([self class], &cProps);
        for (int i=0; i<cProps; i++) {
            objc_property_t property = properties[i];
            NSString *name = [NSString stringWithUTF8String:property_getName(property)];
            NSString *getterName = name;
            NSString *setterName = [NSString stringWithFormat:@"set%@%@:", [[name substringToIndex:1] capitalizedString], [name substringFromIndex:1]];
            NSString *type = nil;
            BOOL isDynamic = NO;
            BOOL shouldRetain = NO;
            NSArray *elements = [[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","];
            for (NSString *element in elements) {
                NSString *code = [element substringToIndex:1];
                if ([code isEqualToString:@"T"]) {
                    type = [element substringFromIndex:1];
                } else if ([code isEqualToString:@"G"]) {
                    getterName = [element substringFromIndex:1];
                } else if ([code isEqualToString:@"S"]) {
                    setterName = [element substringFromIndex:1];
                } else if ([code isEqualToString:@"D"]) {
                    isDynamic = YES;
                } else if ([code isEqualToString:@"&"]) {
                    shouldRetain = YES;
                }
            }
            if (isDynamic) {
                if (shouldRetain) {
                    NSLog(@"Retained properties are not supported by PAPreferences, use assign instead");
                } else {
                    if ([self isValidType:type]) {
                        _dynamicProperties[getterName] = [[PAPropertyDescriptor alloc] initWithName:name type:type isSetter:NO];
                        _dynamicProperties[setterName] = [[PAPropertyDescriptor alloc] initWithName:name type:type isSetter:YES];
                    } else {
                        NSLog(@"Type of %@ is not supported by PAPreferences", name);
                    }
                }
            }
        }
        if (properties) {
            free(properties);
        }
    }
    
    return self;
}

- (BOOL)isValidType:(NSString *)type {
    unichar typeIndicator = [type characterAtIndex:0];
    switch (typeIndicator) {
#if __LP64__
        case _C_BOOL:
#endif
        case _C_CHR:
        case _C_DBL:
        case _C_FLT:
#if __LP64__
        case _C_LNG_LNG:
#else
        case _C_INT:
#endif
            return YES;
            
        case _C_ID:
            if ([type isEqualToString:@"@\"NSString\""] ||
                [type isEqualToString:@"@\"NSArray\""] ||
                [type isEqualToString:@"@\"NSDictionary\""] ||
                [type isEqualToString:@"@\"NSData\""] ||
                [type isEqualToString:@"@\"NSURL\""]) {
                return YES;
            }
            
        default:
            return NO;
    }
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[selectorString];
    if (propertyDescriptor) {
        IMP getter = 0;
        IMP setter = 0;
        unichar typeIndicator = [propertyDescriptor.type characterAtIndex:0];
        switch (typeIndicator) {
#if __LP64__
            case _C_BOOL:
#endif
            case _C_CHR:
                getter = (IMP)paprefBoolGetter;
                setter = (IMP)paprefBoolSetter;
                break;
                
            case _C_DBL:
                getter = (IMP)paprefDoubleGetter;
                setter = (IMP)paprefDoubleSetter;
                break;
                
            case _C_FLT:
                getter = (IMP)paprefFloatGetter;
                setter = (IMP)paprefFloatSetter;
                break;
                
            case _C_ID:
                getter = (IMP)paprefObjectGetter;
                setter = (IMP)paprefObjectSetter;
                if ([propertyDescriptor.type isEqualToString:@"@\"NSString\""]) {
                    getter = (IMP)paprefStringGetter;
                } else if ([propertyDescriptor.type isEqualToString:@"@\"NSArray\""]) {
                    getter = (IMP)paprefArrayGetter;
                } else if ([propertyDescriptor.type isEqualToString:@"@\"NSDictionary\""]) {
                    getter = (IMP)paprefDictionaryGetter;
                } else if ([propertyDescriptor.type isEqualToString:@"@\"NSData\""]) {
                    getter = (IMP)paprefDataGetter;
                } else if ([propertyDescriptor.type isEqualToString:@"@\"NSURL\""]) {
                    getter = (IMP)paprefURLGetter;
                    setter = (IMP)paprefURLSetter;
                }
                break;
                
#if __LP64__
            case _C_LNG_LNG:
#else
            case _C_INT:
#endif
                getter = (IMP)paprefIntegerGetter;
                setter = (IMP)paprefIntegerSetter;
                break;
                
            default:
                return NO;
        }
        IMP imp = 0;
        char types[20];
        if (propertyDescriptor.isSetter) {
            sprintf(types, "v@:%c", typeIndicator);
            imp = setter;
        } else {
            sprintf(types, "%c@:", typeIndicator);
            imp = getter;
        }
        class_addMethod(self, sel, imp, types);
        return YES;
    }
    
    return NO;
}

- (BOOL)synchronize {
    BOOL result = [[NSUserDefaults standardUserDefaults] synchronize];
    if (!result) {
        NSLog(@"Warning - Failed to synchronise user defaults, some data may be stale");
    }
    return result;
}

@end

