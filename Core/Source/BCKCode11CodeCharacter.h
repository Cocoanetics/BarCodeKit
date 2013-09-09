//
//  BCKCode11CodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 09/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Code11 codes
 */
@interface BCKCode11CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates an end marker code character, used for Code 11
 @returns the end marker code character
 */
+ (BCKCode11CodeCharacter *)endMarkerCodeCharacter;

/**
 Generates an spacing character, used for Code 11. Does not count as a marker.
 @returns the end marker code character
 */
+ (BCKCode11CodeCharacter *)spacingCodeCharacter;

/**
 Generates a code character to represent a content character
 @param character The character to encode
 @returns The content code character
 */
+ (BCKCode11CodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end