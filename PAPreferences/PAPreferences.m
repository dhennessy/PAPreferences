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
NSString * const PAPreferencesChangedPropertyKey = @"PAPreferencesChangedPropertyKey";

static NSMutableDictionary *_dynamicProperties;


NS_INLINE PAPropertyDescriptor * propertyDescriptorForSelector(SEL _cmd) {
    NSString *selectorString = NSStringFromSelector(_cmd);
    PAPropertyDescriptor *descriptor = _dynamicProperties[selectorString];
    
    return descriptor;
}

NS_INLINE NSString * defaultsKeyForSelector(SEL _cmd) {
    PAPropertyDescriptor *descriptor = propertyDescriptorForSelector(_cmd);
    NSString *defaultsKey = descriptor.defaultsKey;
    
    return defaultsKey;
}

BOOL paprefBoolGetter(id self, SEL _cmd) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] boolForKey:defaultsKey];
}

void paprefBoolSetter(id self, SEL _cmd, BOOL value) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    [[self userDefaults] setBool:value forKey:defaultsKey];
    if ([self shouldAutomaticallySynchronize]) {
        [self synchronize];
    }
    NSDictionary *userInfo = @{PAPreferencesChangedPropertyKey: defaultsKey};
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self userInfo:userInfo];
}

double paprefDoubleGetter(id self, SEL _cmd) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] doubleForKey:defaultsKey];
}

void paprefDoubleSetter(id self, SEL _cmd, double value) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    [[self userDefaults] setDouble:value forKey:defaultsKey];
    if ([self shouldAutomaticallySynchronize]) {
        [self synchronize];
    }
    NSDictionary *userInfo = @{PAPreferencesChangedPropertyKey: defaultsKey};
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self userInfo:userInfo];
}

float paprefFloatGetter(id self, SEL _cmd) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] floatForKey:defaultsKey];
}

void paprefFloatSetter(id self, SEL _cmd, float value) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    [[self userDefaults] setFloat:value forKey:defaultsKey];
    if ([self shouldAutomaticallySynchronize]) {
        [self synchronize];
    }
    NSDictionary *userInfo = @{PAPreferencesChangedPropertyKey: defaultsKey};
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self userInfo:userInfo];
}

NSInteger paprefIntegerGetter(id self, SEL _cmd) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] integerForKey:defaultsKey];
}

void paprefIntegerSetter(id self, SEL _cmd, NSInteger value) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    [[self userDefaults] setInteger:value forKey:defaultsKey];
    if ([self shouldAutomaticallySynchronize]) {
        [self synchronize];
    }
    NSDictionary *userInfo = @{PAPreferencesChangedPropertyKey: defaultsKey};
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self userInfo:userInfo];
}

id paprefObjectGetter(id self, SEL _cmd) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] objectForKey:defaultsKey];
}

void paprefObjectSetter(id self, SEL _cmd, id value) {
#if DEBUG
    if ((value != nil) &&
        ![NSPropertyListSerialization propertyList:value
                                  isValidForFormat:NSPropertyListBinaryFormat_v1_0]) {
        // The specific format above is not particularly important.
		[NSException raise:NSInvalidArgumentException
					format:@"This object is not a valid plist: \n%@.", value];
    }
#endif
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    [[self userDefaults] setObject:value forKey:defaultsKey];
    if ([self shouldAutomaticallySynchronize]) {
        [self synchronize];
    }
    NSDictionary *userInfo = @{PAPreferencesChangedPropertyKey: defaultsKey};
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self userInfo:userInfo];
}

NSURL *paprefURLGetter(id self, SEL _cmd) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] URLForKey:defaultsKey];
}

void paprefURLSetter(id self, SEL _cmd, NSURL *value) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    [[self userDefaults] setURL:value forKey:defaultsKey];
    if ([self shouldAutomaticallySynchronize]) {
        [self synchronize];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self];
}

NSArray *paprefArrayGetter(id self, SEL _cmd) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] arrayForKey:defaultsKey];
}

NSDictionary *paprefDictionaryGetter(id self, SEL _cmd) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] dictionaryForKey:defaultsKey];
}

NSData *paprefDataGetter(id self, SEL _cmd) {
    NSString *defaultsKey = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] dataForKey:defaultsKey];
}

NSString *paprefStringGetter(id self, SEL _cmd) {
    NSString *propertyDescriptorName = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] stringForKey:propertyDescriptorName];
}

NSDate *paprefDateGetter(id self, SEL _cmd) {
    NSString *propertyDescriptorName = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] objectForKey:propertyDescriptorName];
}

NSNumber *paprefNumberGetter(id self, SEL _cmd) {
    NSString *propertyDescriptorName = defaultsKeyForSelector(_cmd);
    return [[self userDefaults] objectForKey:propertyDescriptorName];
}

