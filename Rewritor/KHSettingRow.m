//
//  KHSettingRow.m
//  Rewritor
//
//  Created by Kyle Howells on 28/08/2020.
//

#import "KHSettingRow.h"

@implementation KHSettingRow
+(instancetype)rowWithTitle:(NSString*)title{
	return [[self alloc] initWithTitle:title];
}
-(instancetype)initWithTitle:(NSString*)title{
	self = [super init];
	if (self) {
		self.title = title;
	}
	return self;
}
@end



@implementation KHSettingRowBool
+(instancetype)rowWithTitle:(NSString*)title state:(BOOL)state stateChange:(StateChanged)stateChanged{
	return [[self alloc] initWithTitle:title state:state stateChange:stateChanged];
}
-(instancetype)initWithTitle:(NSString*)title state:(BOOL)state stateChange:(StateChanged)stateChanged{
	self = [super initWithTitle:title];
	if (self) {
		self.state = state;
		self.stateChanged = stateChanged;
	}
	return self;
}

-(void)setState:(BOOL)state{
	_state = state;
	
	if (self.stateChanged) {
		self.stateChanged(_state);
	}
}

-(void)setupSwitch:(UISwitch*)uiSwitch{
	[uiSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)switchChanged:(UISwitch*)uiSwitch{
	self.state = uiSwitch.on;
}

@end
