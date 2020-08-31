//
//  DocumentViewController.m
//  ReWritor
//
//  Created by Kyle Howells on 25/08/2020.
//

#import "DocumentViewController.h"
#import "KHSettingsController.h"
#import "SettingsViewController.h"

@interface DocumentViewController() <UITextViewDelegate, KHSettingsObserver>
@property (nonatomic, readonly) UIBarButtonItem *saveBarButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *settingsBarButtonItem;
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
	
	_settingsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
	
	_saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(savePressed)];
	
	self.navigationItem.leftBarButtonItems = @[
		[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"] style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)],
		_settingsBarButtonItem
	];
	
	self.navigationItem.rightBarButtonItems = @[
		_saveBarButtonItem
	];
	
	_saveBarButtonItem.enabled = NO;
	self.view.textView.delegate = self;
	
	[self registerForKeyboardNotifications];
	
	// Update settings
	[self settingsControllerDidUpdate:[KHSettingsController sharedInstance]];
	// Listen for settings changes
	[[KHSettingsController sharedInstance] addObserver:self];
}

-(void)settingsControllerDidUpdate:(KHSettingsController*)controller{
	
	if (self.view.textView.font.pointSize != controller.fontSize) {
		self.view.textView.font = [self.view.textView.font fontWithSize:controller.fontSize];
	}
	
	self.view.textView.autocorrectionType = controller.autoCorrection ? UITextAutocorrectionTypeYes : UITextAutocorrectionTypeNo;
	self.view.textView.autocapitalizationType = controller.autoCapitalization ? UITextAutocapitalizationTypeSentences : UITextAutocapitalizationTypeNone;
	
	self.view.showsCount = controller.showWordCount;
	
	//@property (nonatomic, assign) BOOL showWordCount;
	
	/*
	 UITextAutocapitalizationType autocapitalizationType;    	UITextAutocapitalizationTypeSentences
	 UITextAutocorrectionType autocorrectionType;       		UITextAutocorrectionTypeDefault
	 UITextSpellCheckingType spellCheckingType					UITextSpellCheckingTypeDefault;
	 UITextSmartQuotesType smartQuotesType 						UITextSmartQuotesTypeDefault;
	 UITextSmartDashesType smartDashesType 						UITextSmartDashesTypeDefault;
	 UITextSmartInsertDeleteType smartInsertDeleteType 			UITextSmartInsertDeleteTypeDefault;
	 */
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
			[self.view updateWordCount];
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
		
		alertController.popoverPresentationController.barButtonItem = sender;
		
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

// TODO: Sort out this method, it's a mess and a source of bugs
-(void)documentDidChange{
	NSLog(@"documentDidChange %ld", self.document.documentState);
	UIDocumentState documentState = self.document.documentState;
//	_saveBarButtonItem.enabled = ((documentState & UIDocumentStateEditingDisabled) != UIDocumentStateEditingDisabled);
	
	NSLog(@"%@", self.view.textView.selectedTextRange);
	
	if (documentState & UIDocumentStateInConflict) {
		NSURL *documentURL = self.document.fileURL;
		NSArray *conflictVersions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:documentURL];
		for (NSFileVersion *fileVersion in conflictVersions) {
			fileVersion.resolved = YES;
		}
		[NSFileVersion removeOtherVersionsOfItemAtURL:documentURL error:nil];
	}
	else if (!self.document.hasChangedToSave && !self.view.textView.isFirstResponder) {
		self.view.textView.text = self.document.text;
		[self.view updateWordCount];
	}
	
	[self checkSaveState];
}

-(void)findPressed{
//	[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"eyeglasses"] style:UIBarButtonItemStylePlain target:self action:@selector(findPressed)]
}


#pragma mark - Keyboard

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification*)aNotification{
	NSDictionary* info = [aNotification userInfo];
	NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve animationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	
	CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGSize kbSize = kbRect.size;
	
	[UIView animateWithDuration:duration delay:0 options:((UIViewAnimationOptions)animationCurve << 16) animations:^{
		self.view.bottomPadding = MAX(0, kbSize.height);
		[self.view layoutIfNeeded];
	} completion:nil];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
	NSDictionary* info = [aNotification userInfo];
	NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve animationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	
	[UIView animateWithDuration:duration delay:0 options:((UIViewAnimationOptions)animationCurve << 16) animations:^{
		self.view.bottomPadding = 0;
		[self.view layoutIfNeeded];
	} completion:nil];
}

#pragma mark - Keyboard Shortcuts

- (NSArray<UIKeyCommand *>*)keyCommands {
    return @[
		[UIKeyCommand keyCommandWithInput:@"," modifierFlags:UIKeyModifierCommand action:@selector(showSettings)]
    ];
}

-(void)showSettings{
	UINavigationController *navController = [[UINavigationController alloc] init];
	SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
	[navController pushViewController:settingsVC animated:NO];
	
	navController.modalPresentationStyle = UIModalPresentationPopover;
	navController.popoverPresentationController.barButtonItem = _settingsBarButtonItem;
	
	[self presentViewController:navController animated:YES completion:nil];
}

@end
