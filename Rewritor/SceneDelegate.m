//
//  SceneDelegate.m
//  Rewritor
//
//  Created by Kyle Howells on 26/08/2020.
//

#import "SceneDelegate.h"
#import "DocumentBrowserViewController.h"

@interface SceneDelegate ()
@property (nonatomic, strong) DocumentBrowserViewController *documentBrowserViewController;
@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
	self.documentBrowserViewController = [[DocumentBrowserViewController alloc] initForOpeningFilesWithContentTypes:nil];
	self.documentBrowserViewController.shouldShowFileExtensions = YES;
	
	self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene*)scene];
	self.window.rootViewController = self.documentBrowserViewController;
	[self.window makeKeyAndVisible];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
	// Called as the scene is being released by the system.
	// This occurs shortly after the scene enters the background, or when its session is discarded.
	// Release any resources associated with this scene that can be re-created the next time the scene connects.
	// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
	// Called when the scene has moved from an inactive state to an active state.
	// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}

- (void)sceneWillResignActive:(UIScene *)scene {
	// Called when the scene will move from an active state to an inactive state.
	// This may occur due to temporary interruptions (ex. an incoming phone call).
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
	// Called as the scene transitions from the background to the foreground.
	// Use this method to undo the changes made on entering the background.
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
	// Called as the scene transitions from the foreground to the background.
	// Use this method to save data, release shared resources, and store enough scene-specific state information
	// to restore the scene back to its current state.
}

-(void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts{
	NSLog(@"scene:scene openURLContexts:%@", URLContexts);
	
	UIOpenURLContext *urlContext = [URLContexts anyObject];
	NSURL *inputURL = [urlContext URL];
	
	if (![inputURL isFileURL]) {
		return;
	}

	// Reveal / import the document at the URL
	[self.documentBrowserViewController revealDocumentAtURL:inputURL importIfNeeded:![urlContext options].openInPlace completion:^(NSURL * _Nullable revealedDocumentURL, NSError * _Nullable error) {
		if (error) {
			// Handle the error appropriately
			NSLog(@"Failed to reveal the document at URL %@ with error: '%@'", inputURL, error);
			return;
		}
		
		// Present the Document View Controller for the revealed URL
		[self.documentBrowserViewController presentDocumentAtURL:revealedDocumentURL];
	}];
}

@end
