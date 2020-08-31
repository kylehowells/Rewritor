//
//  KHSettingsController.h
//  Rewritor
//
//  Created by Kyle Howells on 30/08/2020.
//

#import <Foundation/Foundation.h>

@class KHSettingsController;

@protocol KHSettingsObserver <NSObject>
@optional
-(void)settingsControllerDidUpdate:(KHSettingsController*)controller;
@end


@interface KHSettingsController : NSObject
+ (instancetype)sharedInstance;

// KHSettingsObserver
-(void)addObserver:(id <KHSettingsObserver>)observer;
-(void)removeObserver:(id <KHSettingsObserver>)observer;

// Settings
@property (nonatomic, assign) BOOL autoCorrection;
@property (nonatomic, assign) BOOL autoCapitalization;
@property (nonatomic, assign) BOOL showWordCount;
@end
