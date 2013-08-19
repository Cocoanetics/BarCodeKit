//
//  BCKCode39CodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Code39 codes
 */
@interface BCKCode39CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates an end marker code character, used for Code 39
 @returns the end marker code character
 */
+ (BCKCode39CodeCharacter *)endMarkerCodeCharacter;

/**
 Generates an spacing character, used for Code 39. Does not count as a marker.
 @returns the end marker code character
 */
+ (BCKCode39CodeCharacter *)spacingCodeCharacter;

/**
 Generates a code character to represent a content character
 @param character The character to encode
 @returns The content code character
 */
+ (BCKCode39CodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end
