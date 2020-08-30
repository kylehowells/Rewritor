//
//  NSPointerArray+Helpers.h
//  Light Rings
//
//  Created by Kyle Howells on 31/07/2015.
//  Copyright (c) 2015 Harvey & John. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPointerArray (Helpers)
/**
 *  Adds pointer to the given object to the array.
 *
 *  @param object Object whose pointer needs to be added to the array.
 *  If a pointer to this object already exists in the array, you get a duplicate.
 *  Call containsObject first if you don't want that to happen.
 */
- (void)addObject:(id)object;

/**
 *  Checks if pointer to the given object is present in the array.
 *
 *  @param object Object whose pointer's presence needs to be checked.
 *
 *  @return YES if pointer to the given object is already present in the array; NO otherwise.
 */
- (BOOL)containsObject:(id)object;

/**
 *  Removes a pointer that matches the pointer to the passed in object.
 *
 *  @param object An object that's currently in the array. No ill effects if the object is not in the array.
 */
- (void)removeObject:(id)object;
@end
