//
//  DocumentBrowserViewController.h
//  Rewritor
//
//  Created by Kyle Howells on 26/08/2020.
//

#import <UIKit/UIKit.h>

@interface DocumentBrowserViewController : UIDocumentBrowserViewController
- (void)presentDocumentAtURL:(NSURL *)documentURL;
@end
