//
//  NSPointerArray+Helpers.m
//  Light Rings
//
//  Created by Kyle Howells on 31/07/2015.
//  Copyright (c) 2015 Harvey & John. All rights reserved.
//

#import "NSPointerArray+Helpers.h"

@implementation NSPointerArray (Helpers)

-(void)addObject:(id)object
{
	[self addPointer:(__bridge void *)object];
}

-(BOOL)containsObject:(id)object
{
	// get passed in object's pointer
	void * objPtr = (__bridge void *)object;
	for (NSUInteger i = 0; i < [self count]; i++) {
		void * ptr = [self pointerAtIndex:i];
		
		if (ptr == objPtr) {
			return YES;
		}
	}
	
	return NO;
}


-(void)removeObject:(id)object
{
	// get pointer to the passed in object
	void * objPtr = (__bridge void *)object;
	NSInteger objIndex = -1;
	for (NSUInteger i = 0; i < [self count]; i++) {
		void * ptr = [self pointerAtIndex:i];
		
		if (ptr == objPtr) {
			// pointers equal, found our object!
			objIndex = i;
			break;
		}
	}
	
	// make sure index is non-nil and not outside bounds
	if (objIndex >= 0 && objIndex < [self count]) {
		[self removePointerAtIndex:objIndex];
	}
	
	[self compact];
}

@end
