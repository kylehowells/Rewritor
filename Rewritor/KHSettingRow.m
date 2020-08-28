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
+(instancetype)rowWithTitle:(NSString*)title state:(BOOL)state{
	return [[self alloc] initWithTitle:title state:state];
}
-(instancetype)initWithTitle:(NSString*)title state:(BOOL)state{
	self = [super initWithTitle:title];
	if (self) {
		self.state = state;
	}
	return self;
}
@end
