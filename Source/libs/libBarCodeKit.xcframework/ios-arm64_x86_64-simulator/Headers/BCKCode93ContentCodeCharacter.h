//
//  BCKCode93ContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode93CodeCharacter.h"

/**
 Specialized subclass of BCKCode93CodeCharacter used to represent content code characters in Code93.
 */
@interface BCKCode93ContentCodeCharacter : BCKCode93CodeCharacter

/**
 @name Creating Content Characters
 */

/**
 Initialise a content code character using one of the 43 regular characters or 4 special characters.
 @param character The character to encode.
 @returns The content code character for the character.
 */
- (instancetype)initWithCharacter:(NSString *)character;

/**
 Initialise a content code character using its character value. Only supports the 43 regular characters and 4 control characters.
 @param characterValue The character value to encode.
 @returns The content code character for the character value.
 */
- (instancetype)initWithValue:(NSUInteger)characterValue;

/**
 Return a content code character's value. Only supports the 43 regular characters and 4 control characters.
 @returns The content code character's value.
 */
- (NSUInteger)characterValue;

@end
