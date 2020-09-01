//
//  Document.h
//  ReWritor
//
//  Created by Kyle Howells on 25/08/2020.
//

#import <UIKit/UIKit.h>

@interface Document : UIDocument
@property (nonatomic, readonly) NSString *originalText;
@property (nonatomic, copy) NSString *text;
-(BOOL)hasChangedToSave;

-(NSData*)bookmarkData;
@end
