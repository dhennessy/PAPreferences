# PAPreferences

An easy way to store user preferences using NSUserDefaults.

PAPreferences maps `dynamic` properties onto NSUserDefaults getters and setters so that you can access defaults as if they were regular properties on an object. That object is normally a singleton since you typically want a single set of preferences for the entire app.

Works with iOS and OSX.

## Adding PAPreferences to your project

The simplest way to add PAPreferences to your project is to use [CocoaPods](http://cocoapods.org). 
Add the following line to your Podfile:

```
	pod 'PAPreferences'
```

If you'd prefer to manually integrate it, just copy `PAPreferences/*.{m,h}` into your project.

## Creating a Preferences Singleton

First, create a subclass of PAPreferences with properties for your settings (note that all properties should have an `assign` storage specifier):

```objective-c
#import "PAPreferences.h"

@interface MyPreferences : PAPreferences
@property (nonatomic, assign) NSString *theme;
@property (nonatomic, assign) NSArray *favorites;
@property (nonatomic, assign) BOOL hasSeenIntro;
@end
```

In the implementation file, mark each property as dynamic:

```objective-c
#import "MyPreferences.h"

@implementation MyPreferences
@dynamic theme;
@dynamic favorites;
@dynamic hasSeenIntro;
@end
```

## Accessing the Preferences

The `sharedInstance` class method can be used to access the singleton:

```objective-c
	if (![MyPreferences sharedInstance].hasSeenIntro) {
		// ...
		[MyPreferences sharedInstance].hasSeenIntro = YES;
	}
```

## Supported Property Types

PAPreferences supports the following property types:

 * NSInteger
 * NSString
 * NSArray
 * NSDictionary
 * NSURL
 * NSData
 * NSDate
 * NSNumber
 * BOOL
 * float
 * double
 * Classes conforming to the NSCoding protocol (including NSSecureCoding).

While you can set mutable values for the properties, you will currently get immutable copies back. Just like when using NSUserDefaults directly.

## Updating UI when Preferences change

Whenever a change is made to a property, a `PAPreferencesDidChangeNotification` notification is posted (with its object set to the PAPreferences subclass).

## How It Works

When a property is first accessed, that selector is mapped to a method that interacts with the NSUserDefaults class. For example, this line:

```objective-c
	hasSeenIntro = YES;
```

expands to a call to a method that behaves like this:

```objective-c
- (void)setHasSeenIntro:(BOOL)value {
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:@"hasSeenIntro"];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPreferencesDidChangeNotification object:self];
}
```

## Setting Defaults

I prefer to set defaults in code, rather than using the traditional NSUserDefaults method.  This is also a useful mechanism to set the first and last version installed for your app. Having these values lets you easily migrate existing users as you add new preferences. Here's an example from my Focus Time app:

    - (id)init {
        if (self = [super init]) {
            NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            if (self.firstVersionInstalled == nil) {
                self.firstVersionInstalled = version;
            
                // Set defaults for new users
                self.pomodoroLength = 1500;
                self.workStartSound = @"alert_gentle_jingle";
                self.workEndSound = @"alert_ring";
                // . . .
            }
        
            self.lastVersionInstalled = version;
        }
        return self;
    }

## Working with iOS Extensions

To share settings between your host app and extension on iOS, you have to use an instance of NSUserDefaults created with `initWithSuiteName:` rather than `standardUserDefaults`. To support this, a subclass of PAPreferences can provide a `userDefaults` implementation of override the default. This is also a good way of caching the instance. Here's a sample implementation:

```objective-c
- (NSUserDefaults *)userDefaults {
    static NSUserDefaults *_cachedDefaults;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cachedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.peerassembly.myapp"];
    });
    
    return _cachedDefaults;
}
```


## Samples

The best examples of how to use the library are in the unit tests - `PAPreferencesTests.m`. However, there's a simple example preferences file also included in the iOS sample.

## Troubleshooting
If you define a property but then forget to add the `@dynamic` line to its implementation file, then everything will appear to work but in reality the compiler is creating an in-memory storage for the property (as if you'd used a `@synthesize` line. These properties won't get saved to NSUserDefaults. To protect against this, it's good practice to wrap your class declaration with:

```objective-c
#pragma clang diagnostic push
#pragma clang diagnostic error "-Wobjc-missing-property-synthesis"
```

and

```objective-c
#pragma clang diagnostic pop
```

## Changelog

### 0.4
 * Add ability to specify an instance of NSUserDefaults other than the standard one. This is important if you're sharing settings with an Extension on iOS
 * Fix iOS sample so that unit tests could run on both iOS and OSX (previously, the tests failed on iOS because the initial view controller accessed the singleton before the test ran).

### 0.3
 * Added automatic synchronize call each time a property is updated (along with a flag to turn it off)
 * Add support for NSDate and NSCoding
 * Refactor getter & setter helper functions
 
Thanks to @Janx2 and @creatd for pull requests.
 
### 0.2
 * Remove bogus warning for unsupported types
 
### 0.1 
 *  Initial release

## Contact

To hear about updates to this and other libraries follow me on Twitter ([@denishennessy](http://twitter.com/denishennessy)) or App.net ([@denishennessy](http://alpha.app.net/denishennessy)).

If you encounter a bug or just thought of a terrific new feature, then opening a github issue is probably the best way to share it. 
Actually, the best way is to send me a pull request...

For anything else, email always works: [denis@peerassembly.com](mailto:denis@peerassembly.com)

## License

```
Copyright (c) 2014, Denis Hennessy (Peer Assembly - http://peerassembly.com)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Peer Assembly, Denis Hennessy nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL PEER ASSEMBLY OR DENIS HENNESSY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

