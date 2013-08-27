//
//  BCKCode93CodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Code93 codes
 */
@interface BCKCode93CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates a start code character, used for Code 93
 @returns the start code character
 */
+ (BCKCode93CodeCharacter *)startCodeCharacter;

/**
 Generates a stop code character, used for Code 93
 @returns the stop code character
 */
+ (BCKCode93CodeCharacter *)stopCodeCharacter;

/**
 Generates a termination bar code character, used for Code 93
 @returns the termination bar code character
 */
+ (BCKCode93CodeCharacter *)terminationBarCodeCharacter;

/**
 Generates a code character to represent a content character
 @param character The character to encode
 @returns The content code character
 */
+ (BCKCode93CodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end
