//
//  DocumentBrowserViewController.h
//  ReWritor
//
//  Created by Kyle Howells on 25/08/2020.
//

#import <UIKit/UIKit.h>

@interface DocumentBrowserViewController : UIDocumentBrowserViewController

- (void)presentDocumentAtURL:(NSURL *)documentURL;

@end
