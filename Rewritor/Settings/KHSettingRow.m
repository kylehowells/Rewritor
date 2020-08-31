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

+(instancetype)rowWithTitle:(NSString*)title state:(BOOL)state stateChange:(BoolStateChanged)stateChanged{
	return [[KHSettingRowBool alloc] initWithTitle:title state:state stateChange:stateChanged];
}
-(instancetype)initWithTitle:(NSString*)title state:(BOOL)state stateChange:(BoolStateChanged)stateChanged{
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
	[uiSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}
-(void)switchChanged:(UISwitch*)uiSwitch{
	self.state = uiSwitch.on;
}

@end



@implementation KHSettingRowNumber{
	__weak UITableViewCell *_cell;
}

+(instancetype)rowWithTitle:(NSString*)title state:(NSInteger)state stateChange:(NumberStateChanged)stateChanged{
	return [[KHSettingRowNumber alloc] initWithTitle:title state:state stateChange:stateChanged];
}
-(instancetype)initWithTitle:(NSString*)title state:(NSInteger)state stateChange:(NumberStateChanged)stateChanged{
	self = [super initWithTitle:title];
	if (self) {
		self.state = state;
		self.stateChanged = stateChanged;
	}
	return self;
}

-(void)setState:(NSInteger)state{
	_state = state;
	
	_cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.state];
	
	if (self.stateChanged) {
		self.stateChanged(_state);
	}
}

-(void)setupStepper:(UIStepper*)stepper cell:(UITableViewCell*)cell{
	_cell = cell;
	_cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.state];
	
	[stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
}
-(void)stepperChanged:(UIStepper*)stepper{
	self.state = stepper.value;
}

@end
