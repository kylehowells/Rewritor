//
//  Document.m
//  ReWritor
//
//  Created by Kyle Howells on 25/08/2020.
//

#import "Document.h"

@implementation Document

-(BOOL)hasChangedToSave{
	return ![_originalText isEqualToString:self.text];
}

- (id)contentsForType:(NSString*)typeName error:(NSError **)errorPtr {
	NSLog(@"-[Document contentsForType:%@ error:]", typeName);
    // Encode your document with an instance of NSData or NSFileWrapper
	return [self.text dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)errorPtr {
	NSLog(@"-[Document loadFromContents:%lu ofType:%@ error:]", (unsigned long)[(NSData*)contents length], typeName);
    // Load your document from contents
	
	self.text = [[NSString alloc] initWithData:(NSData*)contents encoding:NSUTF8StringEncoding];
	_originalText = self.text;
	
    return YES;
}

- (void)saveToURL:(NSURL *)url forSaveOperation:(UIDocumentSaveOperation)saveOperation completionHandler:(void (^)(BOOL))completionHandler{
	[super saveToURL:url forSaveOperation:saveOperation completionHandler:completionHandler];
	_originalText = self.text;
}


-(void)setText:(NSString *)text{
//	NSString *oldText = _text;
	_text = [text copy];
	
  // Register the undo operation to support auto-save
//  [self.undoManager setActionName:@"Text Change"];
//  [self.undoManager registerUndoWithTarget:self selector:@selector(setText:) object:oldText];
}

@end
