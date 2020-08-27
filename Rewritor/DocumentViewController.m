//
//  DocumentViewController.m
//  ReWritor
//
//  Created by Kyle Howells on 25/08/2020.
//

#import "DocumentViewController.h"

@interface DocumentViewController() <UITextViewDelegate>
@property (nonatomic, readonly) UIBarButtonItem *saveBarButtonItem;
@end

@implementation DocumentViewController
@dynamic view;

-(void)loadView{
	self.view = [[DocumentEditingView alloc] init];
}

// TODO: State restoration
// TODO: Keyboard shortcuts: save/close/text size/open settings/share

-(void)viewDidLoad{
	[super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
	
	_saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(savePressed)];
	self.navigationItem.rightBarButtonItems = @[
		_saveBarButtonItem
	];
	
	_saveBarButtonItem.enabled = NO;
	self.view.textView.delegate = self;
	
	[self registerForKeyboardNotifications];
}

-(void)showPreviewData {
	self.navigationItem.title = @"Preview.txt";
	self.view.textView.text = @"Here's to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They're not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. About the only thing you can't do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do.";
}

- (void)textViewDidChange:(UITextView *)textView{
	self.document.text = textView.text;
	
	[self checkSaveState];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentDidChange) name:UIDocumentStateChangedNotification object:self.document];
	
    // Access the document
    [self.document openWithCompletionHandler:^(BOOL success) {
        if (success) {
            // Display the content of the document, e.g.:
			self.navigationItem.title = self.document.fileURL.lastPathComponent;
			self.view.textView.text = ((Document*)self.document).text;
        } else {
            // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
        }
    }];
}
-(void)checkSaveState{
	_saveBarButtonItem.enabled = [self.document hasChangedToSave];
}

- (void)donePressed:(id)sender {
	if ([self.document hasChangedToSave]) {
		// Prompt to save/revert?
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unsaved Changed" message:@"Do you want to save the changes you made?" preferredStyle:UIAlertControllerStyleActionSheet];

		[alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self savePressed];
			[self dismissViewControllerAnimated:YES completion:nil];
		}]];
		
		[alertController addAction:[UIAlertAction actionWithTitle:@"Don't Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self dismissViewControllerAnimated:YES completion:nil];
		}]];
		
		[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

		[self presentViewController:alertController animated:YES completion:nil];
	}
	else {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}
-(void)savePressed{
	[self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
		NSLog(@"saveToURL: completionHandler: = %d", success);
	}];
	
	[self checkSaveState];
}

-(void)documentDidChange{
	NSLog(@"documentDidChange %ld", self.document.documentState);
	UIDocumentState documentState = self.document.documentState;
	self.view.textView.editable = ((documentState & UIDocumentStateEditingDisabled) != UIDocumentStateEditingDisabled);
	
	if (documentState & UIDocumentStateInConflict) {
		NSURL *documentURL = self.document.fileURL;
		NSArray *conflictVersions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:documentURL];
		for (NSFileVersion *fileVersion in conflictVersions) {
			fileVersion.resolved = YES;
		}
		[NSFileVersion removeOtherVersionsOfItemAtURL:documentURL error:nil];
	}
	else {
		self.view.textView.text = self.document.text;
	}
	
	[self checkSaveState];
}

-(void)findPressed{
//	[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"eyeglasses"] style:UIBarButtonItemStylePlain target:self action:@selector(findPressed)]
}


#pragma mark - Keyboard

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
	NSDictionary* info = [aNotification userInfo];
	CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGSize kbSize = kbRect.size;
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
	
	self.view.textView.contentInset = contentInsets;
	self.view.textView.scrollIndicatorInsets = contentInsets;
	
	// If active text field is hidden by keyboard, scroll it so it's visible
	// Your application might not need or want this behavior.
	
	// Get current selection
	UITextPosition *startPos = self.view.textView.selectedTextRange.start;
	// Get the position in the textview for the caret
	CGRect caretRect = [self.view.textView caretRectForPosition:startPos];
	// Get the position on screen
	CGRect screenCaretRect = [self.view.textView convertRect:caretRect toCoordinateSpace:self.view.window.screen.coordinateSpace];
	
	// If the keyboard's area overlaps the caret, more the scroll view to see the caret.
	if (CGRectIntersectsRect(screenCaretRect, kbRect)) {
		[self.view.textView scrollRangeToVisible:[self.view.textView selectedRange]];
	}
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
	UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	self.view.textView.contentInset = contentInsets;
	self.view.textView.scrollIndicatorInsets = contentInsets;
}

@end
