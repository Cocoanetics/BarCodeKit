//
//  BCKInterleaved2of5CodeCharacter.h
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Interleaved 2 of 5 codes. Interleaves a pair of digit characters together.
 */
@interface BCKInterleaved2of5CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates the start marker code character.
 @returns The start marker code character.
 */
+ (BCKInterleaved2of5CodeCharacter *)startMarkerCodeCharacter;

/**
 Generates the end marker code character, used for Interleaved 2 of 5 codes.
 @returns The end marker code character.
 */
+ (BCKInterleaved2of5CodeCharacter *)endMarkerCodeCharacter;

/**
 Generates a code character to represent a digit character.
 @param digit1 The first digit to encode.
 @param digit2 The second digit to encode.
 @returns The encoded digit code character.
 */
+ (BCKInterleaved2of5CodeCharacter *)codeCharacterForDigitCharacter1:(NSString *)digit1 andDigitCharacter2:(NSString *)digit2;

@end
