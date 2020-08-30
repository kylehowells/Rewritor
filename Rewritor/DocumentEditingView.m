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
		_textView.automaticallyAdjustsScrollIndicatorInsets = NO;
		_textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		[self addSubview:_textView];
	}
	return self;
}

-(void)setBottomPadding:(CGFloat)bottomPadding{
	_bottomPadding = MAX(0, bottomPadding);
	[self safeAreaInsetsDidChange];
}

-(void)safeAreaInsetsDidChange{
	UIEdgeInsets safeArea = self.safeAreaInsets;
	
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(safeArea.top, 0.0, MAX(safeArea.bottom, _bottomPadding), 0.0);
	_textView.contentInset = contentInsets;
	
//	UIEdgeInsets contentInsets = UIEdgeInsetsMake(safeArea.top, 0.0, safeArea.bottom + _bottomPadding, 0.0);
	_textView.scrollIndicatorInsets = contentInsets;
}

-(void)layoutSubviews{
	[super layoutSubviews];
	
	_textView.frame = self.bounds;
}

@end
