//
//  DocumentEditingView.m
//  Rewritor
//
//  Created by Kyle Howells on 26/08/2020.
//

#import "DocumentEditingView.h"

@implementation DocumentEditingView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_textView = [[UITextView alloc] init];
		_textView.font = [UIFont monospacedSystemFontOfSize:12 weight:UIFontWeightRegular];
		_textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
		_textView.alwaysBounceVertical = YES;
		[self addSubview:_textView];
	}
	return self;
}

-(void)layoutSubviews{
	[super layoutSubviews];
	
	_textView.frame = self.bounds;
}

@end
