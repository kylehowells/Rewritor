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
@property (nonatomic, readonly) UIBarButtonItem *closeBarButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *saveBarButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *settingsBarButtonItem;
@end

@implementation DocumentViewController
@dynamic view;

-(void)loadView{
	self.view = [[DocumentEditingView alloc] init];
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
	_closeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"] style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
	_settingsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
	
	_saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(savePressed)];
	
	self.navigationItem.leftBarButtonItems = @[
		_closeBarButtonItem,
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
	self.view.textView.smartDashesType = controller.smartInsert ? UITextSmartDashesTypeDefault : UITextSmartDashesTypeNo;
	self.view.textView.smartQuotesType = controller.smartInsert ? UITextSmartQuotesTypeDefault : UITextSmartQuotesTypeNo;
	
	self.view.showsCount = controller.showWordCount;
}

-(NSUserActivity*)documentActivity{
	NSData *data = self.document.bookmarkData;
	if (data == nil) { return nil; }
	
	NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.ikyle.Rewritor.file_open"];
	
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:self.document.fileURL.lastPathComponent forKey:@"kTitle"];
	[dictionary setValue:data forKey:@"kBookmarkData"];
	[dictionary addEntriesFromDictionary:userActivity.userInfo];
	userActivity.userInfo = dictionary;
	userActivity.requiredUserInfoKeys = [NSSet setWithObjects:@"kBookmarkData", nil];
	
	return userActivity;
}

- (void)textViewDidChange:(UITextView *)textView{
	self.document.text = textView.text;
	
	[self checkSaveState];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	self.userActivity = [self documentActivity];
	self.view.window.windowScene.userActivity = [self userActivity];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.view.window.windowScene.userActivity = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentDidChange) name:UIDocumentStateChangedNotification object:self.document];
	
    // Access the document
    [self.document openWithCompletionHandler:^(BOOL success) {
        if (success) {
			NSLog(@"user acivity: %@", self.document.userActivity);
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

-(void)donePressed{
	[self donePressed:self.closeBarButtonItem];
}

static NSInteger closeCount = 0;
- (void)donePressed:(id)sender {
	closeCount++;
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
		[self dismissViewControllerAnimated:YES completion:^{
			if (1 == closeCount) {
				[[UIApplication sharedApplication] sendAction:@selector(openExampleTwo) to:nil from:nil forEvent:nil];
			}
		}];
	}
}
-(void)savePressed{
	[self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
		NSLog(@"saveToURL: completionHandler: = %d", success);
	}];
	
	[self checkSaveState];
}

// TODO: Actually understand this method
-(void)documentDidChange{
	NSLog(@"documentDidChange %ld - %@", self.document.documentState, self.document);
	UIDocumentState documentState = self.document.documentState;
	
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
		[UIKeyCommand commandWithTitle:@"Open Settings" image:nil action:@selector(showSettings) input:@"," modifierFlags:UIKeyModifierCommand propertyList:nil],
		[UIKeyCommand commandWithTitle:@"Save" image:nil action:@selector(showSettings) input:@"s" modifierFlags:UIKeyModifierCommand propertyList:nil],
		[UIKeyCommand commandWithTitle:@"Close" image:nil action:@selector(donePressed) input:@"w" modifierFlags:UIKeyModifierCommand propertyList:nil]
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