id paprefCodableObjectGetter(id self, SEL _cmd) {
    id object = nil;
    NSData *data = paprefDataGetter(self, _cmd);
    if (data) {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return object;
}

void paprefCodableObjectSetter(id self, SEL _cmd, id value) {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    paprefObjectSetter(self, _cmd, data);
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

+ (NSString *)defaultsKeyForPropertyName:(NSString *)key {
    return key;
}

// Cause KVO notifications to be emitted even when the corresponding
// value for key is set in NSUserDefaults directly.
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *result = [super keyPathsForValuesAffectingValueForKey:key];
    
    PAPropertyDescriptor *propertyDescriptor = _dynamicProperties[key];
    NSString *defaultsKey = [self defaultsKeyForPropertyName:key];
    if (!propertyDescriptor || !defaultsKey)  return result;
    
    NSString *keyPath = [NSString stringWithFormat:@"userDefaults.%@", defaultsKey];
    return [result setByAddingObject:keyPath];
}

- (instancetype)init {
    if (self = [super init]) {
        _shouldAutomaticallySynchronize = YES;
        _dynamicProperties = [[NSMutableDictionary alloc] init];
        unsigned int cProps;
        objc_property_t *properties = class_copyPropertyList([self class], &cProps);
        for (int i=0; i<cProps; i++) {
            objc_property_t property = properties[i];
            NSString *name = [NSString stringWithUTF8String:property_getName(property)];
            NSString *getterName = [name copy];
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
                    NSLog(@"Retained properties are not supported by PAPreferences, use assign instead.");
                } else {
                    if ([self isValidType:type]) {
                        NSString *defaultsKey = [[self class] defaultsKeyForPropertyName:name];
                        _dynamicProperties[getterName] = [[PAPropertyDescriptor alloc] initWithDefaultsKey:defaultsKey type:type isSetter:NO];
                        _dynamicProperties[setterName] = [[PAPropertyDescriptor alloc] initWithDefaultsKey:defaultsKey type:type isSetter:YES];
                    } else {
                        NSLog(@"Type of %@ is not supported by PAPreferences.", name);
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

NS_INLINE NSString * classNameForTypeString(NSString *typeString) {
    NSString *className = nil;
    
    if ([typeString hasPrefix:@"@\""] &&
        [typeString hasSuffix:@"\""]) {
        const NSUInteger prefixLength = 2;
        const NSUInteger suffixLength = 1;
        const NSUInteger classNameLength = typeString.length - suffixLength - prefixLength;
        className = [typeString substringWithRange:NSMakeRange(prefixLength, classNameLength)];
    }
    
    return className;
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
        {
            NSString *className = classNameForTypeString(type);
            if ([className isEqualToString:@"NSString"] ||
                [className isEqualToString:@"NSArray"] ||
                [className isEqualToString:@"NSDictionary"] ||
                [className isEqualToString:@"NSData"] ||
                [className isEqualToString:@"NSDate"] ||
                [className isEqualToString:@"NSNumber"] ||
                [className isEqualToString:@"NSURL"]) {
                return YES;
            } else {
                Class class = NSClassFromString(className);
                if ([class conformsToProtocol:@protocol(NSCoding)]) {
                    return YES;
                }
            }
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
        NSString *typeString = propertyDescriptor.type;
        unichar typeIndicator = [typeString characterAtIndex:0];
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
            {
                getter = (IMP)paprefObjectGetter;
                setter = (IMP)paprefObjectSetter;
                NSString *className = classNameForTypeString(typeString);
                if (className != nil) {
                    if ([className isEqualToString:@"NSString"]) {
                        getter = (IMP)paprefStringGetter;
                    } else if ([className isEqualToString:@"NSArray"]) {
                        getter = (IMP)paprefArrayGetter;
                    } else if ([className isEqualToString:@"NSDictionary"]) {
                        getter = (IMP)paprefDictionaryGetter;
                    } else if ([className isEqualToString:@"NSData"]) {
                        getter = (IMP)paprefDataGetter;
                    } else if ([className isEqualToString:@"NSDate"]) {
                        getter = (IMP)paprefDateGetter;
                    } else if ([className isEqualToString:@"NSNumber"]) {
                        getter = (IMP)paprefNumberGetter;
                    } else if ([className isEqualToString:@"NSURL"]) {
                        getter = (IMP)paprefURLGetter;
                        setter = (IMP)paprefURLSetter;
                    } else {
                        Class class = NSClassFromString(className);
                        if ([class conformsToProtocol:@protocol(NSCoding)]) {
                            getter = (IMP)paprefCodableObjectGetter;
                            setter = (IMP)paprefCodableObjectSetter;
                        }
                    }
                }
                break;
            }
                
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
    BOOL result = [[self userDefaults] synchronize];
    if (!result) {
        NSLog(@"Warning - Failed to synchronise user defaults, some of the data may be stale.");
    }
    return result;
}

- (NSUserDefaults *)userDefaults {
    return [NSUserDefaults standardUserDefaults];
}

@end

