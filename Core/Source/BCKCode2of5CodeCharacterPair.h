//
//  BCKCode2of5CodeCharacter.h
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Interleaved 2 of 5 codes
 Interleaves a pair of digit characters together
 */
@interface BCKCode2of5CodeCharacterPair : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates an start marker code character, used for Interleaved 2 of 5 codes
 @returns the end marker code character
 */
+ (BCKCode2of5CodeCharacterPair *)startMarkerCodeCharacter;
+ (BCKCode2of5CodeCharacterPair *)endMarkerCodeCharacter;

/**
 Generates a code character to represent a digit character
 @param digit The character to encode
 @returns The digit code character
 */
+ (BCKCode2of5CodeCharacterPair *)codeCharacterForDigitCharacter1:(NSString *)digit1 andDigitCharacter2:(NSString *)digit2;

@end
