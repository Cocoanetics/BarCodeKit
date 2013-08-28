//
//  BCKCode93ContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode93CodeCharacter.h"

@interface BCKCode93ContentCodeCharacter : BCKCode93CodeCharacter

/**
 @name Creating Content Characters
 */

/**
 Initialise a content code character using its character
 @returns the content code character
 */
- (instancetype)initWithCharacter:(NSString *)character;

/**
 Initialise a content code character using its character value
 @returns the content code character
 */
- (instancetype)initWithValue:(NSUInteger)characterValue;

/**
 Return a content code character's value
 @returns the content code character's value
 */
- (NSUInteger)characterValue;

@end
