//
//  DocumentBrowserViewController.m
//  Rewritor
//
//  Created by Kyle Howells on 26/08/2020.
//

#import "DocumentBrowserViewController.h"
#import "Document.h"
#import "DocumentViewController.h"

@interface DocumentBrowserViewController () <UIDocumentBrowserViewControllerDelegate>

@end

@implementation DocumentBrowserViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.delegate = self;
	
	self.allowsDocumentCreation = YES;
	self.allowsPickingMultipleItems = NO;
	self.shouldShowFileExtensions = YES;
	
	// Update the style of the UIDocumentBrowserViewController
	// self.browserUserInterfaceStyle = UIDocumentBrowserUserInterfaceStyleDark;
	// self.view.tintColor = [UIColor whiteColor];
	
	self.additionalLeadingNavigationBarButtonItems = @[
		[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)]
	];
}

#pragma mark UIDocumentBrowserViewControllerDelegate

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didRequestDocumentCreationWithHandler:(void (^)(NSURL * _Nullable, UIDocumentBrowserImportMode))importHandler {
	NSURL *newDocumentURL = [[NSBundle mainBundle] URLForResource:@"Untitled" withExtension:@"txt"];
	NSLog(@"controller: %@", controller);
	
	// Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
	// Make sure the importHandler is always called, even if the user cancels the creation request.
	if (newDocumentURL != nil) {
		importHandler(newDocumentURL, UIDocumentBrowserImportModeCopy);
	} else {
		importHandler(newDocumentURL, UIDocumentBrowserImportModeNone);
	}
}

-(void)documentBrowser:(UIDocumentBrowserViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)documentURLs {
	NSURL *sourceURL = documentURLs.firstObject;
	if (!sourceURL) {
		return;
	}
	NSLog(@"-documentBrowser:%@ didPickDocumentsAtURLs:%@", controller, documentURLs);
	
	// Present the Document View Controller for the first document that was picked.
	// If you support picking multiple items, make sure you handle them all.
	[self presentDocumentAtURL:sourceURL];
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didImportDocumentAtURL:(NSURL *)sourceURL toDestinationURL:(NSURL *)destinationURL {
	NSLog(@"-documentBrowser:%@ didImportDocumentAtURL:%@ toDestinationURL:%@", controller, sourceURL, destinationURL);
	// Present the Document View Controller for the new newly created document
	[self presentDocumentAtURL:destinationURL];
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller failedToImportDocumentAtURL:(NSURL *)documentURL error:(NSError * _Nullable)error {
	// Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
}

// MARK: Document Presentation

- (void)presentDocumentAtURL:(NSURL *)documentURL {
	NSLog(@"-presentDocumentAtURL: %@", documentURL);
	UINavigationController *navController = [[UINavigationController alloc] init];
	
	DocumentViewController *documentViewController = [[DocumentViewController alloc] init];
	documentViewController.document = [[Document alloc] initWithFileURL:documentURL];
	
	[navController pushViewController:documentViewController animated:NO];
	navController.modalPresentationStyle = UIModalPresentationFullScreen;
	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Settings

-(void)showSettings:(id)sender{
	
}

@end
