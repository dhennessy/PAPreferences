//
//  PAPreferencesTests.m
//  PAPreferencesSample
//
//  Created by Denis Hennessy on 23/01/2014.
//  Copyright (c) 2014 Peer Assembly. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PAPreferences.h"

NSString * const RemappedTitleKey = @"KEY_TITLE";

@interface MyPreferences : PAPreferences
@property (nonatomic, assign) NSString *username;
@property (nonatomic, assign) NSArray *kids;
@property (nonatomic, assign) NSDictionary *address;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL isOK;
@property (nonatomic, assign, getter=handle, setter=become:) NSString *name;
@property (nonatomic, assign) NSData *data;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) double tilt;
@property (nonatomic, assign) NSURL *site;
@property (nonatomic, assign) NSURLConnection *connection;  // Invalid object type
@property (nonatomic, retain) NSString *fruit;              // Invalid retain specifier
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSDate *date;
@property (nonatomic, assign) NSNumber *number;
@property (nonatomic, assign) NSValue *value;

@property (nonatomic, readonly, assign) NSString *nickname;
@end

@implementation MyPreferences
@dynamic username;
@dynamic kids;
@dynamic address;
@dynamic age;
@dynamic isOK;
@dynamic name;
@dynamic data;
@dynamic height;
@dynamic tilt;
@dynamic site;
@dynamic connection;
@dynamic fruit;
@dynamic title;
@dynamic number;
@dynamic value;

- (NSString *)nickname {
    return self.username;
}

+ (NSString *)defaultsKeyForPropertyName:(NSString *)name {
    if ([name isEqualToString:@"title"]) {
        return RemappedTitleKey;
    }
    return name;
}

@end

static void * const PrivateKVOContext = (void*)&PrivateKVOContext;

@interface PAPreferencesTests : XCTestCase {
    BOOL _seenNotification;
    NSString *_notificationChangedProperty;
}

@end

@implementation PAPreferencesTests

- (void)testArrayPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.kids = @[@"jack", @"jill"];
    NSArray *kids = [[NSUserDefaults standardUserDefaults] objectForKey:@"kids"];
    XCTAssertEqual(kids.count, 2);
    XCTAssertEqualObjects(kids[0], @"jack");
    XCTAssertEqualObjects(kids[1], @"jill");
}

- (void)testArrayRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.kids = @[@"jack", @"jill"];
    XCTAssertEqual(prefs.kids.count, 2);
    XCTAssertEqualObjects(prefs.kids[0], @"jack");
    XCTAssertEqualObjects(prefs.kids[1], @"jill");
}

- (void)testBoolPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.isOK = YES;
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] integerForKey:@"isOK"], YES);
}

- (void)testBoolRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.isOK = YES;
    XCTAssertEqual(prefs.isOK, YES);
}

- (void)testDataPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    NSData *data = [NSData dataWithBytes:"hello" length:5];
    prefs.data = data;
    XCTAssertEqualObjects([[NSUserDefaults standardUserDefaults] dataForKey:@"data"], data);
}

- (void)testDataRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    NSData *data = [NSData dataWithBytes:"hello" length:5];
    prefs.data = data;
    XCTAssertEqualObjects(prefs.data, data);
}

- (void)testDateRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    NSDate *date = [NSDate date];
    prefs.date = date;
    XCTAssertEqualObjects(prefs.date, date);
}

- (void)testDictionaryPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.address = @{@"street": @"Main St", @"city": @"Venice"};
    NSDictionary *address = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    XCTAssertEqual(address.count, 2);
    XCTAssertEqualObjects(address[@"street"], @"Main St");
    XCTAssertEqualObjects(address[@"city"], @"Venice");
}

- (void)testDictionaryRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.address = @{@"street": @"Main St", @"city": @"Venice"};
    XCTAssertEqual(prefs.address.count, 2);
    XCTAssertEqualObjects(prefs.address[@"street"], @"Main St");
    XCTAssertEqualObjects(prefs.address[@"city"], @"Venice");
}

- (void)testDoubleRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.tilt = 0.00000042;
    XCTAssertEqualWithAccuracy(prefs.tilt, 0.00000042, DBL_EPSILON);
}

- (void)testDoublePersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.tilt = 0.00000042;
    XCTAssertEqualWithAccuracy([[NSUserDefaults standardUserDefaults] doubleForKey:@"tilt"], 0.00000042, DBL_EPSILON);
}

- (void)testFloatRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.height = 4.2;
    XCTAssertEqualWithAccuracy(prefs.height, 4.2f, FLT_EPSILON);
}

- (void)testFloatPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.height = 4.2;
    XCTAssertEqualWithAccuracy([[NSUserDefaults standardUserDefaults] floatForKey:@"height"], 4.2f, FLT_EPSILON);
}

- (void)testIntegerPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.age = 42;
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] integerForKey:@"age"], 42);
}

- (void)testIntegerRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.age = 42;
    XCTAssertEqual(prefs.age, 42);
}

