//
//  KHSettingsController.m
//  Rewritor
//
//  Created by Kyle Howells on 30/08/2020.
//

#import "KHSettingsController.h"
#import "NSPointerArray+Helpers.h"

@implementation KHSettingsController{
	NSPointerArray *observers;
	NSUserDefaults *userDefaults;
}

+ (instancetype)sharedInstance
{
    static KHSettingsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
	if (self = [super init]) {
		observers = [NSPointerArray weakObjectsPointerArray];
		userDefaults = [NSUserDefaults standardUserDefaults];
		[self loadSettings];
	}
	return self;
}


// MARK: - KHSettingsObserver

-(void)addObserver:(id <KHSettingsObserver>)observer{
	if ([observers containsObject:observer] == NO) {
		[observers addObject:observer];
	}
}

-(void)removeObserver:(id <KHSettingsObserver>)observer{
	[observers removeObject:observer];
}

-(void)settingsChanged{
	[self saveSettings];
	
	for (id <KHSettingsObserver> observer in observers) {
		if ([observer respondsToSelector:@selector(settingsControllerDidUpdate:)]) {
			[observer settingsControllerDidUpdate:self];
		}
	}
}


// MARK: - Load/Save Settings

-(void)loadSettings{
	[userDefaults registerDefaults:@{
		@"_spellChecking": @YES,
		@"_autoCorrection": @YES,
		@"_autoCapitalization": @YES,
		@"_showWordCount": @NO
	}];
	
	_spellChecking = [userDefaults boolForKey:@"_spellChecking"];
	_autoCorrection = [userDefaults boolForKey:@"_autoCorrection"];
	_autoCapitalization = [userDefaults boolForKey:@"_autoCapitalization"];
	_showWordCount = [userDefaults boolForKey:@"_showWordCount"];
}
-(void)saveSettings{
	[userDefaults setBool:_spellChecking forKey:@"_spellChecking"];
	[userDefaults setBool:_autoCorrection forKey:@"_autoCorrection"];
	[userDefaults setBool:_autoCorrection forKey:@"_autoCorrection"];
	[userDefaults setBool:_autoCapitalization forKey:@"_autoCapitalization"];
	[userDefaults setBool:_showWordCount forKey:@"_showWordCount"];
}


// MARK: - Settings

-(void)setSpellChecking:(BOOL)spellChecking{
	_spellChecking = spellChecking;
	[self settingsChanged];
}

-(void)setAutoCorrection:(BOOL)autoCorrection{
	_autoCorrection = autoCorrection;
	[self settingsChanged];
}

-(void)setAutoCapitalization:(BOOL)autoCapitalization{
	_autoCapitalization = autoCapitalization;
	[self settingsChanged];
}

-(void)setShowWordCount:(BOOL)showWordCount{
	_showWordCount = showWordCount;
	[self settingsChanged];
}

@end
