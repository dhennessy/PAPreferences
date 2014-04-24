//
//  PAPreferencesTests.m
//  PAPreferencesSample
//
//  Created by Denis Hennessy on 23/01/2014.
//  Copyright (c) 2014 Peer Assembly. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PAPreferences.h"

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
-(NSString *)nickname;
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
-(NSString *)nickname {
    return self.username;
}
+(NSString *)transformKey:(NSString *)key {
    if ([key isEqualToString:@"title"]) {
        return @"KEY_TITLE";
    }
    return key;
}
@end

@interface PAPreferencesTests : XCTestCase {
    BOOL _seenNotification;
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

- (void)testTransformKeyPersistencd {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    prefs.title = @"yesterday";
    XCTAssertEqualObjects([[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_TITLE"], @"yesterday");
}

- (void)testTransformKeyRetrieval {
    MyPreferences *prefs = [MyPreferences sharedInstance];
    [[NSUserDefaults standardUserDefaults] setObject:@"yesterday" forKey:@"KEY_TITLE"];
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

- (void)handleNotification:(NSNotification *)notification {
    _seenNotification = YES;
}

@end