- (void)testStringPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.username = @"alice";
    XCTAssertEqualObjects([[NSUserDefaults standardUserDefaults] objectForKey:@"username"], @"alice");
}

- (void)testDefaultsKeyForPropertyNamePersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.title = @"yesterday";
    XCTAssertEqualObjects([[NSUserDefaults standardUserDefaults] objectForKey:RemappedTitleKey], @"yesterday");
}

- (void)testDefaultsKeyForPropertyNameRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    [[NSUserDefaults standardUserDefaults] setObject:@"yesterday" forKey:RemappedTitleKey];
    XCTAssertEqualObjects(prefs.title, @"yesterday");
}

- (void)testStringRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.username = @"alice";
    XCTAssertEqualObjects(prefs.username, @"alice");
}

- (void)testAccessViaInstanceMethod {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    [[NSUserDefaults standardUserDefaults] setObject:@"bob" forKey:@"username"];
    XCTAssertEqualObjects(prefs.nickname, @"bob");
}

- (void)testNumberPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    NSNumber *number = @(23);
    prefs.number = number;
    NSNumber *defaultsNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"number"];
    XCTAssertEqualObjects(defaultsNumber, number);
}

- (void)testNumberRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    NSNumber *number = @(23);
    prefs.number = number;
    XCTAssertEqualObjects(prefs.number, number);
}

- (void)testUrlPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.site = [NSURL URLWithString:@"http://apple.com"];
    XCTAssertEqualObjects([[NSUserDefaults standardUserDefaults] URLForKey:@"site"], [NSURL URLWithString:@"http://apple.com"]);
}

- (void)testUrlRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.site = [NSURL URLWithString:@"http://apple.com"];
    XCTAssertEqualObjects(prefs.site, [NSURL URLWithString:@"http://apple.com"]);
}

- (void)testCodableObjectPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    NSValue *value = [NSValue valueWithRange:NSMakeRange(0, 1)];
    prefs.value = value;
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"value"];
    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:data], value);
}

- (void)testCodableObjectRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    NSValue *value = [NSValue valueWithRange:NSMakeRange(0, 1)];
    prefs.value = value;
    XCTAssertEqualObjects(prefs.value, value);
}


- (void)testPropertyRemoval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.username = @"alice";
    XCTAssertEqualObjects(prefs.username, @"alice");
    prefs.username = nil;
    XCTAssertNil(prefs.username);
    XCTAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"username"]);
}

- (void)testCustomSetter {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    [prefs become:@"joe"];
    XCTAssertEqualObjects([[NSUserDefaults standardUserDefaults] objectForKey:@"name"], @"joe");
}

- (void)testCustomGetter {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    [prefs become:@"joe"];
    XCTAssertEqualObjects(prefs.handle, @"joe");
}

- (void)testValidRespondsToSelector {
    id prefs = [MyPreferences sharedInstance];
    XCTAssertTrue([prefs respondsToSelector:@selector(setUsername:)]);
}

- (void)testInvalidRespondsToSelector {
    id prefs = [MyPreferences sharedInstance];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    XCTAssertFalse([prefs respondsToSelector:@selector(setBogus:)]);
#pragma clang diagnostic pop
}

- (void)testInvalidRetain {
    id prefs = [MyPreferences sharedInstance];
    XCTAssertFalse([prefs respondsToSelector:@selector(setFruit:)]);
}

- (void)testInvalidType {
    id prefs = [MyPreferences sharedInstance];
    XCTAssertFalse([prefs respondsToSelector:@selector(setConnection:)]);
}

- (void)testNotificationPosted {
    _seenNotification = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:PAPreferencesDidChangeNotification object:nil];
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.username = @"bill";
    XCTAssertTrue(_seenNotification);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)testNotificationUserInfo {
    _notificationChangedProperty = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:PAPreferencesDidChangeNotification object:nil];
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.username = @"jack";
    XCTAssertTrue([_notificationChangedProperty isEqualToString:@"username"]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)testAutoSynchronizeDefaultsOn {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    XCTAssertTrue(prefs.shouldAutomaticallySynchronize);
}

- (void)handleNotification:(NSNotification *)notification {
    _seenNotification = YES;
    _notificationChangedProperty = notification.userInfo[PAPreferencesChangedPropertyKey];
}

#if DEBUG
- (void)testInvalidPropertyListPersistence {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    NSValue *value = [NSValue valueWithRange:NSMakeRange(0, 1)];
    XCTAssertThrowsSpecificNamed(prefs.address = @{@"dictKey": value}, NSException, NSInvalidArgumentException);
}
#endif

#pragma mark - KVO

