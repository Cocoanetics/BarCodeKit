//
//  BCKCode11CodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 09/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Code11 code characters.
 */
@interface BCKCode11CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates a Code11 end marker code character.
 @returns The end marker code character.
 */
+ (BCKCode11CodeCharacter *)endMarkerCodeCharacter;

/**
 Generates a Code11 spacing character. Code11 spacing characters are not treated as markers.
 @returns The spacing marker code character.
 */
+ (BCKCode11CodeCharacter *)spacingCodeCharacter;

/**
 Generates a code character to represent a Code11 content character.
 @param character The character to encode.
 @returns The content code character for the character.
 */
+ (BCKCode11CodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end