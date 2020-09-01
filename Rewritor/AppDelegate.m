//
//  AppDelegate.m
//  Rewritor
//
//  Created by Kyle Howells on 26/08/2020.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

/*
 Blog post ideas:
 
 UIScene lifecycle UIDocument based app template
 
 Basics of subclassing UIDocument
 
 UIDocumentBrowserViewController based app programtically (without Main.storyboard)
 
 How to add a settings button to UIDocumentBrowserViewController
 
 UITextView keyboard avoidance and auto scroll
 
 UITableView Settings Screen
 
 Customize SwiftUI previews (light dark, device type, name)
 
 State restoration, UIDocument and security scoped bookmarks
 
 */



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	return YES;
}


#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
	// Called when a new scene session is being created.
	// Use this method to select a configuration to create the new scene with.
	return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
	// Called when the user discards a scene session.
	// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
	// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