- (void)testObserveArrayValue {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    
    prefs.kids = @[@"tom", @"jerry"];
    
    [prefs addObserver:self
            forKeyPath:@"kids"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.kids = @[@"jack", @"jill"];
}

- (void)testObserveBoolValue {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.isOK = NO;
    
    [prefs addObserver:self
            forKeyPath:@"isOK"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.isOK = YES;
}

- (void)testObserveDataValue {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.isOK = NO;
    
    [prefs addObserver:self
            forKeyPath:@"data"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.data = [NSData dataWithBytes:"hello" length:5];
}

- (void)testObserveDictionaryValue {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    
    prefs.address = @{@"street": @"Main St", @"city": @"Disneyland"};
    
    [prefs addObserver:self
            forKeyPath:@"address"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.address = @{@"street": @"Main St", @"city": @"Venice"};
}

- (void)testObserveDoubleValue {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    
    prefs.tilt = 0.00000041;
    
    [prefs addObserver:self
            forKeyPath:@"tilt"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.tilt = 0.00000042;
}

- (void)testObserveFloatValue {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    
    prefs.height = 4.1;
    
    [prefs addObserver:self
            forKeyPath:@"height"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.height = 4.2;
}

- (void)testObserveIntegerValue {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    
    prefs.age = 41;
    
    [prefs addObserver:self
            forKeyPath:@"age"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.age = 42;
}

- (void)testObserveStringValue {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    
    prefs.username = @"alice";
    
    [prefs addObserver:self
            forKeyPath:@"username"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.username = @"bob";
}

- (void)testObserveNumberValue {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    
    prefs.number = @1;
    
    [prefs addObserver:self
            forKeyPath:@"number"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.number = @2;
}

- (void)testObserveURLValue {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    
    prefs.site = [NSURL URLWithString:@"http://google.com"];
    
    [prefs addObserver:self
            forKeyPath:@"site"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.site = [NSURL URLWithString:@"http://apple.com"];
}

- (void)testObserveCodableObject {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    
    prefs.value = [NSValue valueWithRange:NSMakeRange(0, 1)];
    
    [prefs addObserver:self
            forKeyPath:@"value"
               options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
               context:PrivateKVOContext];
    
    prefs.value = [NSValue valueWithRange:NSMakeRange(0, 2)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (context == PrivateKVOContext) {
        id oldValue = change[NSKeyValueChangeOldKey];
        id newValue = change[NSKeyValueChangeNewKey];
        
        if ([keyPath isEqualToString:@"kids"]) {
            XCTAssertEqualObjects(oldValue[0], @"tom");
            XCTAssertEqualObjects(oldValue[1], @"jerry");
            XCTAssertEqualObjects(newValue[0], @"jack");
            XCTAssertEqualObjects(newValue[1], @"jill");
        } else if ([keyPath isEqualToString:@"data"]) {
            XCTAssertEqualObjects(newValue, [NSData dataWithBytes:"hello" length:5]);
        } else if ([keyPath isEqualToString:@"username"]) {
            XCTAssertEqualObjects(oldValue, @"alice");
            XCTAssertEqualObjects(newValue, @"bob");
        } else if ([keyPath isEqualToString:@"isOK"]) {
            XCTAssertFalse([oldValue boolValue]);
            XCTAssertTrue([newValue boolValue]);
        } else if ([keyPath isEqualToString:@"number"]) {
            XCTAssertEqualObjects(oldValue, @1);
            XCTAssertEqualObjects(newValue, @2);
        } else if ([keyPath isEqualToString:@"address"]) {
            XCTAssertEqualObjects(oldValue[@"street"], @"Main St");
            XCTAssertEqualObjects(oldValue[@"city"], @"Disneyland");
            XCTAssertEqualObjects(newValue[@"street"], @"Main St");
            XCTAssertEqualObjects(newValue[@"city"], @"Venice");
        } else if ([keyPath isEqualToString:@"tilt"]) {
            XCTAssertEqualWithAccuracy([oldValue doubleValue], 0.00000041, DBL_EPSILON);
            XCTAssertEqualWithAccuracy([newValue doubleValue], 0.00000042, DBL_EPSILON);
        } else if ([keyPath isEqualToString:@"height"]) {
            XCTAssertEqualWithAccuracy([oldValue floatValue], 4.1f, FLT_EPSILON);
            XCTAssertEqualWithAccuracy([newValue floatValue], 4.2f, FLT_EPSILON);
        } else if ([keyPath isEqualToString:@"age"]) {
            XCTAssertEqual([oldValue integerValue], 41);
            XCTAssertEqual([newValue integerValue], 42);
        } else if ([keyPath isEqualToString:@"username"]) {
            XCTAssertEqualObjects(oldValue, nil);
            XCTAssertEqualObjects(newValue, @"alice");
        } else if ([keyPath isEqualToString:@"site"]) {
            XCTAssertEqualObjects(oldValue, [NSURL URLWithString:@"http://google.com"]);
            XCTAssertEqualObjects(newValue, [NSURL URLWithString:@"http://apple.com"]);
        } else if ([keyPath isEqualToString:@"value"]) {
            XCTAssertEqualObjects(oldValue, [NSValue valueWithRange:NSMakeRange(0, 1)]);
            XCTAssertEqualObjects(newValue, [NSValue valueWithRange:NSMakeRange(0, 2)]);
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
