//
//  DocumentViewController.h
//  ReWritor
//
//  Created by Kyle Howells on 25/08/2020.
//

#import <UIKit/UIKit.h>
#import "DocumentEditingView.h"
#import "Document.h"

@interface DocumentViewController : UIViewController
@property(null_resettable, nonatomic,strong) DocumentEditingView *view;

@property (nonatomic, strong) Document *document;
@end
