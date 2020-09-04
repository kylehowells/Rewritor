//
//  DocumentEditingView.m
//  Rewritor
//
//  Created by Kyle Howells on 26/08/2020.
//

#import "DocumentEditingView.h"

@implementation DocumentEditingView{
	UIView *_wordCountView;
	UILabel *_wordCountLabel;
	CGFloat counterHeight;
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		counterHeight = 0;
		
		_textView = [[UITextView alloc] init];
		_textView.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightRegular];
//		_textView.font = [UIFont monospacedSystemFontOfSize:11 weight:UIFontWeightRegular];
//		_textView.font = [UIFont fontWithName:@"Menlo" size:12];
		_textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
		_textView.alwaysBounceVertical = YES;
		_textView.automaticallyAdjustsScrollIndicatorInsets = NO;
		_textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		[self addSubview:_textView];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:_textView];
		
		_wordCountView = [[UIView alloc] init];
		_wordCountView.userInteractionEnabled = NO;
		_wordCountView.backgroundColor = [UIColor colorWithWhite:0.975 alpha:1];
		_wordCountView.layer.cornerRadius = 12;
		_wordCountView.layer.borderColor = [UIColor whiteColor].CGColor;//[UIColor colorWithRed: 0.0/255.0 green: 194.0/255.0 blue: 247.0/255.0 alpha: 1.0].CGColor;
		_wordCountView.layer.borderWidth = 1;
		_wordCountView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
		_wordCountView.layer.shadowOffset = CGSizeMake(0, 1);
		_wordCountView.layer.shadowOpacity = 1;
		_wordCountView.layer.shadowRadius = 4;
		[self addSubview:_wordCountView];
		_wordCountView.hidden = YES;
		
		_wordCountLabel = [[UILabel alloc] init];
		_wordCountLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
		_wordCountLabel.text = @"1000 words";
		[_wordCountView addSubview:_wordCountLabel];
		
		[self updateColors];
	}
	return self;
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
	[self updateColors];
}
-(void)updateColors{
	if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
		_wordCountView.backgroundColor = [UIColor colorWithWhite:0.125 alpha:1];
		_wordCountView.layer.borderColor = [UIColor colorWithWhite:0.25 alpha:1].CGColor;
		_wordCountView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.75].CGColor;
	}
	else {
		_wordCountView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
		_wordCountView.layer.borderColor = [UIColor whiteColor].CGColor;
		_wordCountView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
	}

//	self.textView.backgroundColor = [UIColor colorWithRed: 51.0/255.0 green: 255.0/255.0 blue: 51.0/255.0 alpha: 0.25];
//	self.textView.backgroundColor = [UIColor colorWithRed: 40.0/255.0 green: 40.0/255.0 blue: 40.0/255.0 alpha: 1.0];
//	self.textView.textColor = [UIColor colorWithRed: 51.0/255.0 green: 255.0/255.0 blue: 51.0/255.0 alpha: 1.0];
}

-(void)textChanged:(NSNotification*)notification{
	NSLog(@"Text changed: %@", notification);
	UITextView *textV = [notification object];
	if (textV == _textView) {
		[self updateWordCount];
	}
}

-(void)updateWordCount{
	NSString *text = _textView.text ?: @"";
	__block NSInteger wordsCount = 0;
	[text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {wordsCount++;}];
	
	NSString *word = @"Words";
	if (wordsCount == 1) {
		word = @"Word";
	}
	_wordCountLabel.text = [NSString stringWithFormat:@"%ld %@", wordsCount, word];
	[self setNeedsLayout];
}

-(void)setShowsCount:(BOOL)showsCount{
	_showsCount = showsCount;
	_wordCountView.hidden = !_showsCount;
	
	[self updateWordCount];
	[self updatePadding];
	[self setNeedsLayout];
}

-(void)setBottomPadding:(CGFloat)bottomPadding{
	_bottomPadding = MAX(0, bottomPadding);
	[self setNeedsLayout];
	[self updatePadding];
}

-(void)safeAreaInsetsDidChange{
	[self updatePadding];
}

-(void)updatePadding{
	UIEdgeInsets safeArea = self.safeAreaInsets;
	
	UIEdgeInsets contentInsets = ({
		UIEdgeInsets insets = safeArea;
		insets.top = safeArea.top;
		insets.bottom = MAX(safeArea.bottom, _bottomPadding) + (_showsCount ? (counterHeight + 8 + 4) : 0);
		insets;
	});
	_textView.contentInset = contentInsets;
	_textView.scrollIndicatorInsets = contentInsets;
}

-(void)layoutSubviews{
	[super layoutSubviews];
	const CGSize size = self.bounds.size;
	const UIEdgeInsets safeArea = self.safeAreaInsets;
	
	_textView.frame = self.bounds;
	
	CGSize labelSize = [_wordCountLabel sizeThatFits:size];
	
	_wordCountView.frame = ({
		CGRect frame = CGRectZero;
		frame.size.width = labelSize.width + 16;
		frame.size.height = labelSize.height + 8;
		frame.origin.x = (size.width * 0.5) - (frame.size.width * 0.5);
		frame.origin.y = (size.height - (frame.size.height + MAX(safeArea.bottom, _bottomPadding + 8)));
		frame;
	});
	_wordCountLabel.frame = ({
		CGRect frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
		frame.origin.x = (_wordCountView.bounds.size.width - frame.size.width) * 0.5;
		frame.origin.y = (_wordCountView.bounds.size.height - frame.size.height) * 0.5;
		frame;
	});
	_wordCountView.layer.cornerRadius = _wordCountView.frame.size.height * 0.5;
	
	if (counterHeight != _wordCountView.frame.size.height) {
		counterHeight = _wordCountView.frame.size.height;
		[self updatePadding];
	}
}

@end
