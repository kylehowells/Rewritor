//
//  DocumentEditingView.h
//  Rewritor
//
//  Created by Kyle Howells on 26/08/2020.
//

#import <UIKit/UIKit.h>

@interface DocumentEditingView : UIView
@property (nonatomic, readonly) UITextView *textView;
@property (nonatomic, assign) CGFloat bottomPadding;
@property (nonatomic, assign) BOOL showsCount;

-(void)updateWordCount;
@end
